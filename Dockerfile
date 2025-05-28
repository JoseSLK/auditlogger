FROM debian:latest

RUN apt-get update && apt-get install -y openssh-server sudo

RUN mkdir /var/run/sshd

COPY users.sh /usr/local/bin/users.sh 

RUN chmod +x /usr/local/bin/users.sh 

RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

RUN sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
