#!/bin/bash

# Raspberry Pi setup, base configuration script.
# Author: Jeffrey.Powell ( jffrypwll <at> googlemail <dot> com )

# Die on any errors

clear

#set -e 

if [[ `whoami` != "root" ]]
then
  echo -e "\e[31mScript must be run as root."
  exit 1
fi

OLD_HOSTNAME=$(cat /etc/hostname)

echo -e " \e[34mCurrent hostname is : $OLD_HOSTNAME"
# Variables for the rest of the script
echo -en " \e[34mPlease choose a new hostname: (blank to skip)"
read NEW_HOSTNAME

if [[ "$NEW_HOSTNAME" = "" ]]
then
  echo -e " \e[34mHostname not changed"
else
  # Update hostname
  echo -e " \e[34m Changing hostname from $OLD_HOSTNAME to $NEW_HOSTNAME"
  echo -e " \e[34m $NEW_HOSTNAME" > /etc/hostname
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
  wget "http://www.vim.org/scripts/download_script.php?src_id=11157" -O /home/$NEW_USER/.vim/colors/synic
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
  echo -e " \e[34mBlueVim is already installed"
fi

exit 1

#echo -n "User: "
#read NEW_USER
#echo -n "Password for user (leave blank for disabled): "
#read PASS_PROMPT
#echo -n "Paste public key (leave blank for disabled): "
#read PUBLIC_KEY

#apt-get -y update



# Add user and authorized_keys
if [[ "$PASS_PROMPT" = "" ]]
then
  useradd -b /home --create-home -s /bin/bash -G sudo $NEW_USER
else
  useradd -b /home --create-home -s /bin/bash -G sudo $NEW_USER -p `echo "$PASS_PROMPT" | openssl passwd -1 -stdin` 
fi




# Now for some memory tweaks!
# Remove unnecessary consoles
sed -ie 's|l4:4:wait:/etc/init.d/rc 4|#l4:4:wait:/etc/init.d/rc 4|g' /etc/inittab
sed -ie 's|l5:5:wait:/etc/init.d/rc 5|#l5:5:wait:/etc/init.d/rc 5|g' /etc/inittab
sed -ie 's|l6:6:wait:/etc/init.d/rc 6|#l6:6:wait:/etc/init.d/rc 6|g' /etc/inittab

# Also disable serial console
#sed -ie 's|T0:23:respawn:/sbin/getty -L ttyAMA0 115200 vt100|#T0:23:respawn:/sbin/getty -L ttyAMA0 115200 vt100|g' /etc/inittab 

echo "Installation Complete. Some changes might require a reboot."
