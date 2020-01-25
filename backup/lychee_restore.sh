#!/bin/bash

# ---HOST_PATHS------------------------

BACKUP_FILE="/home/daniel/backup/lychee/lychee_2020-01-11.tar"
cd /home/daniel/projects/server-terraformer/backup  # server-terraformer backup dir

# ---ENV_VARS--------------------------

LYCHEE_DIR=`grep -m 1 LYCHEE_DIR ../docker_compose/.env | cut -d '=' -f 2-`
LYCHEE_DB_NAME=`grep -m 1 LYCHEE_DB_NAME ../docker_compose/.env | cut -d '=' -f 2-`
LYCHEE_DB_USER=`grep -m 1 LYCHEE_DB_USER ../docker_compose/.env | cut -d '=' -f 2-`
LYCHEE_DB_USER_PASS=`grep -m 1 LYCHEE_DB_USER_PASS ../docker_compose/.env | cut -d '=' -f 2-`

# ---BACKUP---------------------------

tar xf $BACKUP_FILE
rm -r $LYCHEE_DIR/*  # empty config folder
tar xf lychee_folder.tar.bz2 -C $LYCHEE_DIR  # restore saved configs/pictures
cat db_dump.sql | docker exec -i lychee_db /usr/bin/mysql -u $LYCHEE_DB_USER --password=$LYCHEE_DB_USER_PASS $LYCHEE_DB_NAME

# ---FORMAT---------------------------

rm db_dump.sql
rm lychee_folder.tar.bz2

# lychee containers needs restart after restore finished
