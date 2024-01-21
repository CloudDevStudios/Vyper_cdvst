Write-Output "##active_line3##"
#!/bin/bash
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