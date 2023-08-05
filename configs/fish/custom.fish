
alias ls="exa --icons"
#source /usr/share/nvm/init-nvm.sh
alias nv="source /usr/share/nvm/init-nvm.sh"
#source /media/shaquib/projects/python-venvs/django/bin/activate
alias activate="source /media/shaquib/projects/python-venvs/django/bin/activate.fish"

alias adbc="adb connect $(ip route | grep default | awk '{print $3}'):5555"
alias adbx="adb disconnect $(ip route | grep default | awk '{print $3}'):5555"

alias dvr="__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia /opt/resolve/bin/resolve"
alias rnw="yarn react-native run-android --deviceId=$(ip route | grep default | awk '{print $3}'):5555 --active-arch-only"

export PATH="$PATH:`yarn global bin`"
export PATH="/home/shaquibimdad/.local/bin:$PATH"

# gpg-agent
export GPG_TTY=$(tty)

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


#ccache env
export CCACHE_SLOPPINESS=clang_index_store,file_stat_matches,include_file_ctime,include_file_mtime,ivfsoverlay,pch_defines,modules,system_headers,time_macros
export CCACHE_FILECLONE=true
export CCACHE_DEPEND=true
export CCACHE_INODECACHE=true

#compile run delemte he he bwoi!!
alias runcpp 'g++ $argv[1] -o output; ./output; rm -f output'

#DSA
function ppp
  set name $argv[1]
    #set value $argv[2]
    #echo $value
  g++ -o $name $name.cpp && ./$name < input.txt > output.txt && rm $name
end

function gac
  git add .
  git commit --amend --no-edit
  git push -f
end
