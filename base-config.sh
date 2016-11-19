#!/bin/bash

# Raspberry Pi setup, base configuration script.
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
echo -n "User: "
read NEW_USER
echo -n "Password for user (leave blank for disabled): "
read PASS_PROMPT
echo -n "Paste public key (leave blank for disabled): "
read PUBLIC_KEY


apt-get -y update

# Install some base packages
apt-get install -y --force-yes vim

# Update hostname
echo "$NEW_HOSTNAME" > /etc/hostname
sed -i "s/raspberrypi/$NEW_HOSTNAME/" /etc/hosts
hostname $NEW_HOSTNAME

# Set VIM as the default editor
update-alternatives --set editor /usr/bin/vim.basic

# Add user and authorized_keys
if [[ "$PASS_PROMPT" = "" ]]
then
  useradd -b /home --create-home -s /bin/bash -G sudo $NEW_USER
else
  useradd -b /home --create-home -s /bin/bash -G sudo $NEW_USER -p `echo "$PASS_PROMPT" | openssl passwd -1 -stdin` 
fi

# Remove Pi user's password
passwd -d pi

if [[ "$PUBLIC_KEY" != "" ]]
then
  mkdir -p /home/$NEW_USER/.ssh/
  echo "$PUBLIC_KEY" > /home/$NEW_USER/.ssh/authorized_keys
fi
chown -R $NEW_USER:$NEW_USER /home/$NEW_USER

# Allow users in the sudo group to sudo without password
#sed -i 's/%sudo.*/%sudo   ALL=NOPASSWD: ALL/g' /etc/sudoers

# Turn off password authentication 
#sed -i 's/#   PasswordAuthentication yes/    PasswordAuthentication no/g' /etc/ssh/ssh_config

# Vim settings (colors, syntax highlighting, tab space, etc).
mkdir -p /home/$NEW_USER/.vim/colors
wget "http://www.vim.org/scripts/download_script.php?src_id=11157" -O /home/$NEW_USER/.vim/colors/synic

cat > /home/$NEW_USER/.vimrc <<VIM
:syntax on
:set t_Co=256
:set paste
:set softtabstop=2
:set tabstop=2
:set shiftwidth=2
:set expandtab
:colorscheme synic
VIM

# Now for some memory tweaks!
# Remove unnecessary consoles
sed -ie 's|l4:4:wait:/etc/init.d/rc 4|#l4:4:wait:/etc/init.d/rc 4|g' /etc/inittab
sed -ie 's|l5:5:wait:/etc/init.d/rc 5|#l5:5:wait:/etc/init.d/rc 5|g' /etc/inittab
sed -ie 's|l6:6:wait:/etc/init.d/rc 6|#l6:6:wait:/etc/init.d/rc 6|g' /etc/inittab

# Also disable serial console
#sed -ie 's|T0:23:respawn:/sbin/getty -L ttyAMA0 115200 vt100|#T0:23:respawn:/sbin/getty -L ttyAMA0 115200 vt100|g' /etc/inittab 

echo "Installation Complete. Some changes might require a reboot."
