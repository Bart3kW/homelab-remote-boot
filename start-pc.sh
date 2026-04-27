#!/bin/bash

# CONFIGURATION
ROUTER_USER="root" 
ROUTER_IP="100.100.100.100"        #IP address of router
TARGET_MAC="00:00:00:00:00:00" # MAC address of pc
TARGET_LAN_IP="192.168.1.10"   #Local IP of pc
REMMINA_PROFILE="/home/..." #remmina profile rdp
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}---++ [HOMELAB BOOT SEQUENCE] ++---${NC}"

# VPN tailscale check
if ! tailscale status | grep -q "active"; then
    echo "[-] Tailscale is down. Connecting..."
    tailscale up
fi

# etherwake 
echo -e "[*] Sending Magic Packet..."
ssh -o LogLevel=ERROR $ROUTER_USER@$ROUTER_IP "etherwake -i br-lan $TARGET_MAC"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}[+] Signal send successfully!${NC}"
else
    echo "[-] Error connecting to router"
    exit 1
fi
# waiting for pc to boot
echo "[*] Waiting for the pc to respond ..."
until nc -zv -w 1 $TARGET_LAN_IP 3389 > /dev/null 2>&1; do
    echo -n "."
    sleep 2
done

echo -e "\n${GREEN}[+] PC IS ONLINE!${NC}"

#launch remmina
echo "[*] Launching  Remmina"
remmina -c "$REMMINA_PROFILE" &
