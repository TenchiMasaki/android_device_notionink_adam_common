/*
 * Copyright (C) 2012 The Android Open Source Project
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
#include <fcntl.h>

#define LOG_TAG "Tegra PowerHAL"
#include <utils/Log.h>

#include <hardware/hardware.h>
#include <hardware/power.h>

#define BOOST_PATH      "/sys/devices/system/cpu/cpufreq/interactive/boost"
static int boost_fd = -1;
static int boost_warned;

static void sysfs_write(char *path, char *s)
{
    char buf[80];
    int len;
    int fd = open(path, O_WRONLY);

    if (fd < 0) {
        strerror_r(errno, buf, sizeof(buf));
        ALOGE("Error opening %s: %s\n", path, buf);
        return;
    }

    len = write(fd, s, strlen(s));
    if (len < 0) {
        strerror_r(errno, buf, sizeof(buf));
        ALOGE("Error writing to %s: %s\n", path, buf);
    }

    close(fd);
}

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

static void tegra_power_init(struct power_module *module)
{
    /*
     * cpufreq interactive governor: timer 20ms, min sample 100ms,
     * hispeed 700MHz at load 40%
     */

    sysfs_write("/sys/devices/system/cpu/cpufreq/interactive/timer_rate",
                "20000");
    sysfs_write("/sys/devices/system/cpu/cpufreq/interactive/min_sample_time",
                "30000");
    sysfs_write("/sys/devices/system/cpu/cpufreq/interactive/go_hispeed_load",
                "85");
    /* sysfs_write("/sys/devices/system/cpu/cpufreq/interactive/boost_factor",
		"0"); */
    sysfs_write("/sys/devices/system/cpu/cpufreq/interactive/input_boost",
		"1");
}

static void tegra_power_set_interactive(struct power_module *module, int on)
{
    /*
     * Lower maximum frequency when screen is off.  CPU 0 and 1 share a
     * cpufreq policy.
     */

    sysfs_write("/sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq",
                on ? "1300000" : "700000");

    sysfs_write("/sys/devices/system/cpu/cpufreq/interactive/input_boost",
                on ? "1" : "0");

    /* sysfs_write("/sys/devices/system/cpu/cpufreq/interactive/boost_factor",
                on ? "0" : "2"); */

}

static void tegra_power_hint(struct power_module *module, power_hint_t hint,
                            void *data)
{
    char buf[80];
    int len;

    switch (hint) {
    case POWER_HINT_VSYNC:
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
        .name = "Tegra Power HAL",
        .author = "The Android Open Source Project",
        .methods = &power_module_methods,
    },

    .init = tegra_power_init,
    .setInteractive = tegra_power_set_interactive,
    .powerHint = tegra_power_hint,
};
