#!/bin/bash
#
# dummy.sh
# Simulates a long-running background application by logging a message
# every 10 seconds, forever.

while true; do
  echo "Dummy service is running..." >> /var/log/dummy-service.log
  sleep 10
done
