    # the problem is: a lot of scripts have hardcoded localhost connection to mysql, and we cannot change them all,
    # but mysql in another docker container, so I need somehow forward localhost:3306 to 10.5.0.5:3306
    # iptables -F -t nat
    # iptables -t nat -A OUTPUT -o lo -p tcp --dport 3306 -j DNAT --to-destination 10.5.0.5:3306
    # iptables -A POSTROUTING -t nat -j MASQUERADE
    # but problem is deeper and forwarding doesn't help, because mysqli('localhost', 'user', 'pass' ...
    # tell to php to use socket but not tcp-connection
    # in this case I need to install in this docker software <<socat>> and make forwarding local socket to tcp 10.5.0.5:3306
    # like this command: `socat UNIX-LISTEN:/tmp/mysql.sock,fork,reuseaddr,unlink-early,user=root,group=root,mode=777 TCP:10.5.0.5:3306`
    # see .docker-from-my/configs/apache/run.sh
    # also I need to set sockets in php.ini (mysqli.default_socket =, pdo_mysql.default_socket=, mysql.default_socket =)
    #
    # this option add additional records into /etc/hosts which is in docker-container machine
    #extra_hosts:
    #  - "host-name:10.5.0.5"
    #
    # these options enable you to work with iptables.
    # but as I described before not need to use it, but need use <<socat>>
    #cap_add:
    #  - NET_ADMIN
    #  - ALL
    #
    # these options allow manage some /proc/sys parameters for docker-container machine
    # without specific parameters, iptables will not function correctly.
    #sysctls:
    #  - net.ipv4.ip_forward=1
    #  - net.ipv4.conf.all.route_localnet=1
    #  - net.ipv6.conf.lo.disable_ipv6=1

