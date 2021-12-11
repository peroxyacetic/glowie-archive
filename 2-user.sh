#!/usr/bin/env bash

echo -e "\nINSTALLING AUR SOFTWARE\n"
# You can solve users running this script as root with this and then doing the same for the next for statement. However I will leave this up to you.

echo "CLONING: YAY"
cd /home/snow/source >/dev/null 2>&1
git clone "https://aur.archlinux.org/yay.git" >/dev/null 2>&1
cd yay >/dev/null 2>&1
makepkg -si --noconfirm >/dev/null 2>&1
cd /home/snow/source >/dev/null 2>&1
git clone "https://github.com/pystardust/ani-cli.git" >/dev/null 2>&1
cd ani-cli >/dev/null 2>&1
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
rsync -rtv /home/snow/glowie/dotfiles/ /home/snow/ >/dev/null 2>&1

# Tap to click
[ ! -f /etc/X11/xorg.conf.d/40-libinput.conf ] && printf 'Section "InputClass"
        Identifier "libinput touchpad catchall"
        MatchIsTouchpad "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
	# Enable left mouse button by tapping
	Option "Tapping" "on"
EndSection' > /etc/X11/xorg.conf.d/40-libinput.conf >/dev/null 2>&1

# Fix fluidsynth/pulseaudio issue.
grep -q "OTHER_OPTS='-a pulseaudio -m alsa_seq -r 48000'" /etc/conf.d/fluidsynth ||
	echo "OTHER_OPTS='-a pulseaudio -m alsa_seq -r 48000'" >> /etc/conf.d/fluidsynth >/dev/null 2>&1

# Start/restart PulseAudio.
pkill -15 -x 'pulseaudio'; sudo -u "$name" pulseaudio --start >/dev/null 2>&1

echo -e "\nDone!\n"
exit
