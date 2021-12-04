# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
#---------------------------ooooooooooo----------------------#

SAVEHIST=10000  # Save most-recent 1000 lines
HISTFILE=~/.zsh_history

export PATH=$HOME/bin:/usr/local/bin:$PATH

export ANDROID_HOME=/media/shaquib/aalinux/android-env/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
#export JAVA_HOME=/media/shaquib/aalinux/android-env/android-studio-2020.3.1.24-linux/android-studio/jre

export GPG_TTY=$(tty)  #for passkey dialog



#-----My Aliases------#

alias edit='nano -l -im! --minibar'
alias compile='echo -e "\n//--------------------enter below ".c or .cpp" file from list to compile and run-----//\n" && echo -e "\n"&& ls  && echo -e "\n" && read name && gcc $name -o compiled && ./compiled && rm -rf compiled'


# ---- React native ------- #
alias pixel4='emulator -avd Pixel_4_API_30 -no-boot-anim'

#init fresh React native project

alias zzreactnativeinit='echo Enter App Name && read appname && npx react-native init $appname && echo Do you want to launch App Now. yes/no && read yes && if [[ $yes == yes ]]; then
  cd /home/shaquibimdad/$appname && gnome-terminal --tab -- react-native start && sleep 5s && gnome-terminal --tab -- emulator -avd Pixel_4_API_30 -no-boot-anim && sleep 5s && code . && npx react-native run-android 
fi'

#Launch existing React native project

alias zzreactnativestart='gnome-terminal --tab -- react-native start && sleep 5s && gnome-terminal --tab -- emulator -avd Pixel_4_API_30 -no-boot-anim && sleep 5s && code . && npx react-native run-android'

alias ls='ls --color=auto'
alias ll='ls -lav --ignore=..'   # show long listing of all except ".."


#keybindings

bindkey "^[[F" end-of-line
bindkey "^[[H" beginning-of-line





# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
