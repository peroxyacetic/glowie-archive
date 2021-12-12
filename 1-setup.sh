#!/usr/bin/env bash

echo "Network is being setup"
pacman -S networkmanager dhclient --noconfirm --needed >/dev/null 2>&1
systemctl enable --now NetworkManager >/dev/null 2>&1
pacman -S --noconfirm pacman-contrib curl >/dev/null 2>&1
pacman -S --noconfirm reflector rsync >/dev/null 2>&1
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak >/dev/null 2>&1

nc=$(grep -c ^processor /proc/cpuinfo)
echo "You have " $nc" cores."
echo "Changing the makeflags for "$nc" cores."
TOTALMEM=$(cat /proc/meminfo | grep -i 'memtotal' | grep -o '[[:digit:]]*') >/dev/null 2>&1
if [[  $TOTALMEM -gt 8000000 ]]; then
    sed -i "s/#MAKEFLAGS=\"-j2\"/MAKEFLAGS=\"-j$nc\"/g" /etc/makepkg.conf >/dev/null 2>&1
    echo "Changing the compression settings for "$nc" cores."
    sed -i "s/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T $nc -z -)/g" /etc/makepkg.conf >/dev/null 2>&1
fi
echo "Setting up locale"
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen >/dev/null 2>&1
locale-gen >/dev/null 2>&1
timedatectl --no-ask-password set-timezone Europe/Berlin >/dev/null 2>&1
timedatectl --no-ask-password set-ntp 1 >/dev/null 2>&1
localectl --no-ask-password set-locale LANG="en_US.UTF-8" LC_TIME="en_US.UTF-8" >/dev/null 2>&1

# Set keymaps
localectl --no-ask-password set-keymap de >/dev/null 2>&1

# Add sudo no password rights
sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers >/dev/null 2>&1

#Add parallel downloading
sed -i 's/^#Para/Para/' /etc/pacman.conf >/dev/null 2>&1

#Enable multilib
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf >/dev/null 2>&1
pacman -Sy --noconfirm >/dev/null 2>&1

echo -e "\nInstalling Base System\n"

PKGS=(
    'mesa'
    'xorg'
    'xorg-server'
    'xorg-xwininfo'
    'xorg-xprop'
    'xorg-xinit'
    'xcompmgr'
    'adobe-source-han-sans-jp-fonts'
    'atool'
    'base'
    'base-devel'
    'bc'
    'bluez'
    'bluez-utils'
    'bspwm'
    'chromium'
    'dosfstools'
    'dunst'
    'efibootmgr'
    'ffmpeg'
    'freerdp'
    'gcc'
    'git'
    'gptfdisk'
    'grub'
    'htop'
    'imagemagick'
    'kitty'
    'libnotify'
    'linux'
    'linux-firmware'
    'make'
    'man-db'
    'mediainfo'
    'moreutils'
    'mpv'
    'neofetch'
    'networkmanager'
    'nitrogen'
    'ntfs-3g'
    'p7zip'
    'pamixer'
    'pipewire'
    'pipewire-pulse'
    'pulsemixer'
    'python'
    'python-pip'
    'ranger'
    'rofi'
    'rsync'
    'scrot'
    'socat'
    'starship'
    'sudo'
    'sxiv'
    'sxhkd'
    'thunar'
    'ttc-iosevka'
    'ttf-font-awesome'
    'ufw'
    'unclutter'
    'unrar'
    'unzip'
    'vim'
    'wget'
    'youtube-dl'
    'zathura'
    'zip'
    'zsh'
    'zsh-syntax-highlighting'
    'zsh-autosuggestions'
)

for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    sudo pacman -S "$PKG" --noconfirm --needed >/dev/null 2>&1
done

pip install pywal >/dev/null 2>&1

echo -e "\nDone!\n"
if [ $(whoami) = "root"  ];
then
    useradd -m -G wheel -s /bin/bash snow >/dev/null 2>&1
    passwd snow
    cp -R /root/glowie /home/snow/ >/dev/null 2>&1
    chown -R snow: /home/snow/glowie >/dev/null 2>&1
    sudo hostnamectl set-hostname Meito >/dev/null 2>&1
else
    echo "You are already a user proceed with aur installs"
fi

