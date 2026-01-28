#! /bin/bash

git clone https://github.com/zammad/zammad-docker-compose.git
cd zammad-docker-compose
echo "Zammad Port? (http=80) :"
read -p "===>" Port
cp .env.dist .env
echo "NGINX_EXPOSE_PORT=$Port
NGINX_PORT=$Port" | tee -a .env
docker compose up -d
