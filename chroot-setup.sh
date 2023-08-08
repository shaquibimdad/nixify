#!/bin/bash
echo "Setting up the chroot system..."

# update pacman mirrorlist
rm -f /etc/pacman.d/mirrorlist
echo "Server = https://mirror.osbeck.com/archlinux/\$repo/os/\$arch" | tee -a /etc/pacman.d/mirrorlist

# enable parallel downloads and colored output
sed -i '/^\s*#\(ParallelDownloads\|Color\)/ s/#//' /etc/pacman.conf

# Set the timezone to Asia/Kolkata
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc

# Generate the locale
sed -i '/^#en_US.UTF-8 UTF-8/s/^#//' /etc/locale.gen
locale-gen

# Set the system locale and keymap
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=us" > /etc/vconsole.conf

# Set the hostname and update the hosts file
echo "arch" > /etc/hostname
echo "127.0.0.1       localhost" >> /etc/hosts
echo "::1             localhost" >> /etc/hosts
echo "127.0.1.1       arch" >> /etc/hosts

# Set the root password
passwd

# Add a new user "shaquibimdad" and set their password
useradd -m -g users -G wheel,audio,video -s /bin/bash shaquibimdad
passwd shaquibimdad

# Grant sudo privileges to the user "shaquibimdad"
echo "shaquibimdad ALL=(ALL) ALL" >> /etc/sudoers.d/shaquibimdad

# Install NetworkManager
pacman -Sy --needed --noconfirm networkmanager
systemctl enable NetworkManager
systemctl enable bluetooth.service

# install gnome and packages
pacman -Syyu --needed --noconfirm gnome \
    intel-ucode \
    intel-media-driver \
    mesa-utils \
    libva-intel-driver \
    libva-utils \
    power-profiles-daemon \
    expac \
    sysfsutils \
    mesa-vdpau \
    xorg-xwininfo \
    git \
    nano \
    kitty \
    vim \
    exa \
    zip \
    htop \
    neofetch \
    nvtop \
    fish \
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

systemctl enable gdm
systemctl enable power-profiles-daemon

# Install the boot loader
bootctl --path=/boot install
# Create a boot loader entry for Arch Linuxpp
cat > /boot/loader/entries/arch.conf << EOF
title   Arch Linux
linux   /vmlinuz-linux
initrd  /intel-ucode.img
initrd  /initramfs-linux.img
options root=/dev/nvme0n1p9 rw
EOF

# Fallback entry
cat > /boot/loader/entries/arch-fallback.conf << EOF
title   Arch Linux (FALLBACK ;-;)
linux   /vmlinuz-linux
initrd  /intel-ucode.img
initrd  /initramfs-linux-fallback.img
options root=/dev/nvme0n1p9 rw
EOF

# exit the chroot environment properly
exit
