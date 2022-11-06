################
# Gradlog Installer
# 

#CONFIG

user="admin"
path=/mnt/raid/Gradlog

#0 Test If-Root
if [[ $(id -u) -ne 0 ]] ; then \
    echo "Must be run as root" \
    echo exit 1 
fi


echo "Skript zum installieren der Temperaturlogger-Programmumgebung"
echo "Das Skript wird alle Programdaten in das Verzeichnis der '"install.sh"'-Datei installieren"
echo "Diese Daten sollten wenmöglichst NICHT auf der SD-Karte liegen"
echo
echo
echo
echo "<Zum starten der Installation, drücken Sie eine beliebige Taste>"

read 


#1 Update System
echo "System wird aktualisiert"
apt update && apt upgrade

#2 Install all necessary files
echo "Installieren der Abhängigkeiten"
apt install -y docker docker-compose unclutter
apt install -y libnotify-bin notification-daemon dbus at-spi2-core mate-notification-daemon mate-notification-daemon-common
usermod -aG docker $user

#3 Pull Docker files and set up containers (MQTT, NodeRED, InfluxDB, Grafana)
echo "Docker Container herunterladen und starten"
docker-compose up -d

#4 Grafana Kiosk
echo "Grafana-Kiosk Oberfläche herunterladen"
wget https://github.com/grafana/grafana-kiosk/releases/download/v1.0.5/grafana-kiosk.linux.armv7
cp -p grafana-kiosk.linux.armv7 /usr/bin/grafana-kiosk
chmod 755 /usr/bin/grafana-kiosk

#4.1 Add Grafana Kiosk to Autostart
echo "Grafana-Kiosk für Autostart vorbereiten"
mkdir /home/$user/.config/autostart
echo '[Desktop Entry]' > /home/$user/.config/autostart/grafana-kiosk.desktop
echo 'Type=Application' >> /home/$user/.config/autostart/grafana-kiosk.desktop
echo 'Exec=/usr/bin/grafana-kiosk -URL=http://localhost:3000 -login-method=local -username=admin -password=password -kiosk-mode=tv -ignore-certificate-errors -lxde' >> /home/$user/.config/autostart/grafana-kiosk.desktop

#5.1 Add UDEV-Rule for Script
echo "UDEV USB Regel hinzufügen"
mv $path/99-usbhook.rules /etc/udev/rules.d/99-usbhook.rules

#5.2 Reload UDEV-Rules
echo "UDEV Regeln aktivieren"
udevadm control --reload-rules

#6 Cronjob
echo "Aktivieren der Wöchentlichen/Täglichen Backup-Funktion"
echo '0 0 * * MON	root	'$path'/tocron.sh' > /etc/crontab
echo '30 6 * * MON	root	'$path'/tocron2.sh' > /etc/crontab

echo "Alle Arbeiten fertig"
echo "Es gibt nichts mehr zu tun"
