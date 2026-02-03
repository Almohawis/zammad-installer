#!/bin/bash

echo """

RHEL\CentOS\AlmaLinux 8 [1]
RHEL\CentOS\AlmaLinux 9 [2]
RHEL\CentOS\AlmaLinux 10 <Using podman> [3]

"""


read -p "==>" op

if [[ "$op" == "1" ]]; then
    dnf install wget epel-release -y
    rpm --import https://dl.packager.io/srv/zammad/zammad/key
    wget -O /etc/yum.repos.d/zammad.repo \
    https://dl.packager.io/srv/zammad/zammad/stable/installer/el/8.repo
    dnf install zammad -y
    chmod -R 755 /opt/zammad/public/
    # SELinux
    chcon -Rv --type=httpd_sys_content_t /opt/zammad/public/
    setsebool httpd_can_network_connect on -P
    semanage fcontext -a -t httpd_sys_content_t /opt/zammad/public/
    restorecon -Rv /opt/zammad/public/
    chmod -R a+r /opt/zammad/public/
    # Firewall
    firewall-cmd --zone=public --add-service=http --permanent
    firewall-cmd --reload
    # 
   zammad run rails r "Setting.set('es_url', 'http://localhost:9200')"
   curl http://localhost:9200
   echo "If The Output is \"Failed to connect\" Please Run \" systemctl status elasticsearch.service \" \"sudo systemctl start elasticsearch.service \""
   echo "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
   systemctl status postgresql
   echo "If postgresql Is Active , Continue"
   systemctl status zammad
   echo "If zammad Is Active , Install Done"

elif [[ "$op" == "2" ]]; then
    dnf install wget epel-release -y
    rpm --import https://dl.packager.io/srv/zammad/zammad/key
    wget -O /etc/yum.repos.d/zammad.repo \
    https://dl.packager.io/srv/zammad/zammad/stable/installer/el/9.repo
    sudo mkdir -p /var/run/postgresql
    sudo chown postgres:postgres /var/run/postgresql
    sudo chmod 775 /var/run/postgresql
    dnf install zammad -y
    chmod -R 755 /opt/zammad/public/
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
   curl http://localhost:9200
   echo "If The Output is \"Failed to connect\" Please Run \" systemctl status elasticsearch.service \" \"sudo systemctl start elasticsearch.service \""
   echo "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
   systemctl status postgresql
   echo "If postgresql Is Active , Continue"
   systemctl status zammad
   echo "If zammad Is Active , Install Done"
fi