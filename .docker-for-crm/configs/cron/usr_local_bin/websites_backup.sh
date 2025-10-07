#!/bin/bash

find /home/backup_hoststar.at/monthly -mtime +600 -exec rm {} \;
find /home/backup_hoststar.ch/monthly -mtime +600 -exec rm {} \;

find /home/backup_hoststar.at/weekly -mtime +100 -exec rm {} \;
find /home/backup_hoststar.ch/weekly -mtime +100 -exec rm {} \;

find /home/backup_hoststar.at/daily -mtime +30 -exec rm {} \;
find /home/backup_hoststar.ch/daily -mtime +30 -exec rm {} \;
