#mysql --force --default-character-set=utf8 -uweb1 -p15HsTool usr_web1_1 < /home/www/web1/html/admin/verrechnung/jman/import.sql
scp -P 48531 -i /var/www/.ssh/id_rsa -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null /home/www/web1/html/admin/verrechnung/jman/import.sql root@185.48.228.58:/root/jmancron/import_ch.sql
