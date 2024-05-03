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

rm -rf ~/.yarnrc ~/.config/fish ~/.config/kitty ~/.config/chrome-flags.conf
stow -v --adopt --restow --dir . --target ~/ configs

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