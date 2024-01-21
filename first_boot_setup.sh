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
git config --global user.name "CloudDevStudios"
git config --global user.email "cdvst@outlook.com"

# Define a function to install and configure the touchscreen display
install_display() {
  sudo rm -rf LCD-show
  git clone https://github.com/goodtft/LCD-show.git
  chmod -R 755 LCD-show
  cd LCD-show/
  sudo ./LCD5-show
}

# Define a function to enable ZRAM
enable_zram() {
  sudo wget -O /usr/bin/zram.sh https://raw.githubusercontent.com/novaspirit/rpi_zram/master/zram.sh
  sudo chmod +x /usr/bin/zram.sh
  sudo /usr/bin/zram.sh
  echo "/usr/bin/zram.sh" | sudo tee -a /etc/rc.local
}

# Define a function to disable WiFi power saving mode
disable_wifi_power() {
  sudo iwconfig wlan0 power off
}

# Define a function to set up auto reconnect script
setup_auto_reconnect() {
  sudo wget -O /usr/local/bin/auto_reconnect.sh https://raw.githubusercontent.com/CloudDevStudios/auto_reconnect/master/auto_reconnect.sh
  sudo chmod +x /usr/local/bin/auto_reconnect.sh
  echo "@reboot /usr/local/bin/auto_reconnect.sh" | sudo crontab -
}

# Define a function to clone the repository
clone_repo() {
  git clone https://github.com/CloudDevStudios.git
}

# Define a function to set up cron job for auto commit and push
setup_cron_job() {
  echo "*/10 * * * * cd /home/pi && git add . && git commit -m 'Auto commit' && git push origin master" | sudo crontab -
}

# Define a function to uninstall the desktop
uninstall_desktop() {
  sudo apt-get purge xserver* lightdm* raspberrypi-ui-mods
  sudo apt-get autoremove
}

# Define a function to install LXDE
install_lxde() {
  sudo apt-get install --no-install-recommends xserver-xorg xinit
  sudo apt-get install lxde-core lxappearance
  sudo apt-get install lightdm
}

# Define a function to install kiauh
install_kiauh() {
  cd ~
  git clone https://github.com/th33xitus/kiauh.git
  cd kiauh
  ./kiauh.sh
}

# Define a function to add aliases
add_aliases() {
  echo "alias klipper='sudo service klipper start'" >> ~/.bashrc
  echo "alias moonraker='sudo service moonraker start'" >> ~/.bashrc
  echo "alias fluidd='sudo service fluidd start'" >> ~/.bashrc
  echo "alias update='sudo apt-get update && sudo apt-get upgrade -y'" >> ~/.bashrc
  source ~/.bashrc
}

# Define a function to install soft keyboard
install_soft_keyboard() {
  sudo apt-get install matchbox-keyboard
}

# Define a function to reboot the system
reboot_system() {
  sudo reboot
}

# Call the functions in the desired order
install_display
enable_zram
disable_wifi_power
setup_auto_reconnect
clone_repo
setup_cron_job
uninstall_desktop
install_lxde
install_kiauh
add_aliases
install_soft_keyboard
reboot_system

# Check if the command was successful
if [ $? -eq 0 ]; then
  echo "Command succeeded"
else
  echo "Command failed"
fi

# Exit the script if any command fails
#set -e
# Exit the script if any unset variable is used
#set -u

# Define a function to clean up temporary files
cleanup() {
  echo "Cleaning up..."
  rm -rf /tmp/*
}

# Execute the cleanup function when the script receives SIGINT or SIGTERM
trap cleanup SIGINT SIGTERM

# Display and save the output of the command to a file
sudo apt-get update | tee -a log.txt

# Measure the time taken by the script
time ./script.sh
# Measure the time taken by a command
time sudo apt-get upgrade

# Run the script with a lower priority
nice -n 10 ./script.sh
# Run the command with a higher priority
nice -n -5 sudo apt-get update

# Do not exit the script if any command fails
set +e
# Do not exit the script if any unset variable is used
set +u

# Change GitHub user name and email
git config --global user.name "CloudDevStudios"
git config --global user.email "cdvst@outlook.com"

# Define a function to install and configure the touchscreen display
install_display() {
  sudo rm -rf LCD-show
  git clone https://github.com/goodtft/LCD-show.git
  chmod -R 755 LCD-show
  cd LCD-show/
  sudo ./LCD5-show
  # Check if the command was successful
  if [ $? -eq 0 ]; then
    echo "Display installation succeeded"
  else
    echo "Display installation failed"
  fi
}

# Define a function to enable ZRAM
enable_zram() {
  sudo wget -O /usr/bin/zram.sh https://raw.githubusercontent.com/novaspirit/rpi_zram/master/zram.sh
  sudo chmod +x /usr/bin/zram.sh
  sudo /usr/bin/zram.sh
  echo "/usr/bin/zram.sh" | sudo tee -a /etc/rc.local
  # Check if the command was successful
  if [ $? -eq 0 ]; then
    echo "ZRAM enabled"
  else
    echo "ZRAM failed"
  fi
}

# Define a function to disable WiFi power saving mode
disable_wifi_power() {
  sudo iwconfig wlan0 power off
  # Check if the command was successful
  if [ $? -eq 0 ]; then
    echo "WiFi power saving mode disabled"
  else
    echo "WiFi power saving mode failed"
  fi
}

# Define a function to set up auto reconnect script
setup_auto_reconnect() {
  sudo wget -O /usr/local/bin/auto_reconnect.sh https://raw.githubusercontent.com/CloudDevStudios/auto_reconnect/master/auto_reconnect.sh
  sudo chmod +x /usr/local/bin/auto_reconnect.sh
  echo "@reboot /usr/local/bin/auto_reconnect.sh" | sudo crontab -
  # Check if the command was successful
  if [ $? -eq 0 ]; then
    echo "Auto reconnect script set up"
  else
    echo "Auto reconnect script failed"
  fi
}

# Define a function to clone the repository
clone_repo() {
  git clone https://github.com/CloudDevStudios.git
  # Check if the command was successful
  if [ $? -eq 0 ]; then
    echo "Repository cloned"
  else
    echo "Repository clone failed"
  fi
}

# Define a function to set up cron job for auto commit and push
setup_cron_job() {
  echo "*/10 * * * * cd /home/pi && git add . && git commit -m 'Auto commit' && git push origin master" | sudo crontab -
  # Check if the command was successful
  if [ $? -eq 0 ]; then
    echo "Cron job set up"
  else
    echo "Cron job failed"
  fi
}

