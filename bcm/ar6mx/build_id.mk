#
# Copyright (C) 2008 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# BUILD_ID is usually used to specify the branch name
# (like "MAIN") or a branch name and a release candidate
# (like "CRB01").  It must be a single word, and is
# capitalized by convention.

#export BUILD_ID=2.0.0-rc2
#export BUILD_NUMBER=20150123

buildnum := $(shell date +%Y%m%d.%H%M%S)
builddtonly := $(shell date +%Y%m%d)
export BUILD_NUMBER=${buildnum}
export BUILD_DATE_ONLY=${builddtonly}

# EMMC size
# TODO: change the U/E8 with TAB3 higher memory configuration
ifeq (${EMMC_SIZE},PRODUCTION)
   export EMMC_MARKER=8
else
   export EMMC_MARKER=4
endif

# For legacy support of first generation TAB
ifeq (${PDI_SOLO},T)
   export CORE_TYPE=S
else
   export CORE_TYPE=Q
endif

# Add TV or AIO marker to build, based more so on front panel 
# for mapping of gpio-keys 
ifeq (${AIO_CONFIGURATION},T)
   export CONFIG_MARKER=AIO
else
   export CONFIG_MARKER=TV
endif

ifeq (${ANDROID_BUILD_MODE},user)
   $(warning Generating user build)
   export MODE_MARKER=U
else
   $(warning Generating engineering build)
   export MODE_MARKER=E
endif

# Final assignment of BUILD_ID
export BUILD_ID=${BUILD_BRANCH}${CORE_TYPE}${MODE_MARKER}${EMMC_MARKER}-${CONFIG_MARKER}-${BUILD_DATE_ONLY}

$(warning The finalized build id is defined to be ${BUILD_ID})
