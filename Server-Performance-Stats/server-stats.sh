#!/bin/bash

echo "======================================"
echo "      Server Performance Stats"
echo "======================================"

echo 
echo "Generated on: $(date)"

echo
echo "CPU Usage:"
top -bn1 | grep "Cpu(s)"

echo
echo "Memory Usage:"
free -h

echo
echo "Disk Usage:"
df -h /

echo
echo "Top 5 Processes by CPU Usage:"
ps aux --sort=-%cpu | head -n 6

echo
echo "Top 5 Processes by Memory Usage:"
ps aux --sort=-%mem | head -n 6

echo
echo "System Uptime:"
uptime

echo
echo "OS Version:"
cat /etc/os-release
