#!/bin/bash

run_as_root() {
    # Check if sudo is available
    if command -v sudo >/dev/null 2>&1; then
        sudo "$@"
    else
        echo "Error sudo not available" >&2
        exit 1
    fi
}

# update pacman mirrorlist
run_as_root rm -f /etc/pacman.d/mirrorlist
run_as_root echo "Server = https://mirror.osbeck.com/archlinux/\$repo/os/\$arch" | sudo tee -a /etc/pacman.d/mirrorlist

# full system upgrade and install packages
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

# install yay aur helper and packages
git clone https://aur.archlinux.org/yay.git --depth 1
cd yay
makepkg -si --noconfirm
cd ..
rm -rf yay

yay -Syyu --needed --noconfirm \
apg \
google-chrome \
visual-studio-code-bin

# copy config files
mkdir -p ~/.config/fish && cp -r configs/fish/* ~/.config/fish
mkdir -p ~/.config/kitty && cp -r configs/kitty/* ~/.config/kitty
mkdir -p ~/.config/yarn && cp -r configs/yarn/* ~/.config/yarn

# restore ssh and gpg keys
mkdir -p temp && cp -r encrypted/* temp && cd temp && mkdir -p decrypted
read -s -p "Enter passphrase: " passphrase
echo
for file in *.gpg; do
    echo "$passphrase" | gpg --batch --yes --passphrase-fd 0 --output "decrypted/${file%.gpg}" --decrypt "$file"
done
cd decrypted
# gpg restore
echo "$passphrase" | gpg --batch --import-options restore --import exported_gpg_key.gpg
rm -f exported_gpg_key.gpg

# ssh restore
mkdir -p ~/.ssh && cp -fr * ~/.ssh
chmod 600 ~/.ssh/*

# cleanup
cd ../.. && rm -rf temp

# install fisher
bash -c 'fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"'
# install fish plugins
bash -c 'fish -c "fisher install IlanCosman/tide@v5"'

# gitconfig
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

# fstab entry for my data partition
if [ ! -e "/dev/nvme0n1p3" ]; then
    echo "Error: /dev/nvme0n1p3 does not exist. Please check the partition" >&2
elif [ -e "/media/shaquib" ]; then
    echo "Error: /media/shaquib already exists and mounted. Skipping" >&2
else
    echo "/dev/nvme0n1p3 exists"
    run_as_root mkdir -p /media/shaquib
    run_as_root chown -R shaquibimdad:shaquibimdad /media/shaquib
    run_as_root echo "/dev/nvme0n1p3 /media/shaquib ntfs-3g auto,users,permissions,exec,uid=1000,gid=1000 0 0" | sudo tee -a /etc/fstab
fi

# change shell to fish
run_as_root usermod -s /usr/bin/fish shaquibimdad

# As of GDM 42 and NVIDIA driver 510, GDM defaults to Wayland. For older NVIDIA drivers (in between version 470 and 510), GDM has chipset-dependent udev rules to use Xorg rather than Wayland. To force-enable Wayland, override these rules by creating the following symlink:
# run_as_root ln -s /dev/null /etc/udev/rules.d/61-gdm.rules
