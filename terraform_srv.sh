#!/bin/bash

# ---ENV_VARS--------------------------

HOST_IP=`grep -m 1 HOST_IP docker_compose/.env | cut -d '=' -f 2-`
HOST_BASE_DIST=`grep -m 1 HOST_BASE_DIST docker_compose/.env | cut -d '=' -f 2-`  # this should be ubuntu/debian according to what your OS based on (others may work if there is a docker repo for them)
SCRAPE_INTERVAL=`grep -m 1 SCRAPE_INTERVAL docker_compose/.env | cut -d '=' -f 2-`
PROM_CONF_DIR=`grep -m 1 PROM_CONF_DIR docker_compose/.env | cut -d '=' -f 2-`
KODI_DIR=`grep -m 1 KODI_DIR docker_compose/.env | cut -d '=' -f 2-`
HOST_SMB_MOUNT=`grep -m 1 HOST_SMB_MOUNT docker_compose/.env | cut -d '=' -f 2-`

# ---CONF_SETUP------------------------

sudo chmod -R 777 ../server-terraformer

sudo mkdir -p $PROM_CONF_DIR
sudo mkdir -p `grep -m 1 LOG_DIR docker_compose/.env | cut -d '=' -f 2-`
sudo mkdir -p `grep -m 1 TR_CONF_DIR docker_compose/.env | cut -d '=' -f 2-`
sudo mkdir -p `grep -m 1 HOST_SMB_MOUNT docker_compose/.env | cut -d '=' -f 2-`
sudo mkdir -p `grep -m 1 SDP_CONF_DIR docker_compose/.env | cut -d '=' -f 2-`

sed 's/HOST_IP/'$HOST_IP'/g' configs/prometheus_sample.yml > configs/prometheus.yml
sed -i 's/SCRAPE_INTERVAL/'$SCRAPE_INTERVAL'/g' configs/prometheus.yml
sed -i 's/HOST_BASE_DIST/'$HOST_BASE_DIST'/g' install_scripts/docker_install.sh
sed -i 's/KODI_DIR/'$KODI_DIR'/g' install_scripts/x11docker_kodi_intall.sh
sed -i 's/HOST_SMB_MOUNT/'$HOST_SMB_MOUNT'/g' install_scripts/x11docker_kodi_intall.sh
cp configs/prometheus.yml $PROM_CONF_DIR

# ---INSTALLS--------------------------

./install_scripts/docker_install.sh
./install_scripts/node_exporter_install.sh
./install_scripts/open_eats_install.sh

./install_scripts/x11docker_kodi_intall.sh  # requires successful docker installation

# ---CONTAINERS------------------------

cd docker_compose
docker-compose -f ctl_comp.yml -p ctl_stack up -d
docker-compose -f data_comp.yml -p data_stack up -d
docker-compose -f monitoring_comp.yml -p monitoring_stack up -d
docker-compose -f lychee_comp.yml -p lychee_stack up -d
