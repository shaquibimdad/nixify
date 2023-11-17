export CHROME_EXECUTABLE=google-chrome-stable

export ANDROID_HOME="/media/shaquib/env/android"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export JAVA_HOME="/media/shaquib/env/java/jdk17"

fish_add_path $ANDROID_HOME/cmdline-tools/latest/bin
fish_add_path $ANDROID_HOME/emulator
fish_add_path $ANDROID_HOME/platform-tools
fish_add_path $JAVA_HOME/bin

alias adbc="adb connect $(ip route | grep default | awk '{print $3}'):5555"
alias adbx="adb disconnect $(ip route | grep default | awk '{print $3}'):5555"

alias rnw="yarn react-native run-android --deviceId=$(ip route | grep default | awk '{print $3}'):5555 --active-arch-only"
alias rni="kitty @ set-tab-title 'Util' && kitty @ launch --hold --no-response --cwd current --type tab --title 'JS Server' yarn start --reset-cache && sleep 10 && kitty @ launch --hold --no-response --cwd current  --type tab --title 'Android Build' yarn react-native run-android --active-arch-only"