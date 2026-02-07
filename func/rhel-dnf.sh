#!/bin/bash

# RHEL\AlmaLinux 8
RHAL8Installer() {
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
    echo "Open Port 80"
    firewall-cmd --zone=public --add-service=http --permanent
    echo "Open Port 5432"
    firewall-cmd --zone=public --add-port=5432/tcp --permanent
    echo "Reload Firewall"
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
If You Want zammad Using Port 80 PleaseChange The Port From 80 To Any Port Else In (/etc/nginx/nginx.conf)
For Change Zammad Port (/etc/nginx/conf.d/zammad.conf)"""
}
# RHEL\AlmaLinux 9
RHAL9Installer() {
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
    echo "Open Port 80"
    firewall-cmd --zone=public --add-service=http --permanent
    echo "Open Port 5432"
    firewall-cmd --zone=public --add-port=5432/tcp --permanent
    echo "Reload Firewall"
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
}

PodmanRH() {
	echo "Agree With Install (git , podman) ?
Yes [1]
No & Exit [2]"

	read -p "==>" op2
	if [[ "$op2" == "1" ]]; then
    source ./func/podman-func.sh
	sudo dnf update 
    sudo dnf install epel-release podman -y
    sudo dnf install podman-compose git firewalld -y
    sudo systemctl enable --now firewalld
		echo "Zammad Port? (http=80 But Check If There Is Any Service Using This Port + Run The Script By Root Or It Will Forward The Port) :"
		read -p "===>" Port
		if [[ $Port -le 1024 ]]; then
			if [[ "$(id -u)" -eq 0 ]]; then
				echo "You Can Run Podman Under Port 1024 Because You Are Root"
				sysctl net.ipv4.ip_unprivileged_port_start=$Port

                echo "Open Port $Port"
                firewall-cmd --permanent --add-port=$Port/tcp
                echo "Reload Firewall"
                firewall-cmd --reload
                PodmanInstaller
                loginctl enable-linger $USER
                PSDroot
                echo "*** Finsh ***"
                exit
			else

            echo "Cannot Run Podman Under Port 1024 Because You Are Not Root
But You Can Forward Port
Yes (1)
No & Exit (2)"     
            fi

            read -p "==>" op3
            if [[ "$op3" == "1" ]]; then
            echo "Contaner Port is 7070 \ But Will Forward To Port $Port"
            sleep 3
            echo "Open Port 7070"
            sudo firewall-cmd --add-port=7070/tcp --permanent
            echo "Open Port $Port"
            sudo firewall-cmd --add-port=$Port/tcp --permanent
            echo "Foreard Port $Port To 7070"
            sudo firewall-cmd --add-forward-port=port=$Port:proto=tcp:toport=7070 --permanent
            echo "Reload Firewall"
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
}
