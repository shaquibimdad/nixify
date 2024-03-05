#!/bin/bash

# logging
log() {
    local message=$1
    local color=$2
    local style=$3
    local color_code="\e[${color}m"
    local style_code="\e[${style}m"
    local reset_code="\e[0m"
    echo -e "${style_code}${color_code}${message}${reset_code}"
}

run_as_root() {
    if command -v sudo >/dev/null 2>&1; then
        sudo "$@"
    else
        log "Error sudo not available" 31 1
        exit 1
    fi
}

if ! run_as_root echo ''; then
    log "Error: Permission Denied" 31 1
    exit 1
else
    log "Sudo granted" 32 1
fi

# install yay aur helper and packages
if ! command -v yay >/dev/null 2>&1; then
    log "Installing yay aur helper..." 32 1
    git clone https://aur.archlinux.org/yay.git --depth 1 && cd yay && makepkg -si --noconfirm && cd .. && rm -rf yay
else
    log "Yay is already installed. Skipping installation." 32 1
fi

yay -Sy --needed --noconfirm \
    xorg-xwininfo \
    git \
    nano \
    kitty \
    vim \
    exa \
    zip \
    htop \
    vlc \
    yarn \
    python \
    eog \
    python-pip \
    gwenview \
    ktorrent \
    stow \
    neofetch 

log "Yay aur helper and package installation complete" 32 1

# gitconfig
git config --global user.name "shaquibimdad"
git config --global user.email "shaquibxyz@gmail.com"
git config --global user.signingkey "shaquibxyz@gmail.com"
git config --global commit.gpgsign true
git config --global gpg.program "gpg2"
git config --global core.editor "nano"
git config --global init.defaultBranch "main"
git config --global pull.rebase true
git config --global pull.ff only
git config --global push.default current
git config --global merge.tool meld

log "gitconfig setup complete" 32 1

rm -rf ~/.yarnrc ~/.config/fish ~/.config/kitty ~/.config/chrome-flags.conf
stow -v --adopt --dir . --target ~/ configs

log "Config files linked" 32 1

#desktop environment specific
if [ "$XDG_CURRENT_DESKTOP" = "KDE" ]; then
    log "Setting up KDE config..." 32 1
    source deskenvs/kde/setup.sh
elif [ "$XDG_CURRENT_DESKTOP" = "GNOME" ]; then
    log "GNOME detected..." 32 1
    source deskenvs/gnome/setup.sh
else
    log "Error: Desktop environment not KDE or GNOME" 31 1
    exit 1
fi

_tide_tmp_dir=$(mktemp -d)
__fish_config_dir="/home/$USER/.config/fish"
curl -sSL https://codeload.github.com/ilancosman/tide/tar.gz/v6 | tar -xzC "$_tide_tmp_dir"
cp -R "$_tide_tmp_dir"/*/{completions,conf.d,functions} "$__fish_config_dir"
fish_path=$(command -v fish)
exec "$fish_path" -C "tide configure --auto --style=Classic --prompt_colors='True color' --classic_prompt_color=Dark --show_time='12-hour format' --classic_prompt_separators=Vertical --powerline_prompt_heads=Round --powerline_prompt_tails=Round --powerline_prompt_style='Two lines, character' --prompt_connection=Disconnected --powerline_right_prompt_frame=No --prompt_spacing=Compact --icons='Many icons' --transient=Yes"
