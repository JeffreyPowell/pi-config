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

printf " Current hostname is : $OLD_HOSTNAME\n"
# Variables for the rest of the script
printf " Please choose a new hostname: (blank to skip) "
read NEW_HOSTNAME

if [[ "$NEW_HOSTNAME" = "" ]]
then
  printf " Hostname not changed\n"
else
  # Update hostname
  printf " Changing hostname from $OLD_HOSTNAME to $NEW_HOSTNAME"
  echo "$NEW_HOSTNAME" > /etc/hostname
  sed -i "s/$OLD_HOSTNAME/$NEW_HOSTNAME/" /etc/hosts
  hostname $NEW_HOSTNAME
fi

VIM_INSTALLED=$(which vim)

if [[ "$VIM_INSTALLED" == "" ]]
then
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
  printf " Vim is already installed.\n"
fi

printf "\n\n Installation Complete. Some changes might require a reboot. \n\n"

exit 1



# Now for some memory tweaks!
# Remove unnecessary consoles
sed -ie 's|l4:4:wait:/etc/init.d/rc 4|#l4:4:wait:/etc/init.d/rc 4|g' /etc/inittab
sed -ie 's|l5:5:wait:/etc/init.d/rc 5|#l5:5:wait:/etc/init.d/rc 5|g' /etc/inittab
sed -ie 's|l6:6:wait:/etc/init.d/rc 6|#l6:6:wait:/etc/init.d/rc 6|g' /etc/inittab
