#!/bin/bash

sudo pacman -Sy --needed --noconfirm base base-devel \
    curl \
    unzip 

export ANDROID_HOME=/media/shaquib/env/android
export ANDROID_SDK_ROOT=${ANDROID_HOME}
export JAVA_HOME=/media/shaquib/env/java/jdk17

export PATH=${ANDROID_HOME}/cmdline-tools/latest/bin:${JAVA_HOME}/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/emulator:${PATH}

# cleanup 
rm -rf $ANDROID_HOME $HOME/.android
# Set up Android SDK
mkdir -p /media/shaquib/env/android

# Download and extract Android CLI tools
curl -S https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip -o /tmp/cli_tool.zip
mkdir -p ${ANDROID_HOME}/cmdline-tools
unzip -q -d ${ANDROID_HOME}/cmdline-tools /tmp/cli_tool.zip
mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest
rm /tmp/cli_tool.zip

Accept Android SDK licenses
yes | sdkmanager --licenses

# Install required Android packages
sdkmanager "system-images;android-34;google_apis_playstore;x86_64"
sdkmanager "platform-tools"
sdkmanager "platforms;android-34"

# Create and start an Android emulator
mkdir -p $ANDROID_HOME/avd-data
echo "no" | avdmanager create avd --package 'system-images;android-34;google_apis_playstore;x86_64' --name abi_34 --force --path "${ANDROID_HOME}/avd-data"
rm -f $ANDROID_HOME/avd-data/config.ini
cat >$ANDROID_HOME/avd-data/config.ini <<EOF
PlayStore.enabled = no
abi.type = x86_64
avd.id = <build>
avd.ini.encoding = UTF-8
avd.name = <build>
disk.cachePartition = yes
disk.cachePartition.size = 66MB
disk.dataPartition.path = <temp>
disk.dataPartition.size = 6442450944
disk.systemPartition.size = 0
disk.vendorPartition.size = 0
fastboot.forceChosenSnapshotBoot = no
fastboot.forceColdBoot = no
fastboot.forceFastBoot = no
hw.accelerometer = yes
hw.accelerometer_uncalibrated = yes
hw.arc = no
hw.arc.autologin = no
hw.audioInput = yes
hw.audioOutput = yes
hw.battery = yes
hw.camera.back = emulated
hw.camera.front = emulated
hw.cpu.arch = x86_64
hw.cpu.ncore = 4
hw.dPad = yes
hw.display1.density = 0
hw.display1.flag = 0
hw.display1.height = 0
hw.display1.width = 0
hw.display1.xOffset = -1
hw.display1.yOffset = -1
hw.display2.density = 0
hw.display2.flag = 0
hw.display2.height = 0
hw.display2.width = 0
hw.display2.xOffset = -1
hw.display2.yOffset = -1
hw.display3.density = 0
hw.display3.flag = 0
hw.display3.height = 0
hw.display3.width = 0
hw.display3.xOffset = -1
hw.display3.yOffset = -1
hw.displayRegion.0.1.height = 0
hw.displayRegion.0.1.width = 0
hw.displayRegion.0.1.xOffset = -1
hw.displayRegion.0.1.yOffset = -1
hw.displayRegion.0.2.height = 0
hw.displayRegion.0.2.width = 0
hw.displayRegion.0.2.xOffset = -1
hw.displayRegion.0.2.yOffset = -1
hw.displayRegion.0.3.height = 0
hw.displayRegion.0.3.width = 0
hw.displayRegion.0.3.xOffset = -1
hw.displayRegion.0.3.yOffset = -1
hw.gltransport = pipe
hw.gltransport.asg.dataRingSize = 32768
hw.gltransport.asg.writeBufferSize = 1048576
hw.gltransport.asg.writeStepSize = 4096
hw.gltransport.drawFlushInterval = 800
hw.gps = yes
hw.gpu.enabled = yes
hw.gpu.mode = host
hw.gsmModem = yes
hw.gyroscope = yes
hw.initialOrientation = portrait
hw.keyboard = yes
hw.keyboard.charmap = qwerty2
hw.keyboard.lid = yes
hw.lcd.backlight = yes
hw.lcd.circular = false
hw.lcd.density = 160
hw.lcd.depth = 16
hw.lcd.height = 640
hw.lcd.vsync = 60
hw.lcd.width = 320
hw.mainKeys = yes
hw.multi_display_window = no
hw.ramSize = 4096M
hw.rotaryInput = no
hw.screen = multi-touch
hw.sdCard = yes
hw.sensor.hinge = no
hw.sensor.hinge.count = 0
hw.sensor.hinge.fold_to_displayRegion.0.1_at_posture = 1
hw.sensor.hinge.sub_type = 0
hw.sensor.hinge.type = 0
hw.sensor.roll = no
hw.sensor.roll.count = 0
hw.sensor.roll.resize_to_displayRegion.0.1_at_posture = 6
hw.sensor.roll.resize_to_displayRegion.0.2_at_posture = 6
hw.sensor.roll.resize_to_displayRegion.0.3_at_posture = 6
hw.sensors.gyroscope_uncalibrated = yes
hw.sensors.heart_rate = no
hw.sensors.humidity = yes
hw.sensors.light = yes
hw.sensors.magnetic_field = yes
hw.sensors.magnetic_field_uncalibrated = yes
hw.sensors.orientation = yes
hw.sensors.pressure = yes
hw.sensors.proximity = yes
hw.sensors.rgbclight = no
hw.sensors.temperature = yes
hw.sensors.wrist_tilt = no
hw.trackBall = yes
hw.useext4 = yes
image.sysdir.1 = system-images/android-34/google_apis_playstore/x86_64/
kernel.newDeviceNaming = autodetect
kernel.supportsYaffs2 = autodetect
runtime.network.latency = none
runtime.network.speed = full
sdcard.size = 512 MB
showDeviceFrame = yes
tag.display = Google Play
tag.id = google_apis_playstore
test.delayAdbTillBootComplete = 0
test.monitorAdb = 0
test.quitAfterBootTimeOut = -1
vm.heapSize = 512M
EOF