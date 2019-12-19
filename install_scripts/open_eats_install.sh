#!/bin/bash

HOST_IP=`grep -m 1 HOST_IP docker_compose/.env | cut -d '=' -f 2-`
OPENEATS_DIR=`grep -m 1 OPENEATS_DIR docker_compose/.env | cut -d '=' -f 2-`
OPENEATS_GUI_PORT=`grep -m 1 OPENEATS_GUI_PORT docker_compose/.env | cut -d '=' -f 2-`
OPENEATS_API_PORT=`grep -m 1 OPENEATS_API_PORT docker_compose/.env | cut -d '=' -f 2-`

# -------------------------------------

sudo apt-get install -y python

BASE_DIR=`pwd`
BACKUP_MODE=false
mkdir -p $OPENEATS_DIR

sed 's/HOST_IP/'$HOST_IP'/g' configs/openeats/env_prod.list.sample > configs/openeats/env_prod.list
sed -i 's/OPENEATS_GUI_PORT/'$OPENEATS_GUI_PORT'/g' configs/openeats/env_prod.list
sed -i 's/OPENEATS_API_PORT/'$OPENEATS_API_PORT'/g' configs/openeats/env_prod.list
sed 's/OPENEATS_GUI_PORT/'$OPENEATS_GUI_PORT'/g' configs/openeats/docker-prod.override.yml.sample > configs/openeats/docker-prod.override.yml
sed -i 's/OPENEATS_API_PORT/'$OPENEATS_API_PORT'/g' configs/openeats/docker-prod.override.yml

cd $OPENEATS_DIR
git clone https://github.com/open-eats/OpenEats.git

cd $BASE_DIR
cp configs/openeats/docker-prod.override.yml $OPENEATS_DIR/OpenEats/docker-prod.override.yml
cp configs/openeats/env_prod.list $OPENEATS_DIR/OpenEats/env_prod.list
if [ -f configs/openeats/openeats.sql ]; then
	cp configs/openeats/openeats.sql $OPENEATS_DIR/OpenEats/
	BACKUP_MODE=true
fi

cd $OPENEATS_DIR/OpenEats

sudo ./quick-start.py

sleep 30

if [ $BACKUP_MODE = true ]; then
	echo "---OPENEATS DATA RESTORE---"
	# TODO: site media restore & getting root credentials from env
	cat openeats.sql | docker exec -i openeats_db_1 /usr/bin/mysql -u root -proot openeats
else
	echo "---OPENEATS USER SETUP, AND DUMMY DATA CREATION---"
	sudo docker-compose -f docker-prod.yml run --rm --entrypoint 'python manage.py createsuperuser' api

	# dummy data gen
	sudo docker-compose -f $OPENEATS_DIR/OpenEats/docker-prod.yml exec api ./manage.py loaddata course_data.json
	sudo docker-compose -f $OPENEATS_DIR/OpenEats/docker-prod.yml exec api ./manage.py loaddata cuisine_data.json
	sudo docker-compose -f $OPENEATS_DIR/OpenEats/docker-prod.yml exec api ./manage.py loaddata news_data.json
	sudo docker-compose -f $OPENEATS_DIR/OpenEats/docker-prod.yml exec api ./manage.py loaddata recipe_data.json
	sudo docker-compose -f $OPENEATS_DIR/OpenEats/docker-prod.yml exec api ./manage.py loaddata ing_data.json
fi
