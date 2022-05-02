#!/bin/sh
#
# Start easydav webdav server

EASYDAV_DIR=/home/mark/dev/easydav
cd ${EASYDAV_DIR}
/usr/local/bin/python webdav.py >>/var/www/logs/easydav.log 2>&1 &
