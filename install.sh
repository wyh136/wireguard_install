#!/bin/sh
sudo apt update -y
sudo apt upgrade -y
sudo apt full-upgrade -y
sudo apt install apt-transport-https ca-certificates curl software-properties-common gnupg lsb-release -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update -y
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
mkdir /etc/trojan-go
mkdir /etc/caddy
mkdir /etc/wireguard
mkdir /root/.acme.sh
mkdir /root/dockerfiles
cd /root/dockerfiles
wget https://raw.githubusercontent.com/wyh136/wireguard_install/main/docker-compose.yml
docker compose up
