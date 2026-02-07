#!/bin/bash

PodmanInstaller() {
dnf install git podman -y
git clone https://github.com/zammad/zammad-docker-compose.git
cd zammad-docker-compose
cp .env.dist .env
echo "NGINX_EXPOSE_PORT=$Port
NGINX_PORT=8080" | tee -a .env
echo "
***********
* Please Select ( docker.io ) Or If You Using RHEL Slecet ( registry.access.redhat.com ) Or ( registry.redhat.io )
***********
"
podman compose up -d

}

PodmanInstallerNonRoot() {
sudo dnf install git podman -y
git clone https://github.com/zammad/zammad-docker-compose.git
cd zammad-docker-compose
cp .env.dist .env
echo "NGINX_EXPOSE_PORT=7070
NGINX_PORT=8080" | tee -a .env
echo "
***********
* Please Select ( docker.io ) Or If You Using RHEL Slecet ( registry.access.redhat.com ) Or ( registry.redhat.io )
***********
"
podman compose up -d

}
# Podman Systemd
PSD() {
mkdir -p ~/.config/systemd/user/
                DIR=$(pwd)
                echo """ 
                [Unit]
                Description=Podman Compose Service
                After=network-online.target

                [Service]
                Type=simple
                WorkingDirectory=$DIR
                ExecStart=/usr/bin/podman-compose up
                ExecStop=/usr/bin/podman-compose down
                Restart=always
		TimeoutStopSec=60
                [Install]
                WantedBy=default.target""" | tee ~/.config/systemd/user/zammad.service
                systemctl --user daemon-reload
                systemctl --user enable --now zammad.service
				echo "Please Wait , Zammad Service Is Loaded"
		while [ "$(systemctl is-active --user zammad.service)" != "active" ]; do
		  sleep 5 
		done
		# For Start The Contaners
		sleep 60
		systemctl --user status zammad.service
		echo "If Zammad Is Active , Done"
}


PSDroot() {
mkdir -p ~/.config/systemd/user/
                DIR=$(pwd)
                echo """ 
                [Unit]
                Description=Podman Compose Service
                After=network-online.target

                [Service]
                Type=simple
                WorkingDirectory=$DIR
                ExecStart=/usr/bin/podman-compose up
                ExecStop=/usr/bin/podman-compose down
                Restart=always
		TimeoutStopSec=60
                [Install]
                WantedBy=multi-user.target""" | tee /etc/systemd/system/zammad.service
                systemctl daemon-reload
                systemctl enable --now zammad.service
				echo "Please Wate , Zammad Service Is Loaded"
		while [ "$(systemctl is-active zammad.service)" != "active" ]; do
		  sleep 5 
		done
		# For Start The Contaners
		sleep 60
		systemctl status zammad.service
		echo "If Zammad Is Active , Done"
}
