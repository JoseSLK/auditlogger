# AUDITLOGGER
A simple tool for command audit.

## Team Members
- Dumar Hernán Malpica Lara 
- Jose Luis Salamanca López
- Nicolas Sarmiento Vargas
- Nicolas Samuel Tinjaca Topia

## Server Setup
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
docker exec -it audit_server bash``
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
bash main.sh
```
