# Android env
export ANDROID_SDK_ROOT="/media/shaquib/env/android-sdk/"
export ANDROID_SDK_TOOLS_DIR="$ANDROID_SDK_ROOT/tools"
export ANDROID_HOME="/media/shaquib/env/android-sdk/"
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
export PATH="$ANDROID_HOME/platform-tools:$PATH"
export PATH="$ANDROID_HOME/emulator/:$PATH"
export PATH="/media/shaquib/env/android-studio/jre/bin:$PATH"
export PATH="/media/shaquib/projects/android-app-dev/flutter/bin:$PATH"
export JAVA_HOME="/media/shaquib/env/android-studio/jre"
export CHROME_EXECUTABLE=google-chrome-stable
export GRADLE_USER_HOME="/media/shaquib/projects/android-app-dev/.gradle/"

alias adbc="adb connect $(ip route | grep default | awk '{print $3}'):5555"
alias adbx="adb disconnect $(ip route | grep default | awk '{print $3}'):5555"

alias rnw="yarn react-native run-android --deviceId=$(ip route | grep default | awk '{print $3}'):5555 --active-arch-only"
alias rni="kitty @ set-tab-title 'Util' && kitty @ launch --hold --no-response --cwd current --type tab --title 'JS Server' yarn start --reset-cache && sleep 10 && kitty @ launch --hold --no-response --cwd current  --type tab --title 'Android Build' yarn react-native run-android --active-arch-only"
