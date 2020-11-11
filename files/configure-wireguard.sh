#!/bin/bash

DIR=/etc/wireguard
INTERFACE=eth0 #default on AWS
PUBKEY=oKHum0XNJaFNe1ZtmSW5N9zjjAORoKGicl5JSGKbomc=

umask 077
cd $DIR
wg genkey | tee privatekey | wg pubkey > publickey

echo "[*] Created encryption keys in $DIR"

PRIVKEY=$(cat $DIR/privatekey)

cat << EOF > /etc/wireguard/wg0.conf
[Interface]
Address = 10.10.2.1
PrivateKey = $PRIVKEY
ListenPort = 51820
PostUp   = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o $INTERFACE -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o $INTERFACE -j MASQUERADE

[Peer]
PublicKey = $PUBKEY
AllowedIPs = 10.10.2.2/32
EOF

echo "[*] Created config file in $DIR"

sysctl -w net.ipv4.ip_forward=1
echo "net.ipv4.ip_forward=1" > /etc/sysctl.d/10-ip-forwarding.conf

echo "[*] Enabled IP routing"

systemctl enable wg-quick@wg0.service
systemctl start wg-quick@wg0.service

echo "[*] Started Wireguard service"
