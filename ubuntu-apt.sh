#!/bin/bash

echo "

Ubuntu 20.04  [1]
Ubuntu 22.04  [2]
Ubuntu 24.04  [3]
"

read -p "==>" op

if [[ "$op" == "1" ]]; then
    curl -fsSL https://dl.packager.io/srv/zammad/zammad/key | \
   gpg --dearmor | sudo tee /etc/apt/keyrings/pkgr-zammad.gpg> /dev/null \
   && sudo chmod 644 /etc/apt/keyrings/pkgr-zammad.gpg
	echo "deb [signed-by=/etc/apt/keyrings/pkgr-zammad.gpg] https://dl.packager.io/srv/deb/zammad/zammad/stable/ubuntu 20.04 main"| \
   sudo tee /etc/apt/sources.list.d/zammad.list > /dev/null
    sudo apt update
   sudo apt install zammad -y
elif [[ "$op" == "2" ]]; then
   curl -fsSL https://dl.packager.io/srv/zammad/zammad/key | \
   gpg --dearmor | sudo tee /etc/apt/keyrings/pkgr-zammad.gpg> /dev/null \
   && sudo chmod 644 /etc/apt/keyrings/pkgr-zammad.gpg
   echo "deb [signed-by=/etc/apt/keyrings/pkgr-zammad.gpg] https://dl.packager.io/srv/deb/zammad/zammad/stable/ubuntu 22.04 main"| \
   sudo tee /etc/apt/sources.list.d/zammad.list > /dev/null	
   sudo apt update
   sudo apt install zammad -y
elif [[ "$op" == "3" ]]; then
   curl -fsSL https://dl.packager.io/srv/zammad/zammad/key | \
   gpg --dearmor | sudo tee /etc/apt/keyrings/pkgr-zammad.gpg> /dev/null \
   && sudo chmod 644 /etc/apt/keyrings/pkgr-zammad.gpg
   echo "deb [signed-by=/etc/apt/keyrings/pkgr-zammad.gpg] https://dl.packager.io/srv/deb/zammad/zammad/stable/ubuntu 24.04 main"| \
   sudo tee /etc/apt/sources.list.d/zammad.list > /dev/null
   sudo apt update
   sudo apt install zammad -y
else
    echo "Error"
    exit 0

fi
