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
        echo "Error sudo not available" >&2
        exit 1
    fi
}

# update pacman mirrorlist
log "Updating pacman mirrorlist..." 32 1
run_as_root rm -f /etc/pacman.d/mirrorlist
run_as_root echo "Server = https://mirror.osbeck.com/archlinux/\$repo/os/\$arch" | sudo tee -a /etc/pacman.d/mirrorlist
log "Pacman mirrorlist updated" 32 1

# enable parallel downloads and colored output
log "Enabling parallel downloads and colored output..." 32 1
run_as_root sed -i '/^\s*#\(ParallelDownloads\|Color\)/ s/#//' /etc/pacman.conf
log "Parallel downloads and colored output enabled" 32 1

# full system upgrade and install packages
log "Starting full system upgrade and installing packages..." 32 1
run_as_root pacman -Syyu --needed --noconfirm \
    kitty \
    vim \
    exa \
    htop \
    neofetch \
    nvtop \
    fish \
    curl \
    wget \
    ntfs-3g \
    telegram-desktop \
    discord \
    vlc \
    gwenview \
    ktorrent \
    nodejs-lts-gallium \
    yarn \
    python \
    python-pip \
    base-devel \
    noto-fonts-emoji \
    ttf-hack-nerd

log "Full system upgrade and package installation complete" 32 1

# install yay aur helper and packages
log "Installing yay aur helper and packages..." 32 1
git clone https://aur.archlinux.org/yay.git --depth 1
cd yay
makepkg -si --noconfirm
cd ..
rm -rf yay

yay -Syyu --needed --noconfirm \
    apg \
    google-chrome \
    visual-studio-code-bin

log "Yay aur helper and package installation complete" 32 1

# copy config files
log "Copying config files..." 32 1
mkdir -p ~/.config/fish && cp -r configs/fish/* ~/.config/fish
mkdir -p ~/.config/kitty && cp -r configs/kitty/* ~/.config/kitty
cp -r configs/yarn/* ~/

log "Config files copied" 32 1

# restore ssh and gpg keys
log "Restoring ssh and gpg keys..." 32 1
mkdir -p temp && cp -r encrypted/* temp && cd temp && mkdir -p decrypted
read -s -p "Enter passphrase: " passphrase
echo
for file in *.gpg; do
    echo "$passphrase" | gpg --batch --yes --passphrase-fd 0 --output "decrypted/${file%.gpg}" --decrypt "$file"
done
cd decrypted

# gpg restore
echo "$passphrase" | gpg --batch --import-options restore --import exported_gpg_key.gpg
log "gpg key restored" 32 1

rm -f exported_gpg_key.gpg
log "restored gpg key deleted" 32 1

# ssh restore
log "starting ssh key restore" 32 1
mkdir -p ~/.ssh && cp -fr * ~/.ssh
chmod 600 ~/.ssh/*
log "ssh key restored" 32 1

# cleanup
log "cleanup temp dir" 32 1
cd ../.. && rm -rf temp
log "temp dir cleaned" 32 1

# install fisher
log "Installing fisher and plugins..." 32 1
bash -c 'fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"'
# install fish plugins
bash -c 'fish -c "fisher install IlanCosman/tide@v5"'
log "Fisher and plugins installed" 32 1

# gitconfig
log "Setting up gitconfig..." 32 1
git config --global user.name "shaquibimdad"
git config --global user.email "shaquibxyz@gmail.com"
git config --global user.signingkey "shaquibxyz@gmail.com"
git config --global commit.gpgsign true
git config --global gpg.program "gpg2"
git config --global core.editor "vim"
git config --global init.defaultBranch "main"
git config --global pull.rebase true
git config --global pull.ff only
git config --global push.default current
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.st status
git config --global alias.unstage "reset HEAD --"
git config --global alias.last "log -1 HEAD"
git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
git config --global alias.lg2 "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative --all"
log "gitconfig setup complete" 32 1

# enable bluetooth service
log "Enabling bluetooth service..." 32 1
run_as_root systemctl enable bluetooth.service
log "Bluetooth service enabled" 32 1

# fstab entry for my data partition
log "Setting up fstab entry for my data partition..." 32 1
if [ ! -e "/dev/nvme0n1p3" ]; then
    log "Error: /dev/nvme0n1p3 does not exist. Please check the partition" 31 1
elif [ -e "/media/shaquib" ]; then
    log "Error: /media/shaquib already exists and mounted. Skipping" 31 1
else
    log "Creating /media/shaquib and setting permissions..." 32 1
    run_as_root mkdir -p /media/shaquib
    run_as_root chown -R shaquibimdad:shaquibimdad /media/shaquib
    run_as_root echo "/dev/nvme0n1p3 /media/shaquib ntfs-3g auto,users,permissions,exec,uid=1000,gid=1000 0 0" | sudo tee -a /etc/fstab
fi
log "fstab entry for my data partition setup complete" 32 1

# change shell to fish
log "Changing shell to fish..." 32 1
run_as_root usermod -s /usr/bin/fish shaquibimdad
log "Shell changed to fish" 32 1

# desktop environment specific
log "Setting up desktop environment specific configs..." 32 1
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
