#!/bin/bash

# Raspberry Pi setup, base configuration script.
# Author: Jeffrey.Powell ( jffrypwll <at> googlemail <dot> com )

# Die on any errors

#set -e 

if [[ `whoami` != "root" ]]
then
  printf "\n\n Script must be run as root. \n\n"
  exit 1
fi

OLD_HOSTNAME=$(cat /etc/hostname)

printf "\n\n Current hostname is : $OLD_HOSTNAME\n"
# Variables for the rest of the script
printf " Please choose a new hostname: (blank to skip) "
read NEW_HOSTNAME

if [[ "$NEW_HOSTNAME" = "" ]]
then
  printf " Hostname has not been changed.\n"
else
  # Update hostname
  printf " Changing hostname from $OLD_HOSTNAME to $NEW_HOSTNAME"
  echo "$NEW_HOSTNAME" > /etc/hostname
  sed -i "s/$OLD_HOSTNAME/$NEW_HOSTNAME/" /etc/hosts
  hostname $NEW_HOSTNAME
fi

OLD_IPADDR=$(hostname -I)
printf "\n\n Current IP address is : $OLD_IPADDR\n"
# Variables for the rest of the script
printf " Please choose a new STATIC IP address: (blank to skip) "
read NEW_IPADDR

printf "\n\n Configuring aliases ... \n"
sed -i "s/#alias ll='ls -l'/alias ll='ls -l'/" /home/pi/.bashrc



VIM_INSTALLED=$(which vim)

if [[ "$VIM_INSTALLED" == "" ]]
then
  printf "\n\n Installing Vim ...\n"
  # Install VIM editor
  apt-get install vim -y
  # Set VIM as the default editor
  update-alternatives --set editor /usr/bin/vim.basic
  # Vim settings (colors, syntax highlighting, tab space, etc).
  mkdir -p /home/pi/.vim/colors
  wget "http://www.vim.org/scripts/download_script.php?src_id=11157" -O /home/pi/.vim/colors/synic.vim
  # Set VIM defaults
  cat > /home/pi/.vimrc <<VIM
:syntax on
:colorscheme synic
:set t_Co=256
:set paste
:set softtabstop=2
:set tabstop=2
:set shiftwidth=2
:set expandtab
:set number
VIM
else
  printf "\n\n Vim is already installed. \n"
fi

printf "\n\n Installation Complete. Some changes might require a reboot. \n\n"

exit 1
