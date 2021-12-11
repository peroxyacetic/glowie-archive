#!/usr/bin/env bash

echo -e "\nInstalling AUR Software\n"

echo "Installing: yay"
mkdir /home/snow/source
cd /home/snow/source >/dev/null 2>&1
git clone "https://aur.archlinux.org/yay.git" >/dev/null 2>&1
cd yay >/dev/null 2>&1
makepkg -si --noconfirm >/dev/null 2>&1
cd /home/snow/source >/dev/null 2>&1
echo "Installing: ani-cli"
git clone "https://github.com/pystardust/ani-cli.git" >/dev/null 2>&1
cd ani-cli >/dev/null 2>&1
sudo make >/dev/null 2>&1
cd ~ >/dev/null 2>&1
touch "$HOME/.cache/zshhistory" >/dev/null 2>&1
ln -s "$HOME/zsh/.zshrc" $HOME/.zshrc >/dev/null 2>&1
git clone "https://github.com/peroxyacetic/glowie-icons" >/dev/null 2>&1
rsync -rtv /home/snow/glowie-icons/ /home/snow/ >/dev/null 2>&1

PKGS=(
    'nerd-fonts-fira-code'
    'noto-fonts-emoji'
    'ttf-meslo'
    'polybar'
    'clearine-git'
    'betterlockscreen'
    'spotify'
    'jellyfin-media-player'
)

for PKG in "${PKGS[@]}"; do
    echo "Installing: $PKG"
    yay -S --noconfirm $PKG >/dev/null 2>&1
done

export PATH=$PATH:~/.local/bin >/dev/null 2>&1
rsync -rtv /home/snow/glowie/dotfiles/ /home/snow/ >/dev/null 2>&1
chmod +x /home/snow/.config/bspwm/bspwmrc >/dev/null 2>&1

echo -e "\nDone!\n"
exit
