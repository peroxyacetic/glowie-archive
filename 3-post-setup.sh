#!/usr/bin/env bash

echo -e "\nFINAL SETUP AND CONFIGURATION"
echo "--------------------------------------"
echo "-- GRUB EFI Bootloader Install&Check--"
echo "--------------------------------------"
if [[ -d "/sys/firmware/efi" ]]; then
    grub-install --efi-directory=/boot ${DISK} >/dev/null 2>&1
fi
grub-mkconfig -o /boot/grub/grub.cfg >/dev/null 2>&1

# ------------------------------------------------------------------------

echo -e "\nEnabling essential services"

systemctl enable dhcpcd.service >/dev/null 2>&1
systemctl enable NetworkManager.service >/dev/null 2>&1
echo "
###############################################################################
# Cleaning
###############################################################################
"
# Add sudo rights
sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers >/dev/null 2>&1

betterlockscreen -u /home/snow/.cache/wal/nya.png >/dev/null 2>&1

rm -r -v -f /home/snow/glowie >/dev/null 2>&1
rm -r -v -f /home/snow/glowie-icons >/dev/null 2>&1

# Replace in the same state
cd $pwd >/dev/null 2>&1
echo "
###############################################################################
# Done - Please Eject Install Media and Reboot
###############################################################################
"
