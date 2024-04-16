#!/usr/bin/env bash

reflector --country US --latest 5 --sort rate --save /etc/pacman.d/mirrorlist

sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 5/' /etc/pacman.conf

pacstrap -K /mnt base linux linux-firmware nano amd-ucode sudo rsync --noconfirm --needed

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt arch.sh

pacman -Syy

pacman -S pipewire pipewire-pulse pipewire-jack pipewire-alsa pipewire-audio wireplumber grub efibootmgr network-manager-applet bluez bluez-utils --noconfirm --needed

sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
hwclock --systohc

echo KEYMAP=br-abnt2 >> /etc/vconsole.conf

echo "arch" > /etc/hostname
cat <<EOF > /etc/hosts
127.0.0.1	localhost
::1		localhost
127.0.1.1	arch.localdomain	arch
EOF

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch_grub --recheck

grub-mkconfig -o /boot/grub/grub.cfg


