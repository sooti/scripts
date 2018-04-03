#!/usr/bin/env bash

#COLORS -
red=$'\e[1;31m'
grn=$'\e[1;32m'
blu=$'\e[1;34m'
end=$'\e[0m'


# Assumes source is in users home in a directory called "caf"
export CAFPATH="$HOME/android-pixel"

# Set the tag you want to merge
export TAG="android-8.1.0_r18"

# Set the branch you want to merge it into
export BRANCH="o-mr1"

do_not_merge="
vendor/aosp 
manifest  
external/bash 
device/qcom/sepolicy 
packages/apps/SnapdragonCamera
prebuilts/tools
platform/prebuilts/gcc/darwin-x86/aarch64/aarch64-linux-android-4.9
platform/prebuilts/gcc/darwin-x86/arm/arm-eabi-4.8
platform/prebuilts/gcc/darwin-x86/arm/arm-linux-androideabi-4.9
platform/prebuilts/gcc/darwin-x86/host/i686-apple-darwin-4.2.1
platform/prebuilts/gcc/darwin-x86/mips/mips64el-linux-android-4.9
platform/prebuilts/gcc/darwin-x86/x86/x86_64-linux-android-4.9
platform/prebuilts/gdb/darwin-x86
platform/prebuilts/go/darwin-x86
platform/prebuilts/python/darwin-x86/2.7.5
platform/hardware/intel/audio_media
platform/hardware/intel/bootstub
platform/hardware/intel/common/bd_prov
platform/hardware/intel/common/libmix
platform/hardware/intel/common/libstagefrighthw
platform/hardware/intel/common/libva
platform/hardware/intel/common/libwsbm
platform/hardware/intel/common/omx-components
platform/hardware/intel/common/utils
platform/hardware/intel/common/wrs_omxil_core
platform/hardware/intel/img/hwcomposer
platform/hardware/intel/img/psb_headers
platform/hardware/intel/img/psb_video
platform/hardware/intel/sensors
device/asus/fugu
device/asus/fugu-kernel
device/common
device/generic/arm64
device/generic/armv7-a-neon
device/generic/car
device/generic/common
device/generic/goldfish
device/generic/goldfish-opengl
device/generic/mips
device/generic/mips64
device/generic/mini-emulator-arm64
device/generic/mini-emulator-armv7-a-neon
device/generic/mini-emulator-mips
device/generic/mini-emulator-mips64
device/generic/mini-emulator-x86
device/generic/mini-emulator-x86_64
device/generic/qemu
device/generic/x86
device/generic/x86_64
device/generic/uml
device/google/accessory/arduino
device/google/accessory/demokit
device/google/atv
device/google/contexthub
device/google/dragon
device/google/dragon-kernel
device/google/marlin
device/google/marlin-kernel
device/google/muskie
device/google/taimen
device/google/wahoo
device/google/wahoo-kernel
device/google/vrservices
device/huawei/angler
device/huawei/angler-kernel
device/lge/bullhead
device/lge/bullhead-kernel
device/linaro/bootloader/arm-trusted-firmware
device/linaro/bootloader/edk2
device/linaro/bootloader/OpenPlatformPkg
device/linaro/hikey
device/linaro/hikey-kernel
tools/external/gradle
build/make
external/adt-infra
hardware/qcom/audio
hardware/qcom/data/ipacfg-mgr
hardware/qcom/msm8960
hardware/qcom/msm8994
hardware/qcom/msm8996
hardware/qcom/msm8998
hardware/qcom/msm8x26
hardware/qcom/msm8x27
hardware/qcom/msm8x84
hardware/qcom/msm8x09
hardware/qcom/power
#packages/apps/Browser2
#packages/apps/Calendar
#packages/apps/Contacts
#packages/apps/DeskClock
#packages/apps/DevCamera
#packages/apps/Dialer
#packages/apps/Email
#packages/apps/ExactCalculator
#packages/apps/Gallery
#packages/apps/Gallery2
#packages/apps/Launcher2
#packages/apps/Launcher3
#packages/apps/Messaging
#packages/apps/Music
#packages/apps/Protips
#packages/apps/QuickSearchBox
#packages/apps/UnifiedEmail
#packages/apps/WallpaperPicker
#packages/inputmethods/LatinIME
#toolchain/binutils
#tools/adt/idea
#tools/base
tools/build
#tools/idea
#tools/motodev
#tools/studio/cloud
#tools/swt
#tools/tradefederation/core
device/sample"

cd ${CAFPATH}

for filess in failed success
do
rm $filess 2> /dev/null
touch $filess
done
# CAF manifest is setup with path first, then repo name, so the path attribute is after 2 spaces, and the name within "" in it
for repos in $(grep 'groups=' ${CAFPATH}/.repo/manifests/default.xml  | awk '{print $2}' | cut -d '"' -f2)
do
echo -e ""
if [[ "${do_not_merge}" =~ "${repos}" ]];
then
echo -e "${repos} is not to be merged";
else
echo "$blu Merging $repos $end"
echo -e ""
cd $repos;
git checkout -b $BRANCH
git remote add upstream https://android.googlesource.com/platform/$repos
git fetch --tags upstream
git rebase $TAG
if [ $? -ne 0 ];
then
echo "$repos" >> ${CAFPATH}/failed
echo "$red $repos failed :( $end"
else
echo "$repos" >> ${CAFPATH}/success
echo "$grn $repos succeeded $end"
fi
echo -e ""
cd ${CAFPATH};
fi
done

echo -e ""
echo -e "$red These repos failed $end"
cat ./failed
echo -e ""
echo -e "$grn These succeeded $end"
cat ./success


