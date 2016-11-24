#!/bin/bash

#          Raspberry Pi setup, 'pi-heating-remote' configuration script.
# Author : Jeffrey.Powell ( jffrypwll <at> googlemail <dot> com )
# Date   : Nov 2016

# Die on any errors

set -e 

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
else
  printf "\n\n Apache is already installed. \n"
fi

# install app

# configure app

# configure apache vh on port 8080




printf "\n\n Installation Complete. Some changes might require a reboot. \n\n"
exit 1
