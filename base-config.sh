#!/bin/bash

# Raspberry Pi setup, base configuration script.
# Author: Jeffrey.Powell ( jffrypwll <at> googlemail <dot> com )

# Die on any errors

#set -e 

if [[ `whoami` != "root" ]]
then
  echo -e " \e[41m Script must be run as root. \e[49m"
  echo
  exit 1
fi
RED='\e[97m'
GREEN='\e[97m'
BLUE='\e[97m'
NC='\e[49m' # No Color

clear

OLD_HOSTNAME=$(cat /etc/hostname)

printf "$BLUE Current hostname is : $OLD_HOSTNAME"
# Variables for the rest of the script
printf " \e[97m Please choose a new hostname: (blank to skip)\n"
read NEW_HOSTNAME

if [[ "$NEW_HOSTNAME" = "" ]]
then
  echo -e " \e[97mHostname not changed"
else
  # Update hostname
  echo -e " \e[97m Changing hostname from $OLD_HOSTNAME to $NEW_HOSTNAME"
  echo -e " \e[97m $NEW_HOSTNAME" > /etc/hostname
  sed -i "s/$OLD_HOSTNAME/$NEW_HOSTNAME/" /etc/hosts
  hostname $NEW_HOSTNAME
fi

VIM_INSTALLED=$(which vim)
#VIM_INSTALLED=$(vim -v 2>/dev/null )

echo ">$VIM_INSTALLED<"

if [[ "$VIM_INSTALLED" == "" ]]
then
  # Install VIM editor
  apt-get install vim -y
  # Set VIM as the default editor
  update-alternatives --set editor /usr/bin/vim.basic
  # Vim settings (colors, syntax highlighting, tab space, etc).
  mkdir -p /home/pi/.vim/colors
  #wget "http://www.vim.org/scripts/download_script.php?src_id=11157" -O /home/pi/.vim/colors/synic
  # Set VIM defaults
  cat > /home/pi/.vimrc <<VIM
:syntax on
:set t_Co=256
:set paste
:set softtabstop=2
:set tabstop=2
:set shiftwidth=2
:set expandtab
:set number
:colorscheme synic
VIM
else
  printf " \e[97mVim is already installed"
fi

exit 1



# Now for some memory tweaks!
# Remove unnecessary consoles
sed -ie 's|l4:4:wait:/etc/init.d/rc 4|#l4:4:wait:/etc/init.d/rc 4|g' /etc/inittab
sed -ie 's|l5:5:wait:/etc/init.d/rc 5|#l5:5:wait:/etc/init.d/rc 5|g' /etc/inittab
sed -ie 's|l6:6:wait:/etc/init.d/rc 6|#l6:6:wait:/etc/init.d/rc 6|g' /etc/inittab

# Also disable serial console
#sed -ie 's|T0:23:respawn:/sbin/getty -L ttyAMA0 115200 vt100|#T0:23:respawn:/sbin/getty -L ttyAMA0 115200 vt100|g' /etc/inittab 

echo "Installation Complete. Some changes might require a reboot."
