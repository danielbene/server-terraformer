#!/bin/bash

apt-get install -y xpra nxagent xserver-xephyr xauth xclip x11-xserver-utils xinit xdotool weston xwayland xserver-xorg-input-all
curl -fsSL https://raw.githubusercontent.com/mviereck/x11docker/master/x11docker | bash -s -- --update
docker pull x11docker/openbox

# manual sound test: speaker-test -D hdmi:CARD=PCH,DEV=0 -c 2 / device list: aplay -l
adduser $USER audio
mkdir -p KODI_DIR
chmod +rw KODI_DIR

cat > /etc/systemd/system/kodi.service <<EOL
[Unit]
Description=Dockerized Kodi
Requires=docker.service
After=network.target docker.service

[Service]
ExecStartPre=/usr/bin/docker pull erichough/kodi
ExecStart=/usr/bin/x11docker --xorg --alsa=3 --gpu --home=KODI_DIR -- -v HOST_SMB_MOUNT:/media/ro -p 8085:8080 -p 9095:9090 -- erichough/kodi
KillMode=process

[Install]
WantedBy=multi-user.target
EOL

systemctl daemon-reload
systemctl enable kodi

# reboot required
