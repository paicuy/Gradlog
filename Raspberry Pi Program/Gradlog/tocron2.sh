#!/bin/bash
## This script is run daily as a cronjob
# /etc/crontab
# 0 0 * * MON	root	/mnt/raid/Gradlog/tocron2.sh

SRC="/mnt/raid/Gradlog/export"

docker exec -it influxdb influx -precision 'rfc3339' -database 'temperature' -execute 'SELECT time,device,room,temperature FROM temperature' -format csv > $SRC/Daily_Auswertung.csv
