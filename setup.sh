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
# wget https://raw.githubusercontent.com/maxux/raspberry-zero-camera/master/setup.sh

apt-get update
apt-get install -y vim tmux
apt-get install -y python3-picamera2

cd /home/camera
mkdir camstream && cd camstream
wget https://raw.githubusercontent.com/maxux/raspberry-zero-camera/master/mjpeg_server.py

cd /home/camera
apt-get install -y git
git clone https://github.com/maxux/librtinfo
git clone https://github.com/maxux/rtinfo

cd /home/camera/librtinfo/linux
make && make install && ldconfig

cd /home/camera/rtinfo/rtinfo-client
make

echo 'tmux new-sess -s camera -d -c /home/camera/camstream' >> /etc/rc.local
echo 'tmux send-keys -t camera "python mjpeg_server.py" ENTER'  >> /etc/rc.local

echo "" >> /etc/rc.local
echo "/home/camera/rtinfo/rtinfo-client/rtinfo-client --host 10.244.0.253 --disk mmcblk --daemon" >> /etc/rc.local
echo "" >> /etc/rc.local

sed -i '/exit 0/d' /etc/rc.local
echo "exit 0" >> /etc/rc.local

systemctl disable hciuart.service
systemctl disable bluetooth.service

systemctl mask avahi-daemon
systemctl disable avahi-daemon
systemctl stop avahi-daemon

# Remove useless crap
apt-get remove --purge -y triggerhappy

sed -i 's/dtparam=audio=on/# dtparam=audio=on/g' /boot/firmware/config.txt
sed -i "s/dtparam=spi=on/dtparam=spi=on\n\ndtoverlay=disable-bt/g" /boot/firmware/config.txt

# Enable Warchdog Reset
### systemd doesn't support network interface monitoring

## echo >> /etc/systemd/system.conf
## echo "RuntimeWatchdogSec=15" >> /etc/systemd/system.conf
## echo "RebootWatchdogSec=2min" >> /etc/systemd/system.conf

# Calm down journald
echo >> /etc/systemd/journald.conf
echo "SystemMaxUse=1M" >> /etc/systemd/journald.conf

###

apt-get install -y watchdog

echo >> /etc/watchdog.conf
echo "watchdog-device = /dev/watchdog" >> /etc/watchdog.conf
echo "watchdog-timeout = 15" >> /etc/watchdog.conf
echo "max-load-1 = 24" >> /etc/watchdog.conf
echo "interface = wlan0" >> /etc/watchdog.conf

systemctl enable watchdog
systemctl start watchdog
# systemctl status watchdog

###

# Enable Overlayfs Mode
