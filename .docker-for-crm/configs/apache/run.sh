#!/bin/bash

set -e

##################################################################
##  Fix for mysql was available via socket in apache-container  ##
##  $MYSQL_HOST_FOR_SOCAT, $MYSQL_PORT_FOR_SOCAT                ##
##  should be determined in .env file or docker-compose.yml     ##
##################################################################
socat UNIX-LISTEN:/var/run/mysqld/mysqld.sock,fork,reuseaddr,unlink-early,user=www-data,group=www-data,mode=777 TCP:$MYSQL_HOST_FOR_SOCAT:$MYSQL_PORT_FOR_SOCAT &

##########################
##  CRON setup and run  ##
##########################
mkdir -p /home/backup/current /home/backup/tmp /home/backup/hourly.1 /home/backup/hourly.2 /home/backup/hourly.3 || true
mkdir -p /home/mysql_backup/current /home/mysql_backup/daily.1 /home/mysql_backup/daily.2 /home/mysql_backup/daily.3 /home/mysql_backup/daily.4 /home/mysql_backup/daily.5 /home/mysql_backup/daily.6 || true
/usr/sbin/cron -f &

##################
##  APACHE run  ##
##################
rm -f /var/run/apache2/apache2.pid
exec apache2 -DFOREGROUND





### disabled, and here for history and just in case: ###
# https://stackoverflow.com/questions/75802175/is-there-a-way-to-use-localhost-with-mysqli-connect-and-force-tcp-connection
# run socat for forwarding requests to socket file to remote-host-port
#socat UNIX-LISTEN:/var/run/mysqld/mysqld.sock,fork,reuseaddr,unlink-early,user=www-data,group=www-data,mode=777 TCP:10.5.0.5:3306 &
#socat UNIX-LISTEN:/var/run/mysqld/mysqld.sock,fork,reuseaddr,unlink-early,user=www-data,group=www-data,mode=777 TCP:crm-test-mysql:3306 &

#iptables -F -t nat
#iptables -t nat -A OUTPUT -o lo -p tcp --dport 3306 -j DNAT --to-destination 10.5.0.5:3306
#iptables -A POSTROUTING -t nat -j MASQUERADE

#&& iptables -t nat -A PREROUTING -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT \
#&& iptables -t nat -A PREROUTING -i lo -p tcp --dport 3306 -m conntrack --ctstate NEW -j DNAT --to 10.5.0.5:3306 \
#&& iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 3306 -m conntrack --ctstate NEW -j DNAT --to 10.5.0.5:3306 \
#&& iptables -t nat -A PREROUTING -p tcp --dport 3306 -m conntrack --ctstate NEW -j DNAT --to 10.5.0.5:3306 \
#&& iptables -t nat -A POSTROUTING -d 10.5.0.5 -j MASQUERADE

#exec /usr/sbin/apache2 -D FOREGROUND
#apache2ctl -DFOREGROUND

#a2enmod rewrite