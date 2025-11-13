#!/bin/bash
mkdir -p /home/old_logs/httpd
find /var/log/httpd -maxdepth 1 -name "access_log-*" -mtime +60 -exec mv {} /home/old_logs/httpd/. \;
find /var/log/httpd -maxdepth 1 -name "audit_log-*" -mtime +60 -exec mv {} /home/old_logs/httpd/. \;
find /var/log/httpd -maxdepth 1 -name "error_log-*" -mtime +60 -exec mv {} /home/old_logs/httpd/. \;
find /var/log/httpd -maxdepth 1 -name "suexec.log-*" -mtime +60 -exec mv {} /home/old_logs/httpd/. \;
