#!/bin/bash


cat << "EOF"
____        __       ___      ___  ___      ___       __       ________                 
("      "\      /""\     |"  \    /"  ||"  \    /"  |     /""\     |"      "\                
 \___/   :)    /    \     \   \  //   | \   \  //   |    /    \    (.  ___  :)               
   /  ___/    /' /\  \    /\\  \/.    | /\\  \/.    |   /' /\  \   |: \   ) ||               
  //  \__    //  __'  \  |: \.        ||: \.        |  //  __'  \  (| (___\ ||               
 (:   / "\  /   /  \\  \ |.  \    /:  ||.  \    /:  | /   /  \\  \ |:       :)               
  \_______)(___/    \___)|___|\__/|___||___|\__/|___|(___/    \___)(________/                
                                                                                             
  __    _____  ___    ________  ___________   __      ___      ___       _______   _______   
 |" \  (\"   \|"  \  /"       )("     _   ") /""\    |"  |    |"  |     /"     "| /"      \  
 ||  | |.\\   \    |(:   \___/  )__/  \\__/ /    \   ||  |    ||  |    (: ______)|:        | 
 |:  | |: \.   \\  | \___  \       \\_ /   /' /\  \  |:  |    |:  |     \/    |  |_____/   ) 
 |.  | |.  \    \. |  __/  \\      |.  |  //  __'  \  \  |___  \  |___  // ___)_  //      /  
 /\  |\|    \    \ | /" \   :)     \:  | /   /  \\  \( \_|:  \( \_|:  \(:      "||:  __   \  
(__\_|_)\___|\____\)(_______/       \__|(___/    \___)\_______)\_______)\_______)|__|  \___) 

EOF
echo '''
By: @ALmohawis

Debian (1)
Ubuntu (2)
RHEL & ALmaLinux (3)
Podman (4)
Docker (5)
Exit (6)
'''

read -p "==>" OP1

# Debain
if [[ "$OP1" == "1" ]]; then
  source ./func/debian-apt.sh
  source ./func/elasticsearch-debian.sh

  echo """
Debian 11 (1)
Debian 12 (2)
Exit (3)
"""
  read -p "==>" OP2


########################## DEBIAN
  if [[ "$OP2" == "1" ]]; then
  InstallElasticsearch
  # For Edit ./func/debian-apt.sh
  Debian11Installer
  echo "Please Edit The Port In /etc/nginx/sites-enabled/
If You Want zammad Using Port 80 Edit /etc/nginx/sites-enabled/default
If You Want zammad Using Another Port Edit /etc/nginx/sites-enabled/zammad.conf"
  elif [[ "$OP2" == "2" ]]; then
  # For Edit ./func/elasticsearch-debian.sh
  InstallElasticsearch
  # For Edit ./func/debian-apt.sh
  Debian12Installer
  echo "Please Edit The Port In /etc/nginx/sites-enabled/
If You Want zammad Using Port 80 Edit /etc/nginx/sites-enabled/default
If You Want zammad Using Another Port Edit /etc/nginx/sites-enabled/zammad.conf"
  else
  echo "Exit"
  exit
  fi
########################## DEBIAN

elif [[ "$OP1" == "2" ]]; then
  source ./func/elasticsearch-debian.sh
  source ./func/ubuntu-apt.sh
  echo "

Ubuntu 20.04  [1]
Ubuntu 22.04  [2]
Ubuntu 24.04  [3]
Exit (4)
"
  read -p "==>" OP2
  if [[ "$OP2" == "1" ]]; then
    # For Edit ./func/elasticsearch-debian.sh
    InstallElasticsearch
    # For Edit ./func/ubuntu-apt.sh
    Ubuntu20Installer
  elif [[ "$OP2" == "2" ]]; then
    # For Edit ./func/elasticsearch-debian.sh
    InstallElasticsearch
    # For Edit ./func/ubuntu-apt.sh
    Ubuntu22Installer
    elif [[ "$OP2" == "3" ]]; then
    # For Edit ./func/elasticsearch-debian.sh
    InstallElasticsearch
    # For Edit ./func/ubuntu-apt.sh
    Ubuntu24Installer
  else
    echo "Exit"
    exit
  fi


elif [[ "$OP1" == "3" ]]; then
  echo "
  RHEL\CentOS\AlmaLinux 8 [1]
  RHEL\CentOS\AlmaLinux 9 [2]
  RHEL\CentOS\AlmaLinux 10 <With Podman> [3]
  "
  source ./func/elasticsearch-rhel.sh
  source ./func/rhel-dnf.sh

  read -p "==>" OP2
  
  if [[ "$OP2" == "1" ]]; then
    # For Edit ./func/elasticsearch-rhel.sh
    InstallElasticsearchRH
    # For Edit ./func/rhel-dnf.sh
    RHAL8Installer
  elif [[ "$OP2" == "2" ]]; then
    # For Edit ./func/elasticsearch-rhel.sh
    InstallElasticsearchRH
    # For Edit ./func/rhel-dnf.sh
    RHAL9Installer
  elif [[ "$OP2" == "3" ]]; then
    # For Edit ./func/rhel-dnf.sh
    PodmanRH

  else
    echo "Exit"
    exit
  fi
elif [[ "$OP1" == "4" ]]; then
  source ./func/rhel-dnf.sh
   # For Edit ./func/rhel-dnf.sh
   PodmanRH


elif [[ "$OP1" == "5" ]]; then
  #For Edit ./fucn/docker.sh
  source ./func/docker.sh
  # IsThereDocker
  DockerDownload






else
  echo "Exit"
  exit
fi