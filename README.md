# glowie - Arch Installation Script


This script deploys a full Arch Linux Install w/ bspwm, polybar and rofi.

![UI](https://i.imgur.com/b35ux8I.png)
## Installation Guide

From initial Prompt type the following commands:

```
pacman -Sy git
git clone https://github.com/peroxyacetic/glowie
cd glowie
bash glowie.sh
```

The default username is snow  
After it finishes run the following commands:

```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

Set `ZSH_THEME="powerlevel10k/powerlevel10k"` in `~/.zshrc`.

Run `betterlockscreen -u /home/snow/.cache/wal/nya.png`

Add `startx` to `/etc/profile`.

## bspwm

Super + Return Terminal     
Super + q close     
Super + d rofi     
Super + 0-9 go to workspace x     
Super + Shift + 0-9 move window to workspace x     
Super + Alt + H, J, K ,L Increase window size       
Super + Alt + Shift + H, J, K ,L Decrease window size    
Super + S Toggle Floating mode     
Super + T Toggle Tiling Mode     
Super + F Toggle Fullscreen     
Super + Alt + Q Powermenu (requires clearine)      
Super + Alt + R restart wm     
Super + Escape restart keybinding     
Super + X lockscreen     

Super + F1 Chromium     
Super + F2 Thunar    
Super + F3 Spotify     
Super + F4 pulsemixer   

>note     
>Workspace 0 is assigned as workspace 10

## No Wifi

#1: Run `iwctl`

#2: Run `device list`, and find your device name.

#3: Run `station [device name] scan`

#4: Run `station [device name] get-networks`

#5: Find your network, and run `station [device name] connect [network name]`, enter your password and run `exit`. You can test if you have internet connection by running `ping google.com`. 
