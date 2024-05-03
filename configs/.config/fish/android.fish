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
fish_add_path $ANDROID_SDK_ROOT/tools/bin
fish_add_path $JAVA_HOME/bin
# fish_add_path $CMAKE_BIN_PATH/bin

# android studio
# fish_add_path $ANDROID_HOME/android-studio/bin/studio.sh
# alias astd="studio.sh"


alias rnw="yarn react-native run-android --deviceId=$(ip route | grep default | awk '{print $3}'):5555 --active-arch-only"
# alias rni="kitty @ set-tab-title 'Util' && kitty @ launch --hold --no-response --cwd current --type tab --title 'JS Server' yarn start --reset-cache && sleep 10 && kitty @ launch --hold --no-response --cwd current  --type tab --title 'Android Build' yarn react-native run-android --active-arch-only"

#fish_add_path /media/shaquib/aalinux/Downloads/looking-glass-B6-225-22d949c4/client/build
#alias oo='looking-glass-client -F -f /dev/kvmfr0'

function adbc
 adb connect $(ip route | grep default | awk '{print $3}'):5555
end

function adbx
 adb disconnect $(ip route | grep default | awk '{print $3}'):5555
end

export CCACHE_DIR=/media/shaquib/android-dev/rom-dev/ccache
export USE_CCACHE=1
export CCACHE_EXEC=/usr/bin/ccache

function apply_patch
    set url "$argv[1]"

    # Check if a url is provided
    if test -z $url
        echo "Please provide a commit url as an argument."
        return 1
    end
    
    # Download the patch file
    curl "$url.patch" -o "temp.patch"
    
    # Apply the patch using git am
    git am "temp.patch"

    # Clean up the patch file
    rm "temp.patch"
    # mv $commit_hash.patch /media/shaquib/kernel-dev/patches/new-base/display/
end


function boot
    set -l header_version "3"
    set -l os_patch_level "2024-04-00"
    set -l os_version "13.0.0"
    set -l page_size "4096"
    
    fastboot boot $argv[1] --cmdline "$argv[2]" --header-version $header_version --os-patch-level $os_patch_level --os-version $os_version --page-size $page_size
end
