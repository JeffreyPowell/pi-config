#!/bin/bash

#          Raspberry Pi setup, base configuration script.
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

apt-get update

OLD_HOSTNAME=$(cat /etc/hostname)

printf "\n\n Current hostname is : $OLD_HOSTNAME\n"
# Variables for the rest of the script
printf " Please choose a new hostname: (leave blank to not change) "
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
printf " Please choose a new STATIC IP address: (blank to skip network change) "
read NEW_IPADDR

if [[ "$NEW_IPADDR" = "" ]]
then
  printf " Network configuration has not been changed.\n"
else
  OLD_ROUTERADDR=$(route -n | grep 'UG[ \t]' | awk '{print $2}')
  printf "\n Current GATEWAY address is : $OLD_ROUTERADDR\n"
  printf " Please choose a new GATEWAY address: (leave blank to not change) "
  read NEW_ROUTERADDR
  if [[ "$NEW_ROUTERADDR" = "" ]]
  then
  NEW_ROUTERADDR=$OLD_ROUTERADDR
  fi

  OLD_DNSADDR=$(cat /etc/resolv.conf | grep 'name' | awk '{print $2}')
  printf "\n Current DNS address is : $OLD_DNSADDR\n"
  printf " Please choose a new DNS address: (leave blank to not change) "
  read NEW_DNSADDR
  if [[ "$NEW_DNSADDR" = "" ]]
  then
  NEW_DNSADDR=$OLD_DNSADDR
  fi
  
  cat > /etc/dhcpcd.conf <<STATIC
hostname
clientid
persistent
option rapid_commit
option domain_name_servers, domain_name, domain_search, host_name
option classless_static_routes
option ntp_servers
require dhcp_server_identifier
slaac private
nohook lookup-hostname

interface wlan0
static ip_address=$NEW_IPADDR/24
static routers=$NEW_ROUTERADDR
static domain_name_servers=$NEW_DNSADDR
STATIC

fi


printf "\n\n Configuring aliases ... \n"
cat > /home/pi/.bash_aliases <<ALIASES
alias ll='ls -hal'
alias la='ls -A'
alias l='ls -CF'
ALIASES

chown pi:pi /home/pi/.bash_aliases
su -c "source /home/pi/.bashrc" pi

VIM_INSTALLED=$(which vim)

if [[ "$VIM_INSTALLED" == "" ]]
then
  printf "\n\n Installing Vim ...\n"
  # Install VIM editor
  apt-get install vim -y
  # Set VIM as the default editor
  update-alternatives --set editor /usr/bin/vim.basic
  # Vim settings (colors, syntax highlighting, tab space, etc).
  chown pi:pi /home/pi/.vim
  mkdir -p /home/pi/.vim/colors
  chown pi:pi /home/pi/.vim/colors
  wget "http://www.vim.org/scripts/download_script.php?src_id=11157" -O /home/pi/.vim/colors/synic.vim
  chown pi:pi /home/pi/.vim/colors/synic.vim
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
 chown pi:pi /home/pi/.vimrc
else
  printf "\n\n Vim is already installed. \n"
fi

printf "\n\n Installation Complete. Some changes might require a reboot. \n\n"
exit 1
