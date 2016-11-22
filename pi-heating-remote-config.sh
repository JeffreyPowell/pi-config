#!/bin/bash

# Raspberry Pi setup, pi-heating-remote configuration script.
# Author: Jeffrey.Powell ( jffrypwll <at> googlemail <dot> com )

# Die on any errors
set -e 

if [[ `whoami` != "root" ]]
then
  echo "Script must be run as root."
  exit 1
fi

# Install apache, php, 
CHECK_APACHE=$(dpkg --get-selections | grep apache)
echo $CHECK_APACHE

apt-get install apache2

