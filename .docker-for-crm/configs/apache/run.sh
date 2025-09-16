#!/bin/bash

set -e

# https://stackoverflow.com/questions/75802175/is-there-a-way-to-use-localhost-with-mysqli-connect-and-force-tcp-connection
# run socat for forwarding requests to socket file to remote-host-port
socat UNIX-LISTEN:/var/run/mysqld/mysqld.sock,fork,reuseaddr,unlink-early,user=www-data,group=www-data,mode=777 TCP:10.5.0.5:3306 &

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

rm -f /var/run/apache2/apache2.pid
a2enmod rewrite
exec apache2 -DFOREGROUND
