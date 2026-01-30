#!/bin/bash

echo "

Ubuntu 20.04  [1]
Ubuntu 22.04  [2]
Ubuntu 24.04  [3]
"

read -p "==>" op

if [[ "$op" == "1" ]]; then
    mkdir -p /etc/apt/keyrings
    apt install curl coreutils  apt-transport-https gnupg -y
    curl -fsSL https://dl.packager.io/srv/zammad/zammad/key | \
   gpg --dearmor | sudo tee /etc/apt/keyrings/pkgr-zammad.gpg> /dev/null \
   && sudo chmod 644 /etc/apt/keyrings/pkgr-zammad.gpg
	echo "deb [signed-by=/etc/apt/keyrings/pkgr-zammad.gpg] https://dl.packager.io/srv/deb/zammad/zammad/stable/ubuntu 20.04 main"| \
   sudo tee /etc/apt/sources.list.d/zammad.list > /dev/null
    sudo apt update
   sudo apt install zammad -y
   zammad run rails r "Setting.set('es_url', 'http://localhost:9200')"
   curl http://localhost:9200
   echo "If The Output is \"Failed to connect\" Please Run \" systemctl status elasticsearch.service \" \"sudo systemctl start elasticsearch.service \""
   echo "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
   systemctl status zammad
   echo "If zammad Is Active , Install Done"
elif [[ "$op" == "2" ]]; then
    mkdir -p /etc/apt/keyrings
    apt install curl coreutils  apt-transport-https gnupg -y
   curl -fsSL https://dl.packager.io/srv/zammad/zammad/key | \
   gpg --dearmor | sudo tee /etc/apt/keyrings/pkgr-zammad.gpg> /dev/null \
   && sudo chmod 644 /etc/apt/keyrings/pkgr-zammad.gpg
   echo "deb [signed-by=/etc/apt/keyrings/pkgr-zammad.gpg] https://dl.packager.io/srv/deb/zammad/zammad/stable/ubuntu 22.04 main"| \
   sudo tee /etc/apt/sources.list.d/zammad.list > /dev/null	
   sudo apt update
   sudo apt install zammad -y
      zammad run rails r "Setting.set('es_url', 'http://localhost:9200')"
   curl http://localhost:9200
   echo "If The Output is \"Failed to connect\" Please Run \" systemctl status elasticsearch.service \" \"sudo systemctl start elasticsearch.service \""
   echo "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
   systemctl status zammad
   echo "If zammad Is Active , Install Done"
elif [[ "$op" == "3" ]]; then
    mkdir -p /etc/apt/keyrings
    apt install curl coreutils  apt-transport-https gnupg -y
   curl -fsSL https://dl.packager.io/srv/zammad/zammad/key | \
   gpg --dearmor | sudo tee /etc/apt/keyrings/pkgr-zammad.gpg> /dev/null \
   && sudo chmod 644 /etc/apt/keyrings/pkgr-zammad.gpg
   echo "deb [signed-by=/etc/apt/keyrings/pkgr-zammad.gpg] https://dl.packager.io/srv/deb/zammad/zammad/stable/ubuntu 24.04 main"| \
   sudo tee /etc/apt/sources.list.d/zammad.list > /dev/null
   sudo apt update
   sudo apt install zammad -y
   zammad run rails r "Setting.set('es_url', 'http://localhost:9200')"
   curl http://localhost:9200
   echo "If The Output is \"Failed to connect\" Please Run \" systemctl status elasticsearch.service \" \"sudo systemctl start elasticsearch.service \""
   echo "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
   systemctl status zammad
   echo "If zammad Is Active , Install Done"
else
    echo "Error"
    exit 0

fi
