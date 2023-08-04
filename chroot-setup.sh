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

# install gnome
pacman -Sy --needed --noconfirm gnome git nano
systemctl enable gdm

# Install the boot loader
bootctl --path=/boot install
# Create a boot loader entry for Arch Linuxpp
cat > /boot/loader/entries/archpp.conf << EOF
title   Arch Linuxpp
linux   /vmlinuz-linux
initrd  /intel-ucode.img
initrd  /initramfs-linux.img
options root=/dev/nvme0n1p9 rw
EOF

# Stub Fallback initramfs

# exit the chroot environment properly
exit
