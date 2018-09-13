#!/bin/bash
sudo apt-get update -y
sudo sed -i '/127.0.1.1/d' /etc/hosts
sudo ufw allow 26257/tcp
sudo timedatectl set-ntp no
sudo apt-get install -y ntp
sudo service ntp stop
sudo cp -rf /vagrant/config/ntp.conf /etc/ntp.conf
sudo service ntp start

cd /tmp
wget -qO- https://binaries.cockroachdb.com/cockroach-v2.0.5.linux-amd64.tgz | tar  xvz
sudo cp -i cockroach-v2.0.5.linux-amd64/cockroach /usr/local/bin

sudo systemctl enable cockroachdb
sudo systemctl start cockroachdb
