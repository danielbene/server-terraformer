#!/bin/bash

# ---HOST_PATHS------------------------

BACKUP_DIR="/home/daniel/backup/lychee"
cd /home/daniel/projects/server-terraformer/backup  # server-terraformer backup dir

# ---ENV_VARS--------------------------

LYCHEE_DIR=`grep -m 1 LYCHEE_DIR ../docker_compose/.env | cut -d '=' -f 2-`
LYCHEE_DB_NAME=`grep -m 1 LYCHEE_DB_NAME ../docker_compose/.env | cut -d '=' -f 2-`
LYCHEE_DB_USER=`grep -m 1 LYCHEE_DB_USER ../docker_compose/.env | cut -d '=' -f 2-`
LYCHEE_DB_USER_PASS=`grep -m 1 LYCHEE_DB_USER_PASS ../docker_compose/.env | cut -d '=' -f 2-`

# ---BACKUP---------------------------

cd $BACKUP_DIR
tar cfj lychee_folder.tar.bz2 -C $LYCHEE_DIR .  # uncompression: sudo tar xvf lychee_folder.tar.bz2

touch db_dump.sql
chmod 777 db_dump.sql
docker exec lychee_db /usr/bin/mysqldump -u $LYCHEE_DB_USER --password=$LYCHEE_DB_USER_PASS $LYCHEE_DB_NAME > db_dump.sql  # restore: cat db_dump.sql | docker exec -i lychee_db /usr/bin/mysql -u $LYCHEE_DB_USER --password=$LYCHEE_DB_USER_PASS $LYCHEE_DB_NAME

# ---FORMAT---------------------------

tar cf lychee_`date +%F`.tar db_dump.sql lychee_folder.tar.bz2  # list contents: tar tvf archive.tar (works on bz2 too)
rm db_dump.sql
rm lychee_folder.tar.bz2
