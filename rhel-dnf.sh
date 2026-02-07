#!/bin/bash

echo """

RHEL\CentOS\AlmaLinux 8 [1]
RHEL\CentOS\AlmaLinux 9 [2]
RHEL\CentOS\AlmaLinux 10 <Using podman> [3]

"""


read -p "==>" op1

# RHEL\AlmaLinux 8
if [[ "$op1" == "1" ]]; then
dnf install wget epel-release -y
    rpm --import https://dl.packager.io/srv/zammad/zammad/key
    wget -O /etc/yum.repos.d/zammad.repo \
    https://dl.packager.io/srv/zammad/zammad/stable/installer/el/8.repo
    dnf install -y postgresql-server postgresql-contrib
    postgresql-setup --initdb
    systemctl enable --now postgresql
    mkdir -p /var/run/postgresql
    chown postgres:postgres /var/run/postgresql
    chmod 775 /var/run/postgresql
    dnf install zammad -y
    chmod -R 755 /opt/zammad/public/
    systemctl start postgresql 
    cp /opt/zammad/contrib/nginx/zammad.conf /etc/nginx/conf.d/zammad.conf
    usermod -a -G zammad nginx
    systemctl restart nginx.service
    # SELinux
    chcon -Rv --type=httpd_sys_content_t /opt/zammad/public/
    setsebool httpd_can_network_connect on -P
    semanage fcontext -a -t httpd_sys_content_t /opt/zammad/public/
    restorecon -Rv /opt/zammad/public/
    chmod -R a+r /opt/zammad/public/
    # Firewall
    firewall-cmd --zone=public --add-service=http --permanent
    firewall-cmd --zone=public --add-port=5432/tcp --permanent
    firewall-cmd --reload
    # 
   zammad run rails r "Setting.set('es_url', 'http://localhost:9200')"
   echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
   curl http://localhost:9200
   echo "If The Output is \"Failed to connect\" Please Run \" systemctl status elasticsearch.service \" \"sudo systemctl start elasticsearch.service \""
   echo "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
   systemctl status postgresql
   echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
   echo "If postgresql Is Active , Continue"
   systemctl status nginx
   echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
   echo "If nginx Is Active , Continue"
   systemctl status zammad
   echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
   echo "If zammad Is Active , Install Done"
   echo """@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
Please Edit /etc/nginx/ Files 
(/etc/nginx/nginx.conf) Change The Port
For Change Zammad Port (/etc/nginx/conf.d/zammad.conf"""

# RHEL\AlmaLinux 9
elif [[ "$op1" == "2" ]]; then
    dnf install wget epel-release -y
    rpm --import https://dl.packager.io/srv/zammad/zammad/key
    wget -O /etc/yum.repos.d/zammad.repo \
    https://dl.packager.io/srv/zammad/zammad/stable/installer/el/9.repo
    dnf install -y postgresql-server postgresql-contrib
    postgresql-setup --initdb
    systemctl enable --now postgresql
    mkdir -p /var/run/postgresql
    chown postgres:postgres /var/run/postgresql
    chmod 775 /var/run/postgresql
    dnf install zammad -y
    chmod -R 755 /opt/zammad/public/
    systemctl start postgresql 
    cp /opt/zammad/contrib/nginx/zammad.conf /etc/nginx/conf.d/zammad.conf
    usermod -a -G zammad nginx
    systemctl restart nginx.service
    # SELinux
    chcon -Rv --type=httpd_sys_content_t /opt/zammad/public/
    setsebool httpd_can_network_connect on -P
    semanage fcontext -a -t httpd_sys_content_t /opt/zammad/public/
    restorecon -Rv /opt/zammad/public/
    chmod -R a+r /opt/zammad/public/
    # Firewall
    firewall-cmd --zone=public --add-service=http --permanent
    firewall-cmd --zone=public --add-port=5432/tcp --permanent
    firewall-cmd --reload
    # 
   zammad run rails r "Setting.set('es_url', 'http://localhost:9200')"
   echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
   curl http://localhost:9200
   echo "If The Output is \"Failed to connect\" Please Run \" systemctl status elasticsearch.service \" \"sudo systemctl start elasticsearch.service \""
   echo "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
   systemctl status postgresql
   echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
   echo "If postgresql Is Active , Continue"
   systemctl status nginx
   echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
   echo "If nginx Is Active , Continue"
   systemctl status zammad
   echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
   echo "If zammad Is Active , Install Done"
   echo """@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
Please Edit /etc/nginx/ Files 
(/etc/nginx/nginx.conf) Change The Port
For Change Zammad Port (/etc/nginx/conf.d/zammad.conf"""



















elif [[ "$op1" == "3" ]]; then
	echo "Agre With Install (git , podman) ?
Yes [1]
No & Exit [2]"

	read -p "==>" op2
	if [[ "$op2" == "1" ]]; then
    source ./podman-func.sh
	sudo dnf update 
    sudo dnf install epel-release podman -y
    sudo dnf install podman-compose git -y
		echo "Zammad Port? (http=80 But Check If There Any Service Using This Port + Run The Script By Root) :"
		read -p "===>" Port
		if [[ $Port -le 1024 ]]; then
			if [[ "$(id -u)" -eq 0 ]]; then
				echo "You Can Run Podman Ander Port 1024 Becose You Are Root"
				sysctl net.ipv4.ip_unprivileged_port_start=$Port
                firewall-cmd --permanent --add-port=$Port/tcp
                firewall-cmd --reload
                PodmanInstaller
                loginctl enable-linger $USER
                PSDroot
                echo "*** Finsh ***"
                exit
			else

            echo "Cannot Run Podman Ander Port 1024 Becose You Are Not Root
But You Can Forward Port
Yes (1)
No & Exit (2)"     
            fi

            read -p "==>" op3
            if [[ "$op3" == "1" ]]; then
            echo "Contaner Port is 7070 \ But Will Forward To Port $Port"
            sleep 3
            sudo firewall-cmd --add-port=7070/tcp --permanent
            sudo firewall-cmd --add-port=$Port/tcp --permanent
            sudo firewall-cmd --add-forward-port=port=$Port:proto=tcp:toport=7070 --permanent
            sudo firewall-cmd --reload
            PodmanInstallerNonRoot
            loginctl enable-linger $USER
	    PSD
	   		
            else
                echo "exit"
                exit
            fi

		fi

	
	else
		echo "Cannot Install zammad Without (git, podman)"
		exit	
	fi
fi
