#!/bin/bash

log "Loading GNOME config..." 32 1
dconf load / < "$(dirname "${BASH_SOURCE[0]}")"/conf/gnome.conf

gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal kitty
# gsettings set com.github.stunkymonkey.nautilus-open-any-terminal keybindings '<Ctrl><Alt>t'
# gsettings set com.github.stunkymonkey.nautilus-open-any-terminal new-tab true
# gsettings set com.github.stunkymonkey.nautilus-open-any-terminal flatpak system

# run_as_root ln -s /dev/null /etc/udev/rules.d/61-gdm.rules

log "GNOME config success" 32 1