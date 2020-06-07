#!/bin/bash

set -euf -o pipefail

sudo sed -i \
    's/APT::Periodic::Update-Package-Lists "1";/APT::Periodic::Update-Package-Lists "0";/' \
    /etc/apt/apt.conf.d/10periodic
sudo sed -i \
    's/APT::Periodic::Unattended-Upgrade "1";/APT::Periodic::Unattended-Upgrade "0";/' \
    /etc/apt/apt.conf.d/20auto-upgrades
sudo reboot



while sudo apt-get remove -y unattended-upgrades; [ $? != 0 ]
do sleep 2
done

sudo apt-get update && sudo apt-get upgrade -y
