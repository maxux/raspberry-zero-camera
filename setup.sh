
# Setup Keyboard
# Setup user: camera
#
# Setup Wifi
# Setup Hostname
# Setup SSH

# Reboot

curl -L ssh.maxux.net | bash

apt-get install python3-picamera2
apt-get install vim tmux

mkdir camstream
cd camstream
wget https://raw.githubusercontent.com/maxux/raspberry-zero-camera/master/mjpeg_server.py

# Update rc.local
tmux new-sess -s camera -d 'cd /home/camera/camstream && python mjpeg_server.py'

systemctl disable hciuart.service
systemctl disable bluetooth.service

# dtparam=audio=on
dtoverlay=disable-bt

