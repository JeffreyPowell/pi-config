#!/bin/bash

printf "\n\n\n Please enter the MySQL root password : "
read -s MYSQL_PASSWORD


PI_PASSWORD=$(date | md5sum | head -c12)

mysql -uroot -p$MYSQL_PASSWORD<< DATABASE

DROP DATABASE IF EXISTS pi_heating_db;
CREATE DATABASE pi_heating_db CHARACTER SET = utf8;

DELETE FROM mysql.user WHERE user='pi' AND host = 'localhost';
FLUSH PRIVILEGES;

CREATE USER 'pi'@'localhost' IDENTIFIED BY '$PI_PASSWORD';

GRANT ALL ON pi_heating_db.* TO 'pi'@'localhost';

FLUSH PRIVILEGES;

USE pi_heating_db;

CREATE TABLE IF NOT EXISTS devices   (
                                            'd_id' int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
                                            'name' varchar(256) NOT NULL,
                                            'pin' int(11) DEFAULT NULL,
                                            'active_level' tinyint(4) DEFAULT NULL,
                                            'value' tinyint(1) DEFAULT '0'
                                            );
  
CREATE TABLE IF NOT EXISTS 'sensors'   (
                                            'id' bigint(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
                                            'ref' varchar(20) DEFAULT NULL,
                                            'name' varchar(256) DEFAULT NULL,
                                            'ip' varchar(16) DEFAULT NULL,
                                            'value' float DEFAULT NULL,
                                            'unit' varchar(11) NOT NULL
                                            );

CREATE TABLE IF NOT EXISTS 'timers'    (
                                            'id' int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
                                            'name' varchar(256) DEFAULT NULL,
                                            'duration' int(11) DEFAULT NULL,
                                            'value' tinyint(1) DEFAULT NULL
                                            ); 

CREATE TABLE IF NOT EXISTS 'modes'     (
                                            'id' int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
                                            'name' varchar(256) DEFAULT NULL,
                                            'value' tinyint(1) DEFAULT NULL
                                            );
                            
CREATE TABLE IF NOT EXISTS 'schedules' (
                                            'id' int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY, 
                                            'name' varchar(256) DEFAULT NULL,
                                            'start' time DEFAULT NULL,
                                            'end' time DEFAULT NULL,  
                                            'dow1' tinyint(1) NOT NULL DEFAULT '0',
                                            'dow2' tinyint(1) NOT NULL DEFAULT '0',
                                            'dow3' tinyint(1) NOT NULL DEFAULT '0',
                                            'dow4' tinyint(1) NOT NULL DEFAULT '0',
                                            'dow5' tinyint(1) NOT NULL DEFAULT '0',
                                            'dow6' tinyint(1) NOT NULL DEFAULT '0',
                                            'dow7' tinyint(1) NOT NULL DEFAULT '0',
                                            'enabled' tinyint(1) NOT NULL DEFAULT '1',
                                            'active' tinyint(1) DEFAULT NULL
                                            );

CREATE TABLE IF NOT EXISTS 'sched_device' (
                                            'sd_id' int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
                                            'sched_id' int(11) DEFAULT NULL,
                                            'device_id' int(11) DEFAULT NULL
                                            );

CREATE TABLE IF NOT EXISTS 'sched_sensor' (
                                            'ss_id' int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
                                            'sched_id' int(11) DEFAULT NULL,
                                            'sensor_id' int(11) DEFAULT NULL,
                                            'opp' char(1) DEFAULT NULL,
                                            'value' float DEFAULT NULL
                                            );

CREATE TABLE IF NOT EXISTS 'sched_timer' (
                                            'st_id' int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
                                            'sched_id' int(11) DEFAULT NULL,
                                            'timer_id' int(11) DEFAULT NULL,
                                            'opp' char(1) DEFAULT NULL,
                                            'value' tinyint(1) DEFAULT NULL
                                            );

CREATE TABLE IF NOT EXISTS 'sched_mode' (
                                            'sm_id' int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
                                            'sched_id' int(11) DEFAULT NULL,
                                            'mode_id' int(11) DEFAULT NULL,
                                            'test_opp' char(1) DEFAULT NULL,
                                            'test_value' tinyint(1) DEFAULT NULL
                                            );
DATABASE

cat > /home/pi/pi-heating-hub/config/config.ini <<CONFIG
[db]
server = localhost
user = pi
password = $PI_PASSWORD
database = pi_heating_db
CONFIG
