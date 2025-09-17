## Apache:
- Server version: Apache/2.4.10 (Debian)
- Server built:   Sep 30 2019 19:32:08

## PHP:
- PHP 5.3.29 (cli) (built: Sep 12 2025 13:49:31)
- Copyright (c) 1997-2014 The PHP Group
- Zend Engine v2.3.0, Copyright (c) 1998-2014 Zend Technologies

## Maping for docker:
- ./configs/apache/etc_apache2:/etc/apache2
- ./configs/apache/usr_sbin/apache2-systemd-ask-pass:/usr/sbin/apache2-systemd-ask-pass
- ./configs/apache/usr_share_apache2-mod_security2:/usr/share/apache2-mod_security2
- ./configs/apache/usr_local_apache2:/usr/local/apache2
- ./configs/php/php.ini:/etc/php5/apache2/php.ini
- ./../app:/home/www
- ./configs/apache/run.sh:/run.sh