#!/bin/bash
#
# setup.sh
# Installs Netdata on a fresh Linux system and opens the dashboard port
# if ufw is active.
#
# Usage: ./setup.sh

set -e  # exit immediately if any command fails

echo "==> Updating package lists..."
sudo apt update

echo "==> Downloading and running the official Netdata installer..."
wget --https-only -O /tmp/netdata-kickstart.sh https://get.netdata.cloud/kickstart.sh # NOSONAR -- --https-only rejects any non-HTTPS redirect
sh /tmp/netdata-kickstart.sh --non-interactive

echo "==> Checking Netdata service status..."
sudo systemctl enable --now netdata
sudo systemctl status netdata --no-pager

echo "==> Opening port 19999 in ufw (if active)..."
if sudo ufw status | grep -q "Status: active"; then
    sudo ufw allow 19999/tcp
    echo "Port 19999 opened in ufw."
else
    echo "ufw is not active, skipping local firewall rule."
    echo "Make sure port 19999 is open in your cloud provider's security group/firewall."
fi

echo "==> Done! Netdata should now be running."
echo "Visit http://<server-ip>:19999 in your browser to view the dashboard."
