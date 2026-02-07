#!/bin/bash



echo '''
Zammad Installer
By: @ALmohawis

Debian (1)
Ubuntu (2)
RHEL & ALmaLinux (3)
Docker (4)
Podman (5)

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

# elif [[ "$OP1" == "2" ]]; then
#   source ./func/elasticsearch-debian.sh
# source ./func/



# elif [[]]
# elif [[]]
# elif [[]]






else
  echo "Exit"
  exit
fi