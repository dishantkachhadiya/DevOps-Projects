#!/bin/bash
#
# cleanup.sh
# Removes Netdata and its leftover files from the system.
#
# Usage: ./cleanup.sh

set -e

echo "==> Stopping Netdata service..."
sudo systemctl stop netdata || true

echo "==> Running the official Netdata uninstaller..."
if [ -f /usr/libexec/netdata/netdata-uninstaller.sh ]; then
    sudo /usr/libexec/netdata/netdata-uninstaller.sh --yes --force
else
    echo "Official uninstaller not found at the expected path."
    echo "Checking common alternate location..."
    if [ -f /opt/netdata/usr/libexec/netdata/netdata-uninstaller.sh ]; then
        sudo /opt/netdata/usr/libexec/netdata/netdata-uninstaller.sh --yes --force
    else
        echo "Could not find the uninstaller automatically."
        echo "See https://learn.netdata.cloud/docs/netdata-agent/installation/uninstall for manual steps."
    fi
fi

echo "==> Removing leftover config and data directories (if any remain)..."
sudo rm -rf /etc/netdata
sudo rm -rf /var/lib/netdata
sudo rm -rf /var/cache/netdata
sudo rm -rf /var/log/netdata
sudo rm -rf /opt/netdata

echo "==> Closing port 19999 in ufw (if active)..."
if sudo ufw status | grep -q "Status: active"; then
    sudo ufw delete allow 19999/tcp || true
fi

echo "==> Netdata has been removed from the system."
