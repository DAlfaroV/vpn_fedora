#!/bin/bash

VPN_DATA_DIR=~/openvpn-data
VPN_DOMAIN_OR_IP="ip"
VPN_CLIENT_NAME="client1"

mkdir -p $VPN_DATA_DIR

sudo chown -R $(whoami):$(whoami) $VPN_DATA_DIR

podman pull kylemanna/openvpn

podman run -v $VPN_DATA_DIR:/etc/openvpn:z --rm kylemanna/openvpn ovpn_genconfig -u udp://$VPN_DOMAIN_OR_IP

podman run -v $VPN_DATA_DIR:/etc/openvpn:z --rm -it kylemanna/openvpn ovpn_initpki

podman run -v $VPN_DATA_DIR:/etc/openvpn:z -d -p 1194:1194/udp --cap-add=NET_ADMIN kylemanna/openvpn

podman run -v $VPN_DATA_DIR:/etc/openvpn:z --rm -it kylemanna/openvpn easyrsa build-client-full $VPN_CLIENT_NAME nopass

podman run -v $VPN_DATA_DIR:/etc/openvpn:z --rm kylemanna/openvpn ovpn_getclient $VPN_CLIENT_NAME >$VPN_CLIENT_NAME.ovpn
