## only for docker-container with parameters like this:
##  #network_mode: host
##  ports:
##    - ${MYSQL_PORT}:${MYSQL_PORT}

#SET PASSWORD FOR 'root'@'localhost' = PASSWORD('real-root-password-from-crm');
GRANT ALL PRIVILEGES ON *.* TO 'root'@'gateway' IDENTIFIED BY 'real-root-password-from-crm' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON usr_web1_1_at.* TO 'web1_at'@'%' IDENTIFIED BY 'real-root-password-from-crm';
GRANT ALL PRIVILEGES ON usr_web1_1_at.* TO 'web6'@'%' IDENTIFIED BY 'real-root-password-from-crm';
GRANT ALL PRIVILEGES ON usr_web1_1.* TO 'toolmaster'@'%' IDENTIFIED BY 'real-root-password-from-crm';
FLUSH PRIVILEGES;