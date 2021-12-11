#!/usr/bin/env bash

echo "Creating the GRUB config"
if [[ -d "/sys/firmware/efi" ]]; then
    grub-install --efi-directory=/boot ${DISK} >/dev/null 2>&1
fi
grub-mkconfig -o /boot/grub/grub.cfg >/dev/null 2>&1

echo -e "\nEnabling essential services"

systemctl enable dhcpcd.service >/dev/null 2>&1
systemctl enable NetworkManager.service >/dev/null 2>&1
echo "Cleaning up the system"

sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers >/dev/null 2>&1

rm -r -v -f /home/snow/glowie >/dev/null 2>&1
rm -r -v -f /home/snow/glowie-icons >/dev/null 2>&1

cd $pwd >/dev/null 2>&1
echo "Done, please eject the installation medium and reboot!"
