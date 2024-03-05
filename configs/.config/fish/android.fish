export CHROME_EXECUTABLE=google-chrome-stable

# sdk environment
export ENV_DIR="/media/shaquib/env"
export ANDROID_HOME="$ENV_DIR/android/Sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export JAVA_HOME="$ENV_DIR/android/android-studio/jbr"
export GRADLE_USER_HOME=$ENV_DIR/gradle
export CMAKE_BIN_PATH="$ANDROID_HOME/cmake/3.22.1/bin"
export ANDROID_NDK_HOME="$ANDROID_HOME/ndk/23.1.7779620"

# fish_add_path $ANDROID_SDK_ROOT/cmdline-tools/latest/bin
fish_add_path $ANDROID_SDK_ROOT/emulator
fish_add_path $ANDROID_SDK_ROOT/platform-tools
fish_add_path $JAVA_HOME/bin
# fish_add_path $CMAKE_BIN_PATH/bin

# android studio
fish_add_path $ANDROID_HOME/android-studio/bin/studio.sh
alias astd="studio.sh"


alias rnw="yarn react-native run-android --deviceId=$(ip route | grep default | awk '{print $3}'):5555 --active-arch-only"
alias rni="kitty @ set-tab-title 'Util' && kitty @ launch --hold --no-response --cwd current --type tab --title 'JS Server' yarn start --reset-cache && sleep 10 && kitty @ launch --hold --no-response --cwd current  --type tab --title 'Android Build' yarn react-native run-android --active-arch-only"

#fish_add_path /media/shaquib/aalinux/Downloads/looking-glass-B6-225-22d949c4/client/build
#alias oo='looking-glass-client -F -f /dev/kvmfr0'

function adbc
 adb connect $(ip route | grep default | awk '{print $3}'):5555
end

function adbx
 adb disconnect $(ip route | grep default | awk '{print $3}'):5555
end


function apply_patch
    set commit_hash $argv[1]

    # Check if a commit hash is provided
    if test -z $commit_hash
        echo "Please provide a commit hash as an argument."
        return 1
    end

    # Generate the URL for the patch file
    set patch_url "https://github.com/Danda420/kernel_xiaomi_sm8250/commit/$commit_hash.patch"

    # Download the patch file
    curl $patch_url -o $commit_hash.patch

    # Apply the patch using git am
    git am $commit_hash.patch

    # Clean up the patch file
    #rm $commit_hash.patch
    mv $commit_hash.patch /media/shaquib/kernel-dev/patches/new-base/display/
end
