#!/bin/bash

    bash 0-preinstall.sh
    arch-chroot /mnt /root/glowie/1-setup.sh
    source /mnt/root/glowie/install.conf
    arch-chroot /mnt /usr/bin/runuser -u $username -- /home/$username/glowie/2-user.sh
    arch-chroot /mnt /root/glowie/3-post-setup.sh