/*
 * Copyright (C) 2014 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <fcntl.h>
#include <dlfcn.h>
#include <cutils/uevent.h>
#include <errno.h>
#include <sys/poll.h>
#include <pthread.h>
#include <linux/netlink.h>
#include <stdlib.h>
#include <stdbool.h>

#define LOG_TAG "PowerHAL"
#include <utils/Log.h>

#include <hardware/hardware.h>
#include <hardware/power.h>

#define STATE_ON "state=1"
#define STATE_OFF "state=0"
#define STATE_HDR_ON "state=2"
#define STATE_HDR_OFF "state=3"

#define MAX_LENGTH         50
#define BOOST_PULSE       "/sys/devices/system/cpu/cpufreq/interactive/boostpulse"

#define UEVENT_MSG_LEN 2048
#define TOTAL_CPUS 2
#define RETRY_TIME_CHANGING_FREQ 20
#define SLEEP_USEC_BETWN_RETRY 200
#define LOW_POWER_MAX_FREQ "1000000"
#define LOW_POWER_MIN_FREQ "216000"
#define UEVENT_STRING "online@/devices/system/cpu/"

static int boostfd = 0;
static int last_state = -1;
static char last_max_freq[2][10];

static struct pollfd pfd;
static char *cpu_path_min[] = {
    "/sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq",
    "/sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq",
};
static char *cpu_path_max[] = {
    "/sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq",
    "/sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq",
};
static bool freq_set[TOTAL_CPUS];
static bool low_power_mode = false;
static pthread_mutex_t low_power_mode_lock = PTHREAD_MUTEX_INITIALIZER;

static void sysfs_read(const char *path, char *s,int maxlen)
{
    char buf[80];
    int len;
    int fd = open(path, O_RDONLY);

    if (fd < 0) {
        strerror_r(errno, buf, sizeof(buf));
        ALOGE("Error opening %s: %s\n", path, buf);
        return;
    }

    len = read(fd, s, maxlen);
    if (len < 0) {
        strerror_r(errno, buf, sizeof(buf));
        ALOGE("Error reading from %s: %s\n", path, buf);
    }

	s[len]=0;

    close(fd);
}

static int sysfs_write(const char *path, char *s)
{
    char buf[80];
    int len;
    int fd = open(path, O_WRONLY);

    if (fd < 0) {
        strerror_r(errno, buf, sizeof(buf));
        ALOGE("Error opening %s: %s\n", path, buf);
        return -1;
    }

    len = write(fd, s, strlen(s));
    if (len < 0) {
        strerror_r(errno, buf, sizeof(buf));
        ALOGE("Error writing to %s: %s\n", path, buf);
        return -1;
    }

    close(fd);
    return 0;
}

static void save_max_freqs() {
    sysfs_read(cpu_path_max[0], &last_max_freq[0], 10);
    sysfs_read(cpu_path_max[1], &last_max_freq[1], 10);
    if (*last_max_freq[0] == 0)
        *last_max_freq[0] = "1000000";
    if (*last_max_freq[1] == 0)
        *last_max_freq[1] = "1000000";
}

static int restore_max_freq(int cpu) {
     int ret, rest = true;
     ret = sysfs_write(cpu_path_max[cpu], last_max_freq[cpu]);
     if (!ret) {
         rest = false;
     }
     return rest;
}

static void boost_init()
{
    if (!boostfd) {
        char buf[80];
        boostfd = open(BOOST_PULSE, O_WRONLY);
    
        if (boostfd < 0) {
            strerror_r(errno, buf, sizeof(buf));
            ALOGE("Error opening %s: %s\n", BOOST_PULSE, buf);
        }
    }
}

static int uevent_event()
{
    char msg[UEVENT_MSG_LEN];
    char *cp;
    int n, cpu, ret, retry = RETRY_TIME_CHANGING_FREQ;

    n = recv(pfd.fd, msg, UEVENT_MSG_LEN, MSG_DONTWAIT);
    if (n <= 0) {
        return -1;
    }
    if (n >= UEVENT_MSG_LEN) {   /* overflow -- discard */
        return -1;
    }

    cp = msg;

    if (strstr(cp, UEVENT_STRING)) {
        n = strlen(cp);
        errno = 0;
        cpu = strtol(cp + n - 1, NULL, 10);

        if (errno == EINVAL || errno == ERANGE || cpu < 0 || cpu >= TOTAL_CPUS) {
            return -1;
        }

        pthread_mutex_lock(&low_power_mode_lock);
        if (low_power_mode && !freq_set[cpu]) {
            save_max_freqs();
            while (retry) {
                sysfs_write(cpu_path_min[cpu], LOW_POWER_MIN_FREQ);
                ret = sysfs_write(cpu_path_max[cpu], LOW_POWER_MAX_FREQ);
                if (!ret) {
                    freq_set[cpu] = true;
                    break;
                }
                usleep(SLEEP_USEC_BETWN_RETRY);
                retry--;
           }
        } else if (!low_power_mode && freq_set[cpu]) {
             while (retry) {
                 for (cpu = 0; cpu < TOTAL_CPUS; cpu++) {
                     freq_set[cpu] = restore_max_freq(cpu);
                 }
                 usleep(SLEEP_USEC_BETWN_RETRY);
                 retry--;
             }
        }
        pthread_mutex_unlock(&low_power_mode_lock);
    }
    return 0;
}

