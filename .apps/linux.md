https://wiki.archlinux.org/index.php/Installation_guide
https://wiki.archlinux.org/index.php/general_recommendations


``` bash
# free drive space in host OS
# run live ISO

# partition drive
cgdisk /dev/sda

# create filesystems
mkfs.ext4 /dev/sda5

# for checking partitions & filesystems
lsblk

# mount partition
mount /dev/sda5 /mnt

# create and mount EFI boot partition
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot

# remove old linux kernel executable
rm /mnt/boot/vmlinuz-linux

# connect to internet / wifi
wifi-menu
ip a
ping -c 3 google.com

# use reflector to find download mirrors
pacman -Sy reflector
reflector --verbose --country 'United States' -l 10 -p http --sort rate --save /etc/pacman.d/mirrorlist

# install arch linux to filesystem
pacstrap -i /mnt base base-devel

# generate fstab identifier file
genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab

# chroot into system in order to prep config files
arch-chroot /mnt /bin/bash

# declare the hostname
echo HOSTNAME > /etc/hostname

# generate & set the locale
vi /etc/locale.gen
# uncomment en_US.UTF_8
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
export LANG=en_US.UTF-8

# install wireless packages for netctl and automatic profiling
pacman -S wpa_supplicant connman

# install systemd-boot loader
bootctl install

# configure bootloader with proper drive name & letter
# is this necessary? check for vmlinuz too
lsblk -f
vi /boot/loader/entries/arch.conf

# set the root password
passwd

# unmount partitions, reboot
exit
umount -R /mnt
reboot

######################################
# your bare-bones installation is done!
# but, we can still add more to the system:
######################################

# create an admin user account & set password
useradd -m -G wheel sean
passwd sean

# allow sudo access to admin user (uncomment wheel)
# now login as new user!
visudo

# enable networking service
systemctl start connman
systemctl enable connman

# setup wifi profiles
# for WPA2 enterprise, see online for sample config
connmanctl enable wifi // scan wifi //services // agent on // connect WIFI
vi /var/lib/connman/NETWORK.config

# update system clock and timezone
# if dual-booting Windows, registry fix needed for UTC time
timedatectl set-timezone US/Mountain
timedatectl set-ntp true
timedatectl status

# package management - update
pacman -Syu

# change shell
pacman -S zsh
chsh -s /bin/zsh

# simplify AUR package installation
# using https://aur.archlinux.org/packages/pacaur/
pacman -S git
mkdir ~/Code && cd $_
git clone https://aur.archlinux.org/cower.git
# check cower aur page to update gpg keys
cd cower && makepkg -sri && cd ..
git clone https://aur.archlinux.org/pacaur.git
cd pacaur && makepkg -sri && cd ..
rm -rf *

# for removing packages, orphaned packages, and cleaning cache
pacaur -Rns packagename
pacaur -Rns $(pacaur-Qdtq)
pacaur -Scc

# set console font
pacaur -S terminus-font
setfont ter-v16b
echo "FONT=ter-v16b" > /etc/vconsole.conf

# configure shell with zgen
# https://github.com/tarjoilija/zgen
# plugins: gitfast, common-aliases, systemd, vi-mode, wd
# zsh-users/zsh-syntax-highlighting + theme: theunraveler
vi .zshrc
zgen update

# service management (start, enable, etc. or with sc-)
systemctl status

# battery level
pacaur -S acpi
acpi -i

# intel display drivers & display config
pacaur -S xf86-video-intel mesa-libgl arandr

# touchpad drivers
pacaur -S libinput
# create file: /etc/X11/xorg.conf.d/30-touchpad.conf
#     Section "InputClass"
#        Identifier "touchpad"
#        Driver "libinput"
#        MatchIsTouchpad "on"
#        Option "NaturalScrolling" "on"
#        Option "Tapping" "on"
#     EndSection

# brightness keys
pacaur -S light
light -A 10

# sound (enabled by default but muted)
pacaur -S alsa-utils
amixer set Master toggle
amixer set Master 5%+

# sound using pulseaudio wrapper with gui
pacaur -S pulseaudio pavucontrol
pactl list sinks short
pactl set-sink-mute 1 toggle
pactl set-sink-volume 1 +5%
speaker-test

# configure key commands
# some keys are not working; asus driver issues
pacaur -S xbindkeys xorg-xev
xbindkeys -k
vi ~/.xbindkeysrc
# add command-key combinations to file
# keys: XF86-->AudioMute/AudioRaiseVolume/AudioLowerVolume/KbdBrightnessUp/KbdBrightnessDown

# run scripts on login
vi ~/.xprofile
# `xbindkeys &`

# bluetooth config
pacaur -S bluez bluez-utils
systemctl start bluetooth
systemctl enable bluetooth
rfkill unblock bluetooth
bluetoothctl --> power on --> scan on --> devices --> connect MAC --> pair MAC

# display manager
pacaur -S lightdm xorg-server
pacaur -S lightdm-webkit2-greeter
vi /etc/lightdm/lightdm.conf
# set `greeter-session = lightdm-webkit2-greeter`
pacaur -S lightdm-webkit-theme-bevel-git
vi /etc/lightdm/lightdm-webkit2-greeter.conf
# set `webkit-theme = Bevel`
systemctl enable lightdm
# edit Bevel theme files, script.js requires user.image by default!

# window manager & app launcher
pacaur -S i3 dmenu2

# fonts: search, install, and list
pacaur -Ss ttf
pacaur -S adobe-source-code-pro-fonts adobe-source-sans-pro-fonts adobe-source-serif-pro-fonts
fc-list

# configure i3
# change exit command
# add commands for lock, sleep, & browser
# change fonts to Source Sans Pro, small size
# change move keys to match vi, move horizontal mode, add split toggle
# add to dmenu: -h 25 -fn SourceSansPro:SemiBold:Italic -sb "#63C"
# can look into adding colors later?
# copy /etc/i3status.config and edit

# terminal emulator
pacaur -S termite
mkdir ~/.config/termite
vim ~/.config/termite/config
# font option (Source Code Pro 12) and background rgba(39,40,34,0.8)
# color with Monokai from http://terminal.sexy (paste with shift-insert)

# match color scheme in virtual console
pacaur -S setcolors-git
# download scheme: https://github.com/EvanPurkhiser/linux-vt-setcolors
setcolors FILE




# install apps

# browser: google-chrome firefox
# networking gui: connman-gtk
# archiving: dtrx p7zip unrar
# system info: archey3 htop baobab
# utilities: screen xfce4-screenshooter caffeine-ng
# add caffeine-ng to `.xprofile`

# text editors: vim emacs sublime-text-dev visual-studio-code
# file transfer: openssiuuh filezilla
# file browser: nautilus ranger
# file sync: insync
# configure insync: `insync start` & add this command to `.xprofile`

# desktop: dunst feh i3-gaps compton gnome-screenshot
# documents: libreoffice latex-mk pandoc aspell
# pdf viewer: evince
# image viewer: gpicview
# video player: mpv

# media apps: inkscape gimp audacity handbrake
# academic: mendeleydesktop
# games: minecraft

# programming: git npm python python-pip ruby
# install all other dev packages
# set up gitconfig file

# command-line tools
# file browsing: nnn, midnightcommander
# code search: fzf, ag, ack
# download: aria2
# disk space: pydf

```
