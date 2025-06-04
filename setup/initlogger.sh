#!/bin/bash

source /usr/local/bin/permissions.config

LOG_GROUP="auditlog"

for user in muskan anjali siddharth vanya svetlana vitaly vladimir;do 
  useradd -m -s /bin/bash "${user}" 
  echo "${user}:1234" | chpasswd
  adduser "${user}" sudo
  adduser "${user}" "$LOG_GROUP"

  touch /var/log/audit/users/${user}.log
  touch /var/log/audit/users/${user}_session.log

  chown "${user}:${user}" /var/log/audit/users/${user}.log
  chown "${user}:${user}" /var/log/audit/users/${user}_session.log

  chmod 644 /var/log/audit/users/${user}.log
  chmod 644 /var/log/audit/users/${user}_session.log

done
