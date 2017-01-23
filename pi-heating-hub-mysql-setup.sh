#!/bin/bash

printf "\n\n\n Please enter the MySQL root password : "
read MYSQL_PASSWORD


PI_PASSWORD=$(date | md5sum | head -c12)

mysql -uroot -p$MYSQL_PASSWORD<< DATABASE

DROP DATABASE IF EXISTS pi_heating_db;
CREATE DATABASE pi_heating_db CHARACTER SET = utf8;

DROP USER pi@localhost;
FLUSH PRIVILEGES;
CREATE USER 'pi'@'localhost' IDENTIFIED BY '$PI_PASSWORD';

GRANT ALL ON pi_heating_db.* TO 'pi'@'localhost';

FLUSH PRIVILEGES;

USE pi_heating_db;

CREATE TABLE devices        ( id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
                              name VARCHAR(256) NOT NULL, 
                              pin INTEGER NOT NULL, 
                              value BOOLEAN DEFAULT FALSE );
INSERT INTO  devices VALUES ( 1,       'Hot Water Boiler',       08,          false );
INSERT INTO  devices VALUES ( 2,       'Heating Circulation',         10,          false );

CREATE TABLE sensors        ( id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, ref VARCHAR(20), name VARCHAR(256), ip  VARCHAR(16), value FLOAT );
INSERT INTO  sensors VALUES ( 1,      '28-0000000',    'Lounge',          '192.168.0.11',  0.0 );
INSERT INTO  sensors VALUES ( 2,      '28-0000001',    'Conservatory',    '192.168.0.11',  0.0 );

CREATE TABLE timers        ( id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, name VARCHAR(256), duration INT, start TIME, value BOOLEAN );
INSERT INTO  timers VALUES ( 1,       'Hot Water Boost', 30,           '00:00:00',      false );
INSERT INTO  timers VALUES ( 2,       'Heating Boost',   30,           '',              false );

CREATE TABLE modes        ( id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, name VARCHAR(256), value BOOLEAN );
INSERT INTO  modes VALUES ( 1,       'Holiday',         false );
INSERT INTO  modes VALUES ( 2,       'Weekend Away',    false );
INSERT INTO  modes VALUES ( 3,       'Guests Staying',  false );

CREATE TABLE schedules        ( id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, name VARCHAR(256),          start TIME, end TIME,   dow INT, value BOOLEAN );
INSERT INTO  schedules VALUES ( 1,      'Heating Weekday Morning',  '09:00:00', '18:00:00', 124,     false );
INSERT INTO  schedules VALUES ( 2,      'Heating Weekday Evening',  '17:30:00', '21:00:00', 124,     false );
INSERT INTO  schedules VALUES ( 3,      'Heating Weekday All day',  '00:01:00', '23:59:00', 124,     false );
INSERT INTO  schedules VALUES ( 4,      'Heating Everyday Boost',   '00:01:00', '23:59:00', 127,     false );
INSERT INTO  schedules VALUES ( 5,      'Heating Weekend All day',  '09:00:00', '18:00:00', 3,       false );
INSERT INTO  schedules VALUES ( 6,      'Water Weekday Morning',    '06:00:00', '08:00:00', 124,     false );
INSERT INTO  schedules VALUES ( 7,      'Water Weekday Evening',    '16:00:00', '21:00:00', 124,     false );

CREATE TABLE sched_device        ( id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, sched_id INT, device_id INT );
INSERT INTO  sched_device VALUES ( 1,      1,            1 );
INSERT INTO  sched_device VALUES ( 2,      2,            1 );
INSERT INTO  sched_device VALUES ( 3,      3,            1 );
INSERT INTO  sched_device VALUES ( 4,      4,            1 );
INSERT INTO  sched_device VALUES ( 5,      5,            1 );
INSERT INTO  sched_device VALUES ( 6,      6,            1 );
INSERT INTO  sched_device VALUES ( 7,      1,            2 );
INSERT INTO  sched_device VALUES ( 8,      2,            2 );
INSERT INTO  sched_device VALUES ( 9,      3,            2 );
INSERT INTO  sched_device VALUES (10,      4,            2 );

CREATE TABLE sched_sensor        ( id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, sched_id INT, sensor_id INT, opp CHAR, value FLOAT );
INSERT INTO  sched_sensor VALUES ( 1,      1,            1,            '<',      18.5 );
INSERT INTO  sched_sensor VALUES ( 2,      2,            1,            '<',      20.0 );
INSERT INTO  sched_sensor VALUES ( 3,      3,            1,            '<',      10.0 );

CREATE TABLE sched_timer         ( id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, sched_id INT, timer_id INT, opp CHAR, value BOOLEAN );
INSERT INTO  sched_timers VALUES ( 1,      1,            1,            '=',      False );

CREATE TABLE sched_mode          ( id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, sched_id INT, mode_id INT, opp CHAR, value BOOLEAN );
INSERT INTO  sched_modes VALUES  ( 1,      1,            1,           '=',      False );

DATABASE

cat > /hpme/pi/[i-heating-hub/config/config.ini <<CONFIG
[db]
server = localhost
user = pi
password = $PI_PASSWORD
database = pi_heating_db
CONFIG
