#!/bin/bash

echo "

Debian 11 [1]
Debian 12 [2]
"

read -p "==>" op

if [[ "$op" == "1" ]]; then
    curl -fsSL https://dl.packager.io/srv/zammad/zammad/key | \
   gpg --dearmor | sudo tee /etc/apt/keyrings/pkgr-zammad.gpg> /dev/null \
   && sudo chmod 644 /etc/apt/keyrings/pkgr-zammad.gpg

    echo "deb [signed-by=/etc/apt/keyrings/pkgr-zammad.gpg] https://dl.packager.io/srv/deb/zammad/zammad/stable/debian 11 main"| \
   tee /etc/apt/sources.list.d/zammad.list > /dev/null
   sudo apt update
   sudo apt install zammad -y
elif [[ "$op" == "2" ]]; then
    curl -fsSL https://dl.packager.io/srv/zammad/zammad/key | \
   gpg --dearmor | sudo tee /etc/apt/keyrings/pkgr-zammad.gpg> /dev/null \
   && sudo chmod 644 /etc/apt/keyrings/pkgr-zammad.gpg
    echo "deb [signed-by=/etc/apt/keyrings/pkgr-zammad.gpg] https://dl.packager.io/srv/deb/zammad/zammad/stable/debian 12 main"| \
   tee /etc/apt/sources.list.d/zammad.list > /dev/null
   sudo apt update
   sudo apt install zammad -y
else
    echo "Error"
    exit 0

fi