# Define a function to uninstall the desktop
uninstall_desktop() {
  sudo apt-get purge xserver* lightdm* raspberrypi-ui-mods
  sudo apt-get autoremove
  # Check if the command was successful
  if [ $? -eq 0 ]; then
    echo "Desktop uninstalled"
  else
    echo "Desktop uninstall failed"
  fi
}

# Define a function to install LXDE
install_lxde() {
  sudo apt-get install --no-install-recommends xserver-xorg xinit
  sudo apt-get install lxde-core lxappearance
  sudo apt-get install lightdm
  # Check if the command was successful
  if [ $? -eq 0 ]; then
    echo "LXDE installed"
  else
    echo "LXDE install failed"
  fi
}

# Define a function to install kiauh
install_kiauh() {
  cd ~
  git clone https://github.com/th33xitus/kiauh.git
  cd kiauh
  ./kiauh.sh
  # Check if the command was successful
  if [ $? -eq 0 ]; then
    echo "Kiauh installed"
  else
    echo "Kiauh install failed"
  fi
}

# Define a function to add aliases
add_aliases() {
  echo "alias klipper='sudo service klipper start'" >> ~/.bashrc
  echo "alias moonraker='sudo service moonraker start'" >> ~/.bashrc
  echo "alias fluidd='sudo service fluidd start'" >> ~/.bashrc
  echo "alias update='sudo apt-get update && sudo apt-get upgrade -y'" >> ~/.bashrc
  source ~/.bashrc
  # Check if the command was successful
  if [ $? -eq 0 ]; then
    echo "Aliases added"
  else
    echo "Aliases failed"
  fi
}

# Define a function to install soft keyboard
install_soft_keyboard() {
  sudo apt-get install matchbox-keyboard
  # Check if the command was successful
  if [ $? -eq 0 ]; then
    echo "Soft keyboard installed"
  else
    echo "Soft keyboard install failed"
  fi
}

# Define a function to reboot the system
reboot_system() {
  sudo reboot
  # Check if the command was successful
  if [ $? -eq 0 ]; then
    echo "System rebooted"
  else
    echo "System reboot failed"
  fi
}

# Define a function to optimize the SSD
optimize_ssd() {
  # Disable swap
  sudo dphys-swapfile swapoff
  sudo dphys-swapfile uninstall
  sudo update-rc.d dphys-swapfile remove
  # Enable TRIM
  sudo systemctl enable fstrim.timer
  sudo systemctl start fstrim.timer
  # Check if the commands were successful
  if [ $? -eq 0 ]; then
    echo "SSD optimized"
  else
    echo "SSD optimization failed"
  fi
}

# Exit the script if any command fails
set -e
# Exit the script if any unset variable is used
set -u

# Display and save the output of the commands to a file
exec &> >(tee -a log.txt)

# Measure the time taken by the script

# Run the functions in the desired order
install_display
# Push and commit after each function
cd /home/pi && git add . && git commit -m 'Display installed' && git push origin master
enable_zram
cd /home/pi && git add . && git commit -m 'ZRAM enabled' && git push origin master
disable_wifi_power
cd /home/pi && git add . && git commit -m 'WiFi power saving mode disabled' && git push origin master
setup_auto_reconnect
cd /home/pi && git add . && git commit -m 'Auto reconnect script set up' && git push origin master
clone_repo
cd /home/pi && git add . && git commit -m 'Repository cloned' && git push origin master
setup_cron_job
cd /home/pi && git add . && git commit -m 'Cron job set up' && git push origin master
uninstall_desktop
cd /home/pi && git add . && git commit -m 'Desktop uninstalled' && git push origin master
install_lxde
cd /home/pi && git add . && git commit -m 'LXDE installed' && git push origin master
install_kiauh
cd /home/pi && git add . && git commit -m 'Kiauh installed' && git push origin master
add_aliases
cd /home/pi && git add . && git commit -m 'Aliases added' && git push origin master
install_soft_keyboard
cd /home/pi && git add . && git commit -m 'Soft keyboard installed' && git push origin master
optimize_ssd
cd /home/pi && git add . && git commit -m 'SSD optimized' && git push origin master
reboot_system
cd /home/pi && git add . && git commit -m 'System rebooted' && git

