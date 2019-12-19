#!/bin/bash

useradd node_exporter -s /sbin/nologin
wget https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz
tar xvfz node_exporter-0.18.1.linux-amd64.tar.gz
cp node_exporter-0.18.1.linux-amd64/node_exporter /usr/sbin/

cat > /etc/systemd/system/node_exporter.service <<EOL
[Unit]
Description=Node Exporter

[Service]
User=node_exporter
EnvironmentFile=/etc/sysconfig/node_exporter
ExecStart=/usr/sbin/node_exporter \$OPTIONS

[Install]
WantedBy=multi-user.target
EOL

mkdir -p /etc/sysconfig
touch /etc/sysconfig/node_exporter
echo 'OPTIONS="--collector.textfile.directory /var/lib/node_exporter/textfile_collector"' > /etc/sysconfig/node_exporter

systemctl daemon-reload
systemctl enable node_exporter

systemctl start node_exporter

sudo rm -R node_exporter-0.18.1.linux-amd64
sudo rm node_exporter-0.18.1.linux-amd64.tar.gz

echo 'Adjust the firewall to allow traffic to Node Exporter - 9100/TCP if needed'
