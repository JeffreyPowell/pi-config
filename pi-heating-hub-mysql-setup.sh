#!/bin/bash

mysql -uroot -ptest test << EOF

CREATE DATABASE pi-heating_db;

CREATE USER 'pi'@'localhost' IDENTIFIED BY 'password';

GRANT ALL ON pi-heating_db.* TO 'pi'@'localhost';

FLUSH PRIVILEGES;

USE pi-heating_db;

CREATE TABLE inputs        ( ref VARCHAR(20), name VARCHAR(256), ip  VARCHAR(16), value VARCHAR(256) );

CREATE TABLE outputs        ( id  INTEGER, name VARCHAR(256), pin INTEGER, value BOOLEAN );
INSERT INTO  outputs VALUES ( 1,           'Hot Water',       08,          false );
INSERT INTO  outputs VALUES ( 2,           'Heating',         10,          false );

CREATE TABLE timers        ( id  INTEGER,  name VARCHAR(256), interval INTEGER, start TIME, value BOOLEAN );
INSERT INTO  timers VALUES ( 1,            'Hot Water Boost', 30,               '00:00:00', false );
INSERT INTO  timers VALUES ( 2,            'Heating Boost',   30,               '',         false );

CREATE TABLE modes        ( id  INTEGER,   name VARCHAR(256), value BOOLEAN );
INSERT INTO  modes VALUES ( 1,             'Holiday',         false );
INSERT INTO  modes VALUES ( 2,             'Weekend Away',    false );
INSERT INTO  modes VALUES ( 3,             'Guests Staying',  false );

CREATE TABLE schedules        ( ref VARCHAR(20), name VARCHAR(256), start TIME, end TIME,   repeat INTEGER, value BOOLEAN );
INSERT INTO  schedules VALUES ( 1,              'WeekDay Heating',      '09:00:00', '18:00:00', 128,            false );
INSERT INTO  schedules VALUES ( 2,              'WeekDay Water 1',      '06:00:00', '08:00:00', 128,            false );
INSERT INTO  schedules VALUES ( 3,              'WeekDay Water 2',      '16:00:00', '21:00:00', 128,            false );

CREATE TABLE shed_output        ( id INTEGER, shed_id INTEGER, output_id INTEGER );
INSERT INTO  shed_output VALUES ( 1,          1,               1 );
INSERT INTO  shed_output VALUES ( 2,          1,               2 );
INSERT INTO  shed_output VALUES ( 3,          2,               1 );

EOF
