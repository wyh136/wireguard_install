#!/bin/sh
sudo apt-get install wireguard
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p
mkdir -p /etc/wireguard && chmod 0777 /etc/wireguard
cd /etc/wireguard
umask 077
wg genkey | tee server_privatekey | wg pubkey > server_publickey
wg genkey | tee client_privatekey | wg pubkey > client_publickey
echo "
[Interface]
PrivateKey = $(cat server_privatekey) # 填写本机的privatekey 内容
Address = 10.0.8.1/24
PostUp   = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
ListenPort = 52930 # 注意该端口是UDP端口
DNS = 8.8.8.8
MTU = 1420
[Peer]
PublicKey =  $(cat client_publickey)  # 填写对端的publickey 内容
AllowedIPs = 10.0.8.10/24 " > wg0.conf
systemctl enable wg-quick@wg0
wg-quick up wg0
wg-quick save wg0
wg-quick down wg0
systemctl start wg-quick@wg0
systemctl status wg-quick@wg0

echo "
[Interface]
  PrivateKey = $(cat client_privatekey)  # 填写本机的privatekey 内容
  Address = 10.0.8.10/24
  DNS = 8.8.8.8
  MTU = 1420
[Peer]
  PublicKey = $(cat server_publickey)  # 填写对端的publickey 内容
  Endpoint = server公网的IP:50814
  AllowedIPs = 0.0.0.0/0, ::0/0
  PersistentKeepalive = 25 " > client.conf
