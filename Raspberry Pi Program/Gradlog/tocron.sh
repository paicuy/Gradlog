#!/bin/bash
## This script is run weekly as a cronjob
# /etc/crontab
# 0 0 * * MON	root	/mnt/raid/Gradlog/tocron.sh

SRC="/mnt/raid/Gradlog/export"

datum=$(date +%Y-%m-%d)
docker exec -it influxdb influx -precision 'rfc3339' -database 'temperature' -execute 'SELECT time,device,room,temperature FROM temperature' -format csv > $SRC/"$datum"_Auswertung.csv
docker exec -it influxdb influx -database 'temperature' -execute 'DROP MEASUREMENT temperature'
