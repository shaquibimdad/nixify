#!/bin/bash

log "Loading GNOME config..." 32 1
dconf load / < "$(dirname "${BASH_SOURCE[0]}")"/conf/gnome.conf

# run_as_root ln -s /dev/null /etc/udev/rules.d/61-gdm.rules

log "GNOME config success" 32 1