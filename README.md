# AUDITLOGGER
A simple tool for command audit.

## Team Members
- Dumar Hernán Malpica Lara 
- Jose Luis Salamanca López
- Nicolas Sarmiento Vargas
- Nicolas Samuel Tinjaca Topia

## System Requirements
- Docker >= 28.2.1
- Make  >= 4.3  (optional)


## Server Setup
If you have make just run the following commands:
```
make build
```
and then:
```
make run
```
Then you can skip to [Usage](#usage)
If you don't have Make, follow the following commands

Create Docker Image
```
docker build -t auditlogger .
```
Run the image
```
docker run -p 5000:22 --name audit_server --hostname audit_server -d auditlogger
```
Get in the container:
```
docker exec -it audit_server bash
```
Runt the script to create users:
```
/usr/local/bin/users.sh
```
Exit the container 
```
exit
```

## Usage
Connect to the server via ssh:
```
ssh <user>@localhost -p 5000
```
You can use the any user (muskan anjali siddharth vanya svetlana vitaly vladimir) with passcode 1234

Run this command:
```
sudo audit_logger
```
