#!/bin/bash

echo """
---------------------------
|   Open Port ?           |
|   yes/y                 |
|   no/n                  |
---------------------------
"""

read -p "==>" OpenPort

if [[ "$OpenPort" == "yes" || "$OpenPort" == "YES" || "$OpenPort" == "y" || "$OpenPort" == "Y" ]]; then
    echo "Ok"
elif [[ "$OpenPort" == "no" || "$OpenPort" == "n" || "$OpenPort" == "NO" || $OpenPort == "N" ]]; then
    echo "No | Exit"
    exit
else
    echo "Rong Input"
fi
