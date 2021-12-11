#!/bin/bash

bash 0-preinstall.sh
arch-chroot /mnt bash /root/glowie/1-setup.sh
arch-chroot /mnt /usr/bin/runuser -u snow -- bash /home/snow/glowie/2-user.sh
arch-chroot /mnt bash /root/glowie/3-post-setup.sh