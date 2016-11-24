#!/bin/bash

#          Raspberry Pi setup, 'pi-heating-remote' configuration script.
# Author : Jeffrey.Powell ( jffrypwll <at> googlemail <dot> com )
# Date   : Nov 2016

# Die on any errors

#set -e 

if [[ `whoami` != "root" ]]
then
  printf "\n\n Script must be run as root. \n\n"
  exit 1
fi

OS_VERSION=$(cat /etc/os-release | grep VERSION=)

if [[ $OS_VERSION != *"jessie"* ]]
then
  printf "n\n\ Script must be run on PI OS Jessie. \n\n"
  exit 1
fi


APACHE_INSTALLED=$(which apache)
if [[ "$APACHE_INSTALLED" == "" ]]
then
  printf "\n\n Installing Apache ...\n"
  # Install Apache
  apt-get install apache -y
  
  APACHE_INSTALLED=$(which apache)
    if [[ "$APACHE_INSTALLED" == "" ]]
    then
      printf "\n\n EXITING : Apache installation FAILED\n"
      exit 1
    fi
else
  printf "\n\n Apache is already installed. \n"
fi




# Install 'pi-heating-remote' app

PI_HEATING_V='0.0.1'
APP_INSTALLED=""
echo $APP_INSTALLED

if [[ "$APP_INSTALLED" == "" ]]
then
  printf "\n\n Installing pi-heating-remote v$PI_HEATING_V ...\n"
  # Install Apache
  cd /home/pi
  wget "https://github.com/JeffreyPowell/pi-heating-remote/archive/$PI_HEATING_V.tar.gz"
  tar -xvzf "$PI_HEATING_V.tar.gz"
  chown pi:pi "pi-heating-remote-$PI_HEATING_V"
  mv "pi-heating-remote-$PI_HEATING_V" "pi-heating-remote"
else
  printf "\n\n pi-heating-remote v$PI_HEATING_V is already installed. \n"
fi



# configure app

# configure apache vh on port 8080




printf "\n\n Installation Complete. Some changes might require a reboot. \n\n"
exit 1
