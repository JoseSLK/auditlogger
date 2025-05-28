#!/bin/bash

for user in muskan anjali siddharth vanya svetlana vitaly vladimir;do 
  useradd -m -s /bin/bash "${user}" 
  echo "${user}:1234" | chpasswd
  adduser "${user}" sudo
done
