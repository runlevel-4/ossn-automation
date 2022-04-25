#!/bin/bash

# Check if Debain is installed.  If it is, install the php repositories
if grep -q Debian "/etc/os-release" ; then
	echo "[Debian is installed]"
	echo
	echo "[Installing Debian prerequisites]"
	echo
	sudo apt update
	sudo apt install -y curl wget gnupg2 ca-certificates lsb-release apt-transport-https
	wget https://packages.sury.org/php/apt.gpg
	sudo apt-key add apt.gpg
  	echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php8.list
else
	echo "Not Debian...continuing"
	echo
	echo "Adding Ubuntu PHP repos"
	echo
	
	# Add the PHP 8.0 repo
	sudo apt install ca-certificates apt-transport-https software-properties-common -y
	sudo add-apt-repository ppa:ondrej/php
	sudo add-apt-repository ppa:ondrej/apache2
fi

echo

# Perform updates
echo "[Installing System Updates]"
echo
sudo apt update && sudo apt upgrade -y
sudo apt install unzip -y
echo

# Install web components
echo "[Installing Web Components]"
echo
sudo apt install apache2 mariadb-common mariadb-server php7.4 php7.4-mysql php7.4-zip php7.4-xml php7.4-curl php7.4-mb* php7.4-gd php7.4-dom php7.4-zip php7.4-json -y
echo

# Download and decompress OSSN to web directory /var/www/html/ossn
echo "[Downloading and installing OSSN]"
echo
wget https://www.opensource-socialnetwork.org/download_ossn/latest/build.zip
unzip build.zip -d var/www/html/
sudo chown -r www-data:www-data /var/www/html/ossn
sudo mkdir var/www/html/ossn/data
echo

# MySQL Configuration
echo "[Press Enter:]"
echo
sudo mysql -u root -p < $HOME/ossn-automation/mysql_setup.sql
echo

# Restart web service
sudo systemctl restart apache2