sudo echo "net.ipv6.conf.all.disable_ipv6=1" > /etc/sysctl.d/disableipv6.conf
sudo echo 'blacklist ipv6' >> /etc/modprobe.d/blacklist
sudo sed -i '/::/s%^%#%g' /etc/hosts
sudo echo "net.ipv6.conf.all.disable_ipv6=1" > /etc/sysctl.d/disableipv6.conf
sudo echo 'blacklist ipv6' >> /etc/modprobe.d/blacklist
sudo sed -i '/::/s%^%#%g' /etc/hosts
sudo echo "net.ipv6.conf.all.disable_ipv6=1" > /etc/sysctl.d/disableipv6.conf
sudo echo 'blacklist ipv6' >> /etc/modprobe.d/blacklist
sudo sed -i '/::/s%^%#%g' /etc/hosts

sudo apt remove --purge code-the-classics python-minecraftpi

[Desktop Entry]
Version=1.1
Type=Application
Encoding=UTF-8
Name=GeeXLab
Comment=OpenGL demotool
Icon=/home/pi/Downloads/GeeXLab_FREE_rpi_gl21/geexlab_icon.png
Exec=/home/pi/Downloads/GeeXLab_FREE_rpi_gl21/GeeXLab
Terminal=false
Categories=Graphics

[Desktop Entry]
Version=1.1
Type=Application
Encoding=UTF-8
Name=Git Auto Commit and Push
Comment=A script to automatically commit and push changes to a repository
Icon=/usr/share/icons/Adwaita/256x256/apps/utilities-terminal.png
Exec=cd /home/pi && git add . && git commit -m 'Auto commit' && git push origin master
Terminal=true
Categories=Development

[Desktop Entry]
Version=1.1
Type=Link
Encoding=UTF-8
Name=Mainsail
Comment=A web interface for Klipper
Icon=/home/pi/mainsail_icon.png
URL=http://localhost:5000
Categories=Internet


Write-Output "##active_line3##"
Write-Output "##active_line4##"
# Update the system
Write-Output "##active_line5##"
sudo apt-get update && sudo apt-get upgrade -y
Write-Output "##active_line6##"
Write-Output "##active_line7##"
# Disable Wi-Fi power saving mode
Write-Output "##active_line8##"
echo 'wireless-power off' | sudo tee -a /etc/network/interfaces
Write-Output "##active_line9##"
Write-Output "##active_line10##"
# Create and set up the auto reconnect script
Write-Output "##active_line11##"
cat <<EOF | sudo tee /home/pi/auto_reconnect.sh
Write-Output "##active_line12##"
#!/bin/bash
Write-Output "##active_line13##"
while true; do
Write-Output "##active_line14##"
  if ! ifconfig wlan0 | grep -q 'inet '; then
Write-Output "##active_line15##"
    echo 'Reconnecting...'
Write-Output "##active_line16##"
    sudo ifconfig wlan0 down
Write-Output "##active_line17##"
    sleep 5
Write-Output "##active_line18##"
    sudo ifconfig wlan0 up
Write-Output "##active_line19##"
  fi
Write-Output "##active_line20##"
  sleep 60
Write-Output "##active_line21##"
done
Write-Output "##active_line22##"
EOF
Write-Output "##active_line23##"
sudo chmod +x /home/pi/auto_reconnect.sh
Write-Output "##active_line24##"
Write-Output "##active_line25##"
# Add script to startup
Write-Output "##active_line26##"
sudo sed -i -e ' /home/pi/auto_reconnect.sh &' /etc/rc.local
Write-Output "##active_line27##"
Write-Output "##active_line28##"
# Set up Git configuration
Write-Output "##active_line29##"
sudo git config --global user.name 'CloudDevStudios'
Write-Output "##active_line30##"
sudo git config --global user.email 'cdvst@outlook.com'
Write-Output "##active_line31##"
Write-Output "##active_line32##"
# Clone the repository into the home directory
Write-Output "##active_line33##"
sudo git clone https://github.com/CloudDevStudios/Vyper_cdvst.git /home/pi/Vyper_cdvst
Write-Output "##active_line34##"
Write-Output "##active_line35##"
# Set up cron job for auto commit and push every 12 hours
Write-Output "##active_line36##"
(crontab -l 2>/dev/null; echo '0 */12 * * * cd /home/pi/Vyper_cdvst && git add . && git commit -m "Auto commit" && git push') | crontab -
Write-Output "##active_line37##"
Write-Output "##active_line38##"
# Reboot the system
Write-Output "##active_line39##"
sudo reboot
Write-Output "##active_line40##"
# Systemneustart
sudo reboot
