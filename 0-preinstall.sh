#!/usr/bin/env bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )" >/dev/null 2>&1
echo "-------------------------------------------------"
echo "Setting up mirrors for optimal download          "
echo "-------------------------------------------------"
iso=$(curl -4 ifconfig.co/country-iso) >/dev/null 2>&1
timedatectl set-ntp true >/dev/null 2>&1
pacman -S --noconfirm pacman-contrib terminus-font >/dev/null 2>&1
setfont ter-v22b >/dev/null 2>&1
sed -i 's/^#Para/Para/' /etc/pacman.conf >/dev/null 2>&1
pacman -S --noconfirm reflector rsync grub >/dev/null 2>&1
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup >/dev/null 2>&1
echo -e "-------------------------------------------------------------------------"
echo -e "-Setting up $iso mirrors for faster downloads"
echo -e "-------------------------------------------------------------------------"

reflector -a 48 -c $iso -f 5 -l 20 --sort rate --save /etc/pacman.d/mirrorlist >/dev/null 2>&1
mkdir /mnt >/dev/null 2>&1


echo -e "\nInstalling prereqs...\n$HR"
pacman -S --noconfirm gptfdisk btrfs-progs >/dev/null 2>&1

echo "-------------------------------------------------"
echo "-------select your disk to format----------------"
echo "-------------------------------------------------"
lsblk
echo "Please enter disk to work on: (example /dev/sda)"
read DISK
echo "THIS WILL FORMAT AND DELETE ALL DATA ON THE DISK"
read -p "are you sure you want to continue (Y/N):" formatdisk
case $formatdisk in

y|Y|yes|Yes|YES)
echo "--------------------------------------"
echo -e "\nFormatting disk...\n$HR"
echo "--------------------------------------"

# disk prep
sgdisk -Z ${DISK} >/dev/null 2>&1 # zap all on disk
sgdisk -a 2048 -o ${DISK} >/dev/null 2>&1 # new gpt disk 2048 alignment

# create partitions
sgdisk -n 1::+1M --typecode=1:ef02 --change-name=1:'BIOSBOOT' ${DISK} >/dev/null 2>&1 # partition 1 (BIOS Boot Partition)
sgdisk -n 2::+100M --typecode=2:ef00 --change-name=2:'EFIBOOT' ${DISK} >/dev/null 2>&1 # partition 2 (UEFI Boot Partition)
sgdisk -n 3::-0 --typecode=3:8300 --change-name=3:'ROOT' ${DISK} >/dev/null 2>&1 # partition 3 (Root), default start, remaining
if [[ ! -d "/sys/firmware/efi" ]]; then
    sgdisk -A 1:set:2 ${DISK} >/dev/null 2>&1
fi

# make filesystems
echo -e "\nCreating Filesystems...\n$HR"
if [[ ${DISK} =~ "nvme" ]]; then
mkfs.vfat -F32 -n "EFIBOOT" "${DISK}p2" >/dev/null 2>&1
mkfs.btrfs -L "ROOT" "${DISK}p3" -f >/dev/null 2>&1
mount -t btrfs "${DISK}p3" /mnt >/dev/null 2>&1
else
mkfs.vfat -F32 -n "EFIBOOT" "${DISK}2" >/dev/null 2>&1
mkfs.btrfs -L "ROOT" "${DISK}3" -f >/dev/null 2>&1
mount -t btrfs "${DISK}3" /mnt >/dev/null 2>&1
fi
ls /mnt | xargs btrfs subvolume delete >/dev/null 2>&1
btrfs subvolume create /mnt/@ >/dev/null 2>&1
umount /mnt >/dev/null 2>&1
;;
*)
echo "Rebooting in 3 Seconds ..." && sleep 1
echo "Rebooting in 2 Seconds ..." && sleep 1
echo "Rebooting in 1 Second ..." && sleep 1
reboot now
;;
esac

# mount target
mount -t btrfs -o subvol=@ -L ROOT /mnt >/dev/null 2>&1
mkdir /mnt/boot >/dev/null 2>&1
mkdir /mnt/boot/efi >/dev/null 2>&1
mount -t vfat -L EFIBOOT /mnt/boot/ >/dev/null 2>&1

if ! grep -qs '/mnt' /proc/mounts; then
    echo "Drive is not mounted can not continue"
    echo "Rebooting in 3 Seconds ..." && sleep 1
    echo "Rebooting in 2 Seconds ..." && sleep 1
    echo "Rebooting in 1 Second ..." && sleep 1
    reboot now
fi

echo "--------------------------------------"
echo "-- Arch Install on Main Drive       --"
echo "--------------------------------------"
pacstrap /mnt base base-devel linux linux-firmware vim sudo archlinux-keyring wget libnewt --noconfirm --needed >/dev/null 2>&1
genfstab -U /mnt >> /mnt/etc/fstab >/dev/null 2>&1
echo "keyserver hkp://keyserver.ubuntu.com" >> /mnt/etc/pacman.d/gnupg/gpg.conf >/dev/null 2>&1
cp -R ${SCRIPT_DIR} /mnt/root/glowie >/dev/null 2>&1
cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist >/dev/null 2>&1
echo "--------------------------------------"
echo "--GRUB BIOS Bootloader Install&Check--"
echo "--------------------------------------"
if [[ ! -d "/sys/firmware/efi" ]]; then
    grub-install --boot-directory=/mnt/boot ${DISK} >/dev/null 2>&1
fi
echo "--------------------------------------"
echo "-- Check for low memory systems <8G --"
echo "--------------------------------------"
TOTALMEM=$(cat /proc/meminfo | grep -i 'memtotal' | grep -o '[[:digit:]]*') >/dev/null 2>&1
if [[  $TOTALMEM -lt 8000000 ]]; then
    #Put swap into the actual system, not into RAM disk, otherwise there is no point in it, it'll cache RAM into RAM. So, /mnt/ everything.
    mkdir /mnt/opt/swap >/dev/null 2>&1 #make a dir that we can apply NOCOW to to make it btrfs-friendly.
    chattr +C /mnt/opt/swap >/dev/null 2>&1 #apply NOCOW, btrfs needs that.
    dd if=/dev/zero of=/mnt/opt/swap/swapfile bs=1M count=2048 status=progress >/dev/null 2>&1
    chmod 600 /mnt/opt/swap/swapfile >/dev/null 2>&1 #set permissions.
    chown root /mnt/opt/swap/swapfile >/dev/null 2>&1
    mkswap /mnt/opt/swap/swapfile >/dev/null 2>&1
    swapon /mnt/opt/swap/swapfile >/dev/null 2>&1
    #The line below is written to /mnt/ but doesn't contain /mnt/, since it's just / for the sysytem itself.
    echo "/opt/swap/swapfile	none	swap	sw	0	0" >> /mnt/etc/fstab >/dev/null 2>&1 #Add swap to fstab, so it KEEPS working after installation. 
fi
echo "--------------------------------------"
echo "--   SYSTEM READY FOR 1-setup       --"
echo "--------------------------------------"
