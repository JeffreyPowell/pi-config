!#/bin/bash

# Raspberry Pi setup, pi-heating-remote configuration script.
# Author: Jeffrey.Powell ( jffrypwll <at> googlemail <dot> com )

# Die on any errors
set -e 

if [[ `whoami` != "root" ]]
then
  echo "Script must be run as root."
  exit 1
fi

# Variables for the rest of the script
echo -n "Choose a hostname: "
read NEW_HOSTNAME
