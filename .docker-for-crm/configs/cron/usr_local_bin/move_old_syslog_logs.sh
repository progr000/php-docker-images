#!/bin/bash
mkdir -p /home/old_logs/other
mkdir -p /home/old_logs/mail
find /var/log -maxdepth 1 -name "messages-*" -mtime +60 -exec mv {} /home/old_logs/other/. \;
find /var/log -maxdepth 1 -name "firewall-*" -mtime +60 -exec mv {} /home/old_logs/other/. \;
find /var/log -maxdepth 1 -name "mail-*" -mtime +60 -exec mv {} /home/old_logs/mail/. \;
find /var/log -maxdepth 1 -name "mail.info-*" -mtime +60 -exec mv {} /home/old_logs/mail/. \;
find /var/log -maxdepth 1 -name "wtmp-*" -mtime +60 -exec mv {} /home/old_logs/other/. \;
