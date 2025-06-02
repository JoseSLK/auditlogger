FROM debian:latest

RUN apt-get update && apt-get install -y openssh-server sudo

RUN mkdir /var/run/sshd

RUN mkdir -p /var/log/audit_frequent_errors

RUN groupadd auditlog && \
    chown root:auditlog /var/log/audit_frequent_errors && \
    chmod 2775 /var/log/audit_frequent_errors

COPY frequent_errors.sh /etc/profile.d/frequent_errors.sh
COPY analysis_frecuent_errors.sh /usr/local/bin/analysis_frecuent_errors.sh
COPY frequency_commands.sh /usr/local/bin/frequency_commands.sh
COPY analysis_frequency_commands.sh /usr/local/bin/analysis_frequency_commands.sh
COPY frequency_risky_commands.sh /usr/local/bin/frequency_risky_commands.sh
COPY main.sh /usr/local/bin/main.sh
COPY users.sh /usr/local/bin/users.sh 

RUN chmod +x /usr/local/bin/users.sh 
RUN chmod +x /usr/local/bin/frequency_risky_commands.sh && \
    chmod +x /usr/local/bin/users.sh && \
    chmod +x /etc/profile.d/frequent_errors.sh && \
    chown root:root /etc/profile.d/frequent_errors.sh && \
    chmod +x /usr/local/bin/analysis_frecuent_errors.sh && \
    chmod +x /usr/local/bin/main.sh && \
    chmod +x /usr/local/bin/frequency_commands.sh && \
    chmod +x /usr/local/bin/analysis_frequency_commands.sh && \
    echo '%auditlog ALL=(ALL) NOPASSWD: /usr/bin/tee' >> /etc/sudoers

RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

RUN sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
