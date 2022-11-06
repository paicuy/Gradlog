#!/bin/bash

SRC="/mnt/raid/Gradlog/export"

# Konfiguration
LOG_FILE=/var/log/usbhook
exec > >(tee -a ${LOG_FILE} )
exec 2> >(tee -a ${LOG_FILE} >&2)


DEVICE="$1" # the device name
NUMBER="${DEVICE: -1}"

if [ "$NUMBER" = "1" ]
then
exit 0
fi

mkdir /tmp/"$DEVICE"

# NTFS usb drive
mount -t ntfs-3g /dev/"$DEVICE"1 /tmp/"$DEVICE"
cp -R "$SRC"/* /tmp/"$DEVICE"
chmod 777 -R /tmp/"$DEVICE"

umount /tmp/"$DEVICE"
rm -r /tmp/"$DEVICE"
echo "Copy to $DEVICE >> Fertig !"
export DISPLAY=:0
sudo -u admin notify-send "Copy to $DEVICE >> Fertig !" -t 5000

exit 0
