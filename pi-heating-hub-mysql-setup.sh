#!/bin/bash

printf "\n\n\n Please enter the MySQL root password : "
read MYSQL_PASSWORD

mysql -uroot -p$MYSQL_PASSWORD<< EOF

DROP DATABASE IF EXISTS pi_heating_db;
CREATE DATABASE pi_heating_db CHARACTER SET = utf8;

DROP USER pi@localhost;
FLUSH PRIVILEGES;
CREATE USER 'pi'@'localhost' IDENTIFIED BY 'password';

GRANT ALL ON pi_heating_db.* TO 'pi'@'localhost';

FLUSH PRIVILEGES;

USE pi_heating_db;

CREATE TABLE devices        ( id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
                              name VARCHAR(256) NOT NULL, 
                              pin INTEGER NOT NULL, 
                              value BOOLEAN DEFAULT FALSE );
INSERT INTO  outputs VALUES ( 1,       'Hot Water',       08,          false );
INSERT INTO  outputs VALUES ( 2,       'Heating',         10,          false );

CREATE TABLE inputs        ( id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, ref VARCHAR(20), name VARCHAR(256), ip  VARCHAR(16), value FLOAT );
INSERT INTO  inputs VALUES ( 1,      '28-0000000',    'Lounge',          '192.168.0.11',  0.0 );
INSERT INTO  inputs VALUES ( 2,      '28-0000001',    'Conservatory',    '192.168.0.11',  0.0 );

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

CREATE TABLE sched_output        ( id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, sched_id INT, output_id INT );
INSERT INTO  sched_output VALUES ( 1,      1,            1 );
INSERT INTO  sched_output VALUES ( 2,      2,            1 );
INSERT INTO  sched_output VALUES ( 3,      3,            1 );
INSERT INTO  sched_output VALUES ( 4,      4,            1 );
INSERT INTO  sched_output VALUES ( 5,      5,            1 );
INSERT INTO  sched_output VALUES ( 6,      6,            1 );
INSERT INTO  sched_output VALUES ( 7,      1,            2 );
INSERT INTO  sched_output VALUES ( 8,      2,            2 );
INSERT INTO  sched_output VALUES ( 9,      3,            2 );
INSERT INTO  sched_output VALUES (10,      4,            2 );

CREATE TABLE sched_input        ( id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, sched_id INT, input_id INT, opp CHAR, value FLOAT );
INSERT INTO  sched_input VALUES ( 1,      1,            1,            '<',      18.5 );
INSERT INTO  sched_input VALUES ( 2,      2,            1,            '<',      20.0 );
INSERT INTO  sched_input VALUES ( 3,      3,            1,            '<',      10.0 );

CREATE TABLE sched_timers        ( id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, sched_id INT, timer_id INT, opp CHAR, value BOOLEAN );
INSERT INTO  sched_timers VALUES ( 1,      1,            1,            '=',      False );

CREATE TABLE sched_modes         ( id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, sched_id INT, mode_id INT, opp CHAR, value BOOLEAN );
INSERT INTO  sched_modes VALUES  ( 1,      1,            1,           '=',      False );

EOF




