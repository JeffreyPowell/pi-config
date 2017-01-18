#!/bin/bash

#          Raspberry Pi setup, 'pi-heating-hub' configuration script.
# Author : Jeffrey.Powell ( jffrypwll <at> googlemail <dot> com )
# Date   : Nov 2016

# Die on any errors

#set -e
clear

if [[ `whoami` != "root" ]]
then
  printf "\n\n Script must be run as root. \n\n"
  exit 1
fi

OS_VERSION=$(cat /etc/os-release | grep VERSION=)
if [[ $OS_VERSION != *"jessie"* ]]
then
  printf "\n\n EXITING : Script must be run on PI OS Jessie. \n\n"
  exit 1
fi

APACHE_INSTALLED=$(which apache2)
if [[ "$APACHE_INSTALLED" == "" ]]
then
  printf "\n\n Installing Apache ...\n"
  # Install Apache
  apt-get install apache2 -y
  update-rc.d apache2 enable
  a2dissite 000-default.conf
  service apache2 restart

  APACHE_INSTALLED=$(which apache2)
    if [[ "$APACHE_INSTALLED" == "" ]]
    then
      printf "\n\n EXITING : Apache installation FAILED\n"
      exit 1
    fi
else
  printf "\n\n Apache is already installed. \n"
fi

PHP_INSTALLED=$(which php)
if [[ "$PHP_INSTALLED" == "" ]]
then
  printf "\n\n Installing PHP ...\n"
  # Install Apache
  apt-get install php5 -y

  PHP_INSTALLED=$(which php)
    if [[ "$PHP_INSTALLED" == "" ]]
    then
      printf "\n\n EXITING : PHP installation FAILED\n"
      exit 1
    fi
else
  printf "\n\n PHP is already installed. \n"
fi

MYSQL_INSTALLED=$(which mysql)
if [[ "$MYSQL_INSTALLED" == "" ]]
then
  printf "\n\n Installing MYSQL ...\n"
  # Install Apache
  apt-get install mysql-server -y --fix-missing

  MYSQL_INSTALLED=$(which mysql)
    if [[ "$MYSQL_INSTALLED" == "" ]]
    then
      printf "\n\n EXITING : MYSQL installation FAILED\n"
      exit 1
    fi
else
  printf "\n\n MYSQL is already installed. \n"
fi

# apt-get install python3-mysqldb -y

PYMYSQL_INSTALLED=$(find /var/lib/dpkg -name python-mysql*)
if [[ "$PYMYSQL_INSTALLED" == "" ]]
then
  printf "\n\n Installing MYSQL Python Module ...\n"
  # Install Apache
  apt-get install python-mysqldb -y

  PYMYSQL_INSTALLED=$(find /var/lib/dpkg -name python-mysql*)
    if [[ "$PYMYSQL_INSTALLED" == "" ]]
    then
      printf "\n\n EXITING : MYSQL Python Module installation FAILED\n"
      exit 1
    fi
else
  printf "\n\n MYSQL Python Module is already installed. \n"
fi


RRD_INSTALLED=$(find /var/lib/dpkg -name rrdtool*)
if [[ "$RRD_INSTALLED" == "" ]]
then
  printf "\n\n Installing RRD tool ...\n"
  # Install Apache
  apt-get install rrdtool php5-rrd -y

  RRD_INSTALLED=$(find /var/lib/dpkg -name rrdtool*)
    if [[ "$RRD_INSTALLED" == "" ]]
    then
      printf "\n\n EXITING : RRD tool installation FAILED\n"
      exit 1
    fi
else
  printf "\n\n RRD tool is already installed. \n"
fi

# Install 'pi-heating-hub' app

PI_HEATING_V='0.0.1'
if [ ! -f "/home/pi/pi-heating-hub/README.md" ]
then
  printf "\n\n Installing pi-heating-hub v$PI_HEATING_V ...\n"
  # Install Apache
  cd /home/pi
  if [ -d "/home/pi/pi-heating-hub" ]
  then
    rm -rf "/home/pi/pi-heating-hub"
  fi

  if [ -d "/var/www/pi-heating-hub" ]
  then
    rm -rf "/var/www/pi-heating-hub"
  fi

  wget "https://github.com/JeffreyPowell/pi-heating-hub/archive/$PI_HEATING_V.tar.gz" -O "/home/pi/pi-heating-hub.tar.gz"
  tar -xvzf "/home/pi/pi-heating-hub.tar.gz"
  rm "/home/pi/pi-heating-hub.tar.gz"
  mv "/home/pi/pi-heating-hub-$PI_HEATING_V" "/home/pi/pi-heating-hub"
  mv "/home/pi/pi-heating-hub/www" "/var/www/pi-heating-hub"
  chown -R pi:pi "/home/pi/pi-heating-hub"
  chmod -R 750 "/home/pi/pi-heating-hub"
  chown -R pi:pi "/var/www/pi-heating-hub"
  chmod -R 755 "/var/www/pi-heating-hub"

  if [ ! -f "/home/pi/pi-heating-hub/README.md" ]
    then
      printf "\n\n EXITING : pi-heating-hub v$PI_HEATING_V installation FAILED\n"
      exit 1
    fi

else
  printf "\n\n pi-heating-hub v$PI_HEATING_V is already installed. \n"
fi

if [ ! -d "/home/pi/pi-heating-hub/data" ]
  then
    mkdir "/home/pi/pi-heating-hub/data"

    cat > /etc/cron.d/pi-heating <<CRON
* * * * * pi /bin/bash /home/pi/pi-heating-hub/cron/wrapper.sh
CRON
    service cron restart
  fi



# configure app

# configure apache vh on port 8080

printf "\n\n Configuring Apache ...\n"

  cat > /etc/apache2/ports.conf <<PORTS
Listen 8080
PORTS

  cat > /etc/apache2/sites-available/pi-heating.conf <<VHOST
<VirtualHost *:8080>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/pi-heating-hub/
    <Directory /var/www/pi-heating-hub/>
        Options -Indexes
        AllowOverride all
        Order allow,deny
        allow from all
    </Directory>

    ErrorLog /var/log/apache2/error.log
    CustomLog /var/log/apache2/access.log combined
</VirtualHost>
VHOST

a2ensite pi-heating.conf
service apache2 restart

printf "\n\n Installation Complete. Some changes might require a reboot. \n\n"
exit 1
