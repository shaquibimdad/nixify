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
echo "LANG=en_US.UTF-8" >/etc/locale.conf
echo "KEYMAP=us" >/etc/vconsole.conf

# Set the hostname and update the hosts file
echo "arch" >/etc/hostname
echo "127.0.0.1       localhost" >>/etc/hosts
echo "::1             localhost" >>/etc/hosts
echo "127.0.1.1       arch" >>/etc/hosts

# Set the root password
printf "Enter root password: \n"
passwd

# Add a new user "shaquibimdad" and set their password
useradd -m -g users -G wheel,audio,video -s /bin/bash shaquibimdad

printf "Enter user password: \n"
passwd shaquibimdad

# Grant sudo privileges to the user "shaquibimdad"
echo "shaquibimdad ALL=(ALL) ALL" >>/etc/sudoers.d/shaquibimdad

# install gnome and packages
pacman -Syyu --needed --noconfirm gnome \
    intel-ucode \
    linux-firmware \
    linux-headers \
    intel-media-driver \
    networkmanager \
    bluez \
    nvidia-dkms \
    nvidia-prime \
    zram-generator \
    mesa-utils \
    libva-intel-driver \
    libva-utils \
    power-profiles-daemon \
    expac \
    sysfsutils \
    mesa-vdpau \
    fish \
    wget \
    git \
    ntfs-3g \
    android-udev \
    docker \
    docker-buildx \
    docker-compose \
    noto-fonts-emoji \
    fuse-overlayfs \
    ttf-hack-nerd

usermod -a -G docker shaquibimdad
# change shell to fish
usermod -s /usr/bin/fish shaquibimdad

systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable gdm
systemctl enable power-profiles-daemon
systemctl enable docker
systemctl enable systemd-zram-setup@zramN.service
systemctl enable nvidia-hibernate.service
systemctl enable nvidia-resume.service
systemctl enable nvidia-suspend.service
systemctl enable nvidia-persistenced.service
systemctl enable nvidia-powerd.service

mkdir -p /etc/modprobe.d/
cat >/etc/modprobe.d/nvidia.conf <<EOF
options nvidia NVreg_PreserveVideoMemoryAllocations=1 NVreg_TemporaryFilePath=/var/tmp
EOF

mkdir -p /etc/docker/
cat >/etc/docker/daemon.json <<EOF
{
  "data-root": "/media/shaquib/linuxcore/docker"
}
EOF

cat >/etc/systemd/zram-generator.conf <<EOF
[zram0]
zram-size = 32000
compression-algorithm = lz4
swap-priority = 100
fs-type = swap
EOF

echo "/dev/nvme0n1p3 /media/shaquib ntfs-3g auto,users,permissions,exec,uid=1000,gid=1000,dmask=022,fmask=022 0 0" | tee -a /etc/fstab

# nvidia configs
ln -s /dev/null /etc/udev/rules.d/61-gdm.rules
mkinitcpio -P

# Install the boot loader
bootctl --path=/boot install

# Create a boot loader entry for Arch Linuxpp
cat >/boot/loader/entries/arch.conf <<EOF
title   Arch Linux
linux   /vmlinuz-linux
initrd  /intel-ucode.img
initrd  /initramfs-linux.img
options root=/dev/nvme0n1p4 rw
EOF

# Fallback entry
cat >/boot/loader/entries/arch-fallback.conf <<EOF
title   Arch Linux (FALLBACK ;-;)
linux   /vmlinuz-linux
initrd  /intel-ucode.img
initrd  /initramfs-linux-fallback.img
options root=/dev/nvme0n1p4 rw
EOF

# exit the chroot environment properly
exit
