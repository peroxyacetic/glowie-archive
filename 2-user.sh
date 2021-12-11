#!/usr/bin/env bash

echo -e "\nINSTALLING AUR SOFTWARE\n"
# You can solve users running this script as root with this and then doing the same for the next for statement. However I will leave this up to you.

echo "CLONING: YAY"
mkdir /home/snow/source
cd /home/snow/source >/dev/null 2>&1
git clone "https://aur.archlinux.org/yay.git" >/dev/null 2>&1
cd yay >/dev/null 2>&1
makepkg -si --noconfirm >/dev/null 2>&1
cd /home/snow/source >/dev/null 2>&1
git clone "https://github.com/pystardust/ani-cli.git" >/dev/null 2>&1
cd ani-cli >/dev/null 2>&1
sudo make >/dev/null 2>&1
cd ~ >/dev/null 2>&1
touch "$HOME/.cache/zshhistory" >/dev/null 2>&1
git clone "https://github.com/ChrisTitusTech/zsh" >/dev/null 2>&1
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/powerlevel10k >/dev/null 2>&1
ln -s "$HOME/zsh/.zshrc" $HOME/.zshrc >/dev/null 2>&1
git clone "https://github.com/peroxyacetic/glowie-icons" >/dev/null 2>&1
rsync -rtv /home/snow/glowie-icons/ /home/snow/ >/dev/null 2>&1

PKGS=(
'nerd-fonts-fira-code'
'noto-fonts-emoji'
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
rsync -rtv /home/snow/glowie/dotfiles/ /home/snow/ >/dev/null 2>&1

# Fix fluidsynth/pulseaudio issue.
grep -q "OTHER_OPTS='-a pulseaudio -m alsa_seq -r 48000'" /etc/conf.d/fluidsynth ||
	echo "OTHER_OPTS='-a pulseaudio -m alsa_seq -r 48000'" >> /etc/conf.d/fluidsynth >/dev/null 2>&1

# Start/restart PulseAudio.
pkill -15 -x 'pulseaudio'; sudo -u "$name" pulseaudio --start >/dev/null 2>&1

echo -e "\nDone!\n"
exit
