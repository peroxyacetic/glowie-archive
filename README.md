# Arch Installation Script


This Script installs a full Arch Linux system with a custom Rice and BSPWM + Polybar.

## Boot Arch ISO

From initial Prompt type the following commands:

```
pacman -Sy git
git clone https://github.com/peroxyacetic/glowie
cd glowie
bash glowie.sh
```

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
Super + F4 vim  

>note     
>Workspace 0 is assigned as workspace 10

### No Wifi

#1: Run `iwctl`

#2: Run `device list`, and find your device name.

#3: Run `station [device name] scan`

#4: Run `station [device name] get-networks`

#5: Find your network, and run `station [device name] connect [network name]`, enter your password and run `exit`. You can test if you have internet connection by running `ping google.com`. 
