#!/bin/bash

# ---HOST_PATHS------------------------

BACKUP_DIR="/home/daniel/backup/openeats"
cd /home/daniel/projects/server-terraformer/backup  # server-terraformer backup dir

# ---ENV_VARS--------------------------

OPENEATS_DIR=`grep -m 1 OPENEATS_DIR ../docker_compose/.env | cut -d '=' -f 2-`
OPENEATS_DB=`grep -m 1 MYSQL_DATABASE ../configs/openeats/env_prod.list | cut -d '=' -f 2-`
OPENEATS_DB_USER=`grep -m 1 MYSQL_USER ../configs/openeats/env_prod.list | cut -d '=' -f 2-`
OPENEATS_DB_PASS=`grep -m 1 MYSQL_PASSWORD ../configs/openeats/env_prod.list | cut -d '=' -f 2-`

# ---BACKUP---------------------------

mkdir -p $BACKUP_DIR
cd $BACKUP_DIR
docker cp openeats_api_1:/code/site-media .

touch db_dump.sql
sudo docker exec openeats_db_1 /usr/bin/mysqldump -u $OPENEATS_DB_USER --password=$OPENEATS_DB_PASS $OPENEATS_DB > db_dump.sql

tar cfj openeats_`date +%F`.tar.bz2 -C $BACKUP_DIR db_dump.sql site-media
rm db_dump.sql
rm -r site-media
