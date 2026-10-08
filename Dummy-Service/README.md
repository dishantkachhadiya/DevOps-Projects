# Dummy Systemd Service

I created a simple long-running background script and wrapped it in a systemd service, so it starts automatically on boot, logs its activity, and restarts itself if it ever crashes.

Project URL: https://roadmap.sh/projects/dummy-systemd-service

## What I used

- **Provider:** AWS EC2
- **OS:** Ubuntu
- **Script location:** `/usr/local/bin/dummy.sh`
- **Service file location:** `/etc/systemd/system/dummy.service`
- **Log file:** `/var/log/dummy-service.log`

## Files

### `dummy.sh`

A script that runs forever, writing a log line every 10 seconds to simulate a background application.

```bash
#!/bin/bash
while true; do
  echo "Dummy service is running..." >> /var/log/dummy-service.log
  sleep 10
done
```

### `dummy.service`

The systemd unit file that manages the script as a service.

```ini
[Unit]
Description=Dummy logging service
After=network.target

[Service]
ExecStart=/usr/local/bin/dummy.sh
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

- `Restart=always` — restarts the service automatically if it ever stops or crashes
- `RestartSec=5` — waits 5 seconds before restarting
- `WantedBy=multi-user.target` — makes the service startable at boot once enabled

## Steps

### 1. Create the script

```bash
sudo nano /usr/local/bin/dummy.sh
sudo chmod +x /usr/local/bin/dummy.sh
```

### 2. Create the systemd service file

```bash
sudo nano /etc/systemd/system/dummy.service
```

### 3. Reload systemd and start the service

```bash
sudo systemctl daemon-reload
sudo systemctl start dummy
sudo systemctl status dummy
```

### 4. Verify logging

```bash
tail -f /var/log/dummy-service.log
sudo journalctl -u dummy -f
```

Both showed a new "Dummy service is running..." line every 10 seconds.

### 5. Test all required commands

```bash
sudo systemctl start dummy
sudo systemctl stop dummy
sudo systemctl enable dummy
sudo systemctl disable dummy
sudo systemctl status dummy
sudo journalctl -u dummy -f
```

All worked as expected.

### 6. Test auto-restart on crash

Started the service, found its process ID, and killed it manually to simulate a crash:

```bash
sudo systemctl start dummy
ps aux | grep dummy.sh
sudo kill -9 <pid>
sudo systemctl status dummy
```

systemd detected the process had died and automatically restarted it, confirmed by a new PID in the `status` output.

### 7. Test that it survives a reboot

```bash
sudo systemctl enable dummy
sudo reboot
```

After reconnecting:

```bash
sudo systemctl status dummy
```

The service was running automatically without needing to start it manually.


