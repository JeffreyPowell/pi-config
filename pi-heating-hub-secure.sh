#!/bin/bash

#          Raspberry Pi setup, 'pi-heating-hub' configuration script.
# Author : Jeffrey.Powell ( jffrypwll <at> googlemail <dot> com )
# Date   : Nov 2016

# Die on any errors

#set -e
clear

if [[ `whoami` != "root" ]]
then
  printf "\n\n Script must be run as root. \n\n"
  exit 1
fi

OS_VERSION=$(cat /etc/os-release | grep VERSION=)
if [[ $OS_VERSION != *"jessie"* ]]
then
  printf "\n\n EXITING : Script must be run on PI OS Jessie. \n\n"
  exit 1
fi

cd /home/pi

cat > /var/www/pi-heating-hub/.htaccess <<ACCESS
AuthName "Secure Heating Hub"
AuthType Basic
AuthUserFile /home/pi/pi-heating-hub/.htpasswd
require valid-user
ACCESS

htpasswd -c .htpasswd admin

mv /home/pi/.htpasswd /home/pi/pi-heating-hub/.htpasswd
chmod 644 /home/pi/pi-heating-hub/.htpasswd




printf "\n\n Installation Complete. Some changes might require a reboot. \n\n"
exit 1
