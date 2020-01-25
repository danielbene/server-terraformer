#!/bin/bash

# ---HOST_PATHS------------------------

BACKUP_FILE="/home/daniel/backup/openeats/openeats_2020-01-25.tar.bz2"
cd /home/daniel/projects/server-terraformer/backup  # server-terraformer backup dir

# ---ENV_VARS--------------------------

OPENEATS_DIR=`grep -m 1 OPENEATS_DIR ../docker_compose/.env | cut -d '=' -f 2-`
OPENEATS_DB=`grep -m 1 MYSQL_DATABASE ../configs/openeats/env_prod.list | cut -d '=' -f 2-`
OPENEATS_DB_USER=`grep -m 1 MYSQL_USER ../configs/openeats/env_prod.list | cut -d '=' -f 2-`
OPENEATS_DB_PASS=`grep -m 1 MYSQL_PASSWORD ../configs/openeats/env_prod.list | cut -d '=' -f 2-`

# ---BACKUP---------------------------

tar xf $BACKUP_FILE  # restore saved configs/pictures
cat db_dump.sql | docker exec -i openeats_db_1 /usr/bin/mysql -u $OPENEATS_DB_USER --password=$OPENEATS_DB_PASS $OPENEATS_DB
docker cp site-media/ openeats_api_1:/code/site-media/

# ---FORMAT---------------------------

rm db_dump.sql
rm -r site-media

# openeats containers needs restart after restore finished
