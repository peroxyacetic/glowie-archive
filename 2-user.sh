#!/usr/bin/env bash

echo -e "\nINSTALLING AUR SOFTWARE\n"
# You can solve users running this script as root with this and then doing the same for the next for statement. However I will leave this up to you.

echo "CLONING: YAY"
cd ~ >/dev/null 2>&1
git clone "https://aur.archlinux.org/yay.git" >/dev/null 2>&1
cd ${HOME}/yay >/dev/null 2>&1
makepkg -si --noconfirm >/dev/null 2>&1
cd ~ >/dev/null 2>&1
git clone "https://github.com/pystardust/ani-cli.git" >/dev/null 2>&1
cd ${HOME}/ani-cli >/dev/null 2>&1
makepkg -si --noconfirm >/dev/null 2>&1
cd ~ >/dev/null 2>&1
touch "$HOME/.cache/zshhistory" >/dev/null 2>&1
git clone "https://github.com/ChrisTitusTech/zsh" >/dev/null 2>&1
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/powerlevel10k >/dev/null 2>&1
ln -s "$HOME/zsh/.zshrc" $HOME/.zshrc >/dev/null 2>&1

PKGS=(
'nerd-fonts-fira-code'
'noto-fonts-emoji'
'papirus-icon-theme'
'ttf-meslo' # Nerdfont package
'polybar'
'clearine'
'betterlockscreen'
'spotify'
)

for PKG in "${PKGS[@]}"; do
    echo "Installing $PKG"
    yay -S --noconfirm $PKG >/dev/null 2>&1
done

export PATH=$PATH:~/.local/bin >/dev/null 2>&1
cp -r $HOME/glowie/dotfiles/* $HOME >/dev/null 2>&1

echo -e "\nDone!\n"
exit
