#!/bin/bash

# IsThereDocker(){
#     echo "Do You Install Docker?
# Yes (1)
# No, Install Docker (2)
# Exit (3)
# "
# read -p "==>" OP
# if [[ "$OP" == "1" ]]; then
#     echo "Ok, Continue"
# elif [[ "$OP" == "2" ]]; then
#     username=$(whoami)
#     echo "Debian (1)
# RedHat (2)
# Exit (3)"
#     read -p "==>" OP2
#     if [[ "$OP2" == "1" ]]; then
#     sudo apt update
#     sudo apt install docker.io docker-compose -y
#     sudo usermod -aG docker $username
#     echo "********************
# Please Enter <exit> Command
# ********************"
#     newgrp docker 
#     # elif
#     else
#     echo "Exit"
#     exit
#     fi
    
# else
#     echo "Exit"
#     exit

# fi
# }

DockerDownload() {

# Is There docker compose ? & What Is The Virson ?
if command -v docker-compose &> /dev/null; then
    DC="docker-compose"
elif docker compose version &> /dev/null; then
    DC="docker compose"
else
    echo "Docker Compose not installed!"
    return 1
fi


git clone https://github.com/zammad/zammad-docker-compose.git
cd zammad-docker-compose
echo "Zammad Port? (http=80 But Check If There Any Service Using This Port) :"
read -p "===>" Port
cp .env.dist .env
echo "NGINX_EXPOSE_PORT=$Port
NGINX_PORT=8080" | tee -a .env
$DC up -d
}