void *thread_uevent(__attribute__((unused)) void *x)
{
    while (1) {
        int nevents, ret;

        nevents = poll(&pfd, 1, -1);

        if (nevents == -1) {
            if (errno == EINTR)
                continue;
            ALOGE("powerhal: thread_uevent: poll_wait failed\n");
            break;
        }
        ret = uevent_event();
        if (ret < 0)
            ALOGE("Error processing the uevent event");
    }
    return NULL;
}

static void uevent_init()
{
    struct sockaddr_nl client;
    pthread_t tid;
    pfd.fd = socket(PF_NETLINK, SOCK_DGRAM, NETLINK_KOBJECT_UEVENT);

    if (pfd.fd < 0) {
        ALOGE("%s: failed to open: %s", __func__, strerror(errno));
        return;
    }
    memset(&client, 0, sizeof(struct sockaddr_nl));
    pthread_create(&tid, NULL, thread_uevent, NULL);
    client.nl_family = AF_NETLINK;
    client.nl_pid = tid;
    client.nl_groups = -1;
    pfd.events = POLLIN;
    bind(pfd.fd, (void *)&client, sizeof(struct sockaddr_nl));
    return;
}

static void power_init(__attribute__((unused)) struct power_module *module)
{
    ALOGI("%s", __func__);
    boost_init();
    uevent_init();
}

static void cpu_boost(int on)
{
    int rc;
    boost_init();
    if (boostfd == 0) {
        ALOGE("%s: boost file not open", __func__);
        return;
    }

    if (on) {
        rc = write(boostfd, "1", 1);
    } else {
        rc = write(boostfd, "0", 1);
    }

    if (rc < 0) {
        ALOGE("%s: failed to write: %s", __func__, strerror(errno));
    }
}

static void process_video_encode_hint(void *metadata)
{
    boost_init();
    if (boostfd == 0) {
        ALOGE("%s: boost socket not created", __func__);
        return;
    }

    if (metadata) {
        if (!strncmp(metadata, STATE_ON, sizeof(STATE_ON))) {
            /* Video encode started */
            cpu_boost(1);
        } else if (!strncmp(metadata, STATE_OFF, sizeof(STATE_OFF))) {
            /* Video encode stopped */
            cpu_boost(0);
        }  else if (!strncmp(metadata, STATE_HDR_ON, sizeof(STATE_HDR_ON))) {
            /* HDR usecase started */
        } else if (!strncmp(metadata, STATE_HDR_OFF, sizeof(STATE_HDR_OFF))) {
            /* HDR usecase stopped */
        } else
            return;
    } else {
        return;
    }
}


static void touch_boost()
{
    int rc;
    boost_init();
    if (boostfd == 0) {
        ALOGE("%s: boost file not open", __func__);
        return;
    }

    rc = write(boostfd, "1", 1);
    if (rc == 0) {
        ALOGE("%s: failed to write: %s", __func__, strerror(errno));
    }
}

static void power_set_interactive(__attribute__((unused)) struct power_module *module, int on)
{
    if (last_state == -1) {
        last_state = on;
    } else {
        if (last_state == on)
            return;
        else
            last_state = on;
    }

    ALOGV("%s %s", __func__, (on ? "ON" : "OFF"));
    if (on) {
        touch_boost();
    } else {
        cpu_boost(0);
    }
}

static void power_hint( __attribute__((unused)) struct power_module *module,
                      power_hint_t hint, __attribute__((unused)) void *data)
{
    int cpu, ret;

    switch (hint) {
        case POWER_HINT_INTERACTION:
            ALOGV("POWER_HINT_INTERACTION");
            touch_boost();
            break;
#if 0
        case POWER_HINT_VSYNC:
            ALOGV("POWER_HINT_VSYNC %s", (data ? "ON" : "OFF"));
            break;
#endif
        case POWER_HINT_VIDEO_ENCODE:
            process_video_encode_hint(data);
            break;

        case POWER_HINT_LOW_POWER:
             pthread_mutex_lock(&low_power_mode_lock);
             if (data) {
                 save_max_freqs();
                 low_power_mode = true;
                 for (cpu = 0; cpu < TOTAL_CPUS; cpu++) {
                     sysfs_write(cpu_path_min[cpu], LOW_POWER_MIN_FREQ);
                     ret = sysfs_write(cpu_path_max[cpu], LOW_POWER_MAX_FREQ);
                     if (!ret) {
                         freq_set[cpu] = true;
                     }
                 }
             } else {
                 low_power_mode = false;
                 for (cpu = 0; cpu < TOTAL_CPUS; cpu++) {
                     freq_set[cpu] = restore_max_freq(cpu);
                 }
             }
             pthread_mutex_unlock(&low_power_mode_lock);
             break;
        default:
             break;
    }
}

static struct hw_module_methods_t power_module_methods = {
    .open = NULL,
};

struct power_module HAL_MODULE_INFO_SYM = {
    .common = {
        .tag = HARDWARE_MODULE_TAG,
        .module_api_version = POWER_MODULE_API_VERSION_0_2,
        .hal_api_version = HARDWARE_HAL_API_VERSION,
        .id = POWER_HARDWARE_MODULE_ID,
        .name = "Tegra2 Power HAL",
        .author = "The Android Open Source Project",
        .methods = &power_module_methods,
    },

    .init = power_init,
    .setInteractive = power_set_interactive,
    .powerHint = power_hint,
};
