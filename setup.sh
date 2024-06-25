#!/bin/bash
set -ex

# Setup Keyboard
# Setup user: camera
#
# Setup Wifi
# Setup Hostname
# Setup SSH

# Reboot

# curl -L ssh.maxux.net | bash

apt-get install -y vim tmux
apt-get install -y python3-picamera2

mkdir camstream && cd camstream
wget https://raw.githubusercontent.com/maxux/raspberry-zero-camera/master/mjpeg_server.py
cd

echo "tmux new-sess -s camera -d 'cd /home/camera/camstream && python mjpeg_server.py'" >> /etc/rc.local
sed -i '/exit 0/d' /etc/rc.local
echo -e "\nexit 0" >> /etc/rc.local

systemctl disable hciuart.service
systemctl disable bluetooth.service

sed -i 's/dtparam=audio=on/# dtparam=audio=on/g' /boot/firmware/config.txt
sed -i "s/dtparam=spi=on/dtparam=spi=on\ndtoverlay=disable-bt/g" /boot/firmware/config.txt

