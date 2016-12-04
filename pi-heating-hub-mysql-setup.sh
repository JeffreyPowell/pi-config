#!/bin/bash

printf " Please enter the MySQL root password : "
read MYSQL_PASSWORD

Dmysql -uroot -p$MYSQL_PASSWORD<< EOF

CREATE DATABASE pi-heating_db;

CREATE USER 'pi'@'localhost' IDENTIFIED BY 'password';

GRANT ALL ON pi-heating_db.* TO 'pi'@'localhost';

FLUSH PRIVILEGES;

USE pi-heating_db;

CREATE TABLE outputs        ( id  INTEGER, name VARCHAR(256), pin INTEGER, value BOOLEAN );
INSERT INTO  outputs VALUES ( 1,           'Hot Water',       08,          false );
INSERT INTO  outputs VALUES ( 2,           'Heating',         10,          false );

CREATE TABLE inputs        ( id INTEGER, ref VARCHAR(20), name VARCHAR(256), ip  VARCHAR(16), value float );
INSERT INTO  inputs VALUES ( 1,          '28-0000000',     'Lounge',          192.168.0.11,   0.0 );
INSERT INTO  inputs VALUES ( 2,          '28-0000001',     'Conservatory',    192.168.0.11,   0.0 );

CREATE TABLE timers        ( id  INTEGER,  name VARCHAR(256), interval INTEGER, start TIME, value BOOLEAN );
INSERT INTO  timers VALUES ( 1,            'Hot Water Boost', 30,               '00:00:00', false );
INSERT INTO  timers VALUES ( 2,            'Heating Boost',   30,               '',         false );

CREATE TABLE modes        ( id  INTEGER,   name VARCHAR(256), value BOOLEAN );
INSERT INTO  modes VALUES ( 1,             'Holiday',         false );
INSERT INTO  modes VALUES ( 2,             'Weekend Away',    false );
INSERT INTO  modes VALUES ( 3,             'Guests Staying',  false );

CREATE TABLE schedules        ( id INTEGER,      name VARCHAR(256),          start TIME, end TIME,   dow INTEGER, value BOOLEAN );
INSERT INTO  schedules VALUES ( 1,               'Heating Weekday Morning',  '09:00:00', '18:00:00', 124,         false );
INSERT INTO  schedules VALUES ( 2,               'Heating Weekday Evening',  '17:30:00', '21:00:00', 124,         false );
INSERT INTO  schedules VALUES ( 3,               'Heating Weekday All day',  '00:01:00', '23:59:00', 124,         false );
INSERT INTO  schedules VALUES ( 4,               'Heating Everyday Boost',   '00:01:00', '23:59:00', 127,         false );
INSERT INTO  schedules VALUES ( 5,               'Heating Weekend All day',  '09:00:00', '18:00:00', 3,           false );
INSERT INTO  schedules VALUES ( 6,               'Water Weekday Morning',    '06:00:00', '08:00:00', 124,         false );
INSERT INTO  schedules VALUES ( 7,               'Water Weekday Evening',    '16:00:00', '21:00:00', 124,         false );

CREATE TABLE shed_output        ( id INTEGER, shed_id INTEGER, output_id INTEGER );
INSERT INTO  shed_output VALUES ( 1,          1,               1 );
INSERT INTO  shed_output VALUES ( 2,          2,               1 );
INSERT INTO  shed_output VALUES ( 3,          3,               1 );
INSERT INTO  shed_output VALUES ( 4,          4,               1 );
INSERT INTO  shed_output VALUES ( 5,          5,               1 );
INSERT INTO  shed_output VALUES ( 6,          6,               1 );
INSERT INTO  shed_output VALUES ( 7,          1,               2 );
INSERT INTO  shed_output VALUES ( 8,          2,               2 );
INSERT INTO  shed_output VALUES ( 9,          3,               2 );
INSERT INTO  shed_output VALUES (10,          4,               2 );

CREATE TABLE shed_input        ( id INTEGER, shed_id INTEGER, input_id INTEGER, operator CHAR, test FLOAT );
INSERT INTO  shed_input VALUES ( 1,          1,               1,                '<',           18.5 );
INSERT INTO  shed_input VALUES ( 2,          2,               1,                '<',           20.0 );
INSERT INTO  shed_input VALUES ( 3,          3,               1,                '<',           10.0 );

CREATE TABLE shed_timers        ( id INTEGER, shed_id INTEGER, timer_id INTEGER, operator CHAR, test BOOLEANT );
INSERT INTO  shed_timers VALUES ( 1,          1,               1,                '=',           False );

CREATE TABLE shed_modes        ( id INTEGER, shed_id INTEGER, mode_id INTEGER, operator CHAR, test BOOLEANT );
INSERT INTO  shed_modes VALUES ( 1,          1,               1,                '=',           False );

EOF




