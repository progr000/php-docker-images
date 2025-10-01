## only for docker-container with parameters like this:
##  #network_mode: host
##  ports:
##    - ${MYSQL_PORT}:${MYSQL_PORT}
GRANT ALL PRIVILEGES ON *.* TO 'root'@'gateway' IDENTIFIED BY 'real-root-password-from-crm' WITH GRANT OPTION;
FLUSH PRIVILEGES;