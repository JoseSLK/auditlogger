LOG_GROUP="auditlog"

while read -r user passkey; do
  useradd -m -s /bin/bash "${user}" 
  echo "${user}:${passkey}" | chpasswd
  adduser "${user}" sudo
  adduser "${user}" "$LOG_GROUP"

  touch /var/log/audit/users/${user}.log
  touch /var/log/audit/users/${user}_session.log

  chown "${user}:${user}" /var/log/audit/users/${user}.log
  chown "${user}:${user}" /var/log/audit/users/${user}_session.log

  chmod 644 /var/log/audit/users/${user}.log
  chmod 644 /var/log/audit/users/${user}_session.log
done < /usr/local/bin/auditlogger/setup/users.config