
#!/bin/bash

# Systemaktualisierung
sudo apt-get update && sudo apt-get upgrade -y

# Deaktivierung des Wi-Fi-Stromsparmodus
sudo iwconfig wlan0 power off

# Skript für automatische WLAN-Wiederverbindung einrichten
cat <<EOF | sudo tee /usr/local/bin/auto_reconnect.sh
#!/bin/bash
while true; do
  if ! ifconfig wlan0 | grep -q 'inet '; then
    echo 'Reconnecting...'
    sudo ifconfig wlan0 down
    sleep 5
    sudo ifconfig wlan0 up
  fi
  sleep 60
done
EOF
sudo chmod +x /usr/local/bin/auto_reconnect.sh

# Skript zum Systemstart hinzufügen
echo '@reboot root /usr/local/bin/auto_reconnect.sh' | sudo tee -a /etc/crontab

# Touchscreen-Display Setup
echo 'Setting up 5-inch HDMI Touchscreen Display...'
# Display-Treiber herunterladen und installieren
wget http://cdn.littlebird.com.au/drivers/LCD-show-180817.tar.gz -O /tmp/LCD-show.tar.gz
tar xzvf /tmp/LCD-show.tar.gz -C /tmp
cd /tmp/LCD-show/
sudo ./LCD5-show

# SSD Optimierungen
echo 'Applying SSD optimizations...'
# TRIM-Aktivierung für SSD
sudo fstrim -v /

# Systemneustart
sudo reboot
