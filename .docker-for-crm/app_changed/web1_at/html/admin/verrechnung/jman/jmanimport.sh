scp -P 48531 -i /var/www/.ssh/id_rsa -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null /home/www/web1_at/html/admin/verrechnung/jman/import.sql root@185.48.228.58:/root/jmancron/import_at.sql
#mysql --force --default-character-set=utf8 -uweb1_at -p15HsTool_at usr_web1_1_at < /home/www/web1_at/html/admin/verrechnung/jman/import.sql
