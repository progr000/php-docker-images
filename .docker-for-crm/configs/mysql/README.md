## MySQL
- version 5.7.41 or 5.5.62 (both were checked)

## Change MySQL default character set to UTF-8 in my.cnf
- https://stackoverflow.com/questions/3513773/change-mysql-default-character-set-to-utf-8-in-my-cnf

## Mapping for docker: 
- ./configs/mysql/my.cnf:/etc/my.cnf
- ./data/mysql-data-5.7.41:/var/lib/mysql
- ./data/mysql-backups:/mysql-backups

## Database commands for setup:
```bash
mysql -u root -p -e "CREATE DATABASE usr_web1_1; CREATE DATABASE usr_web1_1_at; CREATE DATABASE usr_web8_1; CREATE DATABASE usr_web8_2;"

mysql -u root -p usr_web1_1 < /mysql-backups/usr_web1_1.dump.sql
mysql -u root -p usr_web1_1_at < /mysql-backups/usr_web1_1_at.dump.sql
mysql -u root -p usr_web8_1 < /mysql-backups/usr_web8_1.dump.sql
mysql -u root -p usr_web8_2 < /mysql-backups/usr_web8_2.dump.sql 

mysql -u root -p -e "GRANT ALL PRIVILEGES ON usr_web1_1.* TO 'web1'@'%'; GRANT ALL PRIVILEGES ON usr_web1_1_at.* TO 'web1'@'%'; GRANT ALL PRIVILEGES ON usr_web8_1.* TO 'web1'@'%'; GRANT ALL PRIVILEGES ON usr_web8_2.* TO 'web1'@'%'; FLUSH PRIVILEGES;"
```
