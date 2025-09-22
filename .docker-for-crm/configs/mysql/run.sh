#!/bin/bash

set -e

###########################################
##  $MYSQL_PORT should be determined     ##
##   in .env file for docker-compose.yml ##
###########################################
mysqld --port=$MYSQL_PORT
