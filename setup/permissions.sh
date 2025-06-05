groupadd auditlog

mv /usr/local/bin/auditlogger/setup/motd /etc/motd

mkdir -p /var/log/audit_frequent_errors
mkdir -p /var/log/audit/users
mkdir -p /var/log/audit/report
mkdir -p /var/log/audit/aux


touch /var/log/audit_frequent_errors/error.log
touch /var/log/audit/users/root_session.log
touch /var/log/audit/users/root.log


mv /usr/local/bin/auditlogger/src/loggers/frequent_errors.sh /etc/profile.d/frequent_errors.sh
mv /usr/local/bin/auditlogger/src/loggers/log_history.sh /etc/profile.d/log_history.sh
mv /usr/local/bin/auditlogger/src/loggers/user_session.sh /etc/profile.d/user_session.sh

chown root:auditlog /var/log/audit_frequent_errors 
chown root:auditlog /var/log/audit/users/
chown root:auditlog /var/log/audit/report/ 
 
chmod 2775 /var/log/audit_frequent_errors
chmod 2755 /var/log/audit/users
chmod 744 /var/log/audit/report
chmod 722 /var/log/audit_frequent_errors/error.log
chmod 722 /var/log/audit/aux

chown root:root /etc/profile.d/frequent_errors.sh
chown root:root /etc/profile.d/log_history.sh 
chown root:root /etc/profile.d/user_session.sh
chown root:root /var/log/audit_frequent_errors/error.log

chmod +x /etc/profile.d/frequent_errors.sh 
chmod +x /etc/profile.d/log_history.sh 
chmod +x /etc/profile.d/user_session.sh

chmod +x /usr/local/bin/auditlogger/src/main.sh

#echo '%auditlog ALL=(ALL) NOPASSWD: /usr/bin/tee' >> /etc/sudoers

sudo ln -s /usr/local/bin/auditlogger/src/main.sh /usr/local/bin/audit_logger
