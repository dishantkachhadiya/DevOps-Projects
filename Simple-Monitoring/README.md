# Simple Monitoring

I set up a basic monitoring dashboard on my Linux server using Netdata, customized it, configured an alert, and wrote shell scripts to automate the setup, testing, and cleanup.

Project URL: https://roadmap.sh/projects/simple-monitoring

## What I used

- **Provider:** AWS EC2
- **OS:** Ubuntu 26.04 LTS
- **Monitoring tool:** Netdata

## Steps

### 1. Install Netdata

Used the official Netdata installer (kickstart script):

```bash
wget -O /tmp/netdata-kickstart.sh https://get.netdata.cloud/kickstart.sh
sh /tmp/netdata-kickstart.sh --non-interactive
```

This installs Netdata as a background service and starts it automatically.

```bash
sudo systemctl enable --now netdata
```

### 2. Open the dashboard port

Netdata's dashboard runs on **port 19999** by default. Opened this port in the EC2 security group, the same way ports 22 and 80 were opened in earlier projects.

### 3. Access the dashboard

```
http://<server-ip>:19999
```

Netdata auto-detects system metrics out of the box, CPU, memory, disk I/O, and network were all visible immediately without extra configuration.

### 4. Set up an alert

Edited Netdata's CPU alert configuration:

```bash
sudo /etc/netdata/edit-config health.d/cpu.conf
```

Set a warning threshold so the alert fires when CPU usage goes above 80%:

```
warn: $this > 80
crit: $this > 90
```

Restarted Netdata to apply the change:

```bash
sudo systemctl restart netdata
```

### 5. Automation scripts

| Script | Purpose |
|--------|---------|
| `setup.sh` | Installs Netdata and opens port 19999 (via `ufw`, if active) |
| `test_dashboard.sh` | Generates temporary CPU load (using `stress`, or a fallback loop if `stress` isn't installed) and checks that the dashboard responds |
| `cleanup.sh` | Stops Netdata, runs the official uninstaller, and removes leftover config/data directories |

Made them executable and ran them from the server:

```bash
chmod +x setup.sh test_dashboard.sh cleanup.sh
./setup.sh
./test_dashboard.sh
```

Watched the CPU chart spike on the dashboard in real time while `test_dashboard.sh` was running, and confirmed the alert triggered in Netdata's **Alerts** tab.

## Notes

- Netdata runs as a `systemd` service, so it keeps running after closing the SSH session, same as Nginx did in the previous project.
- `cleanup.sh` fully removes Netdata if the server is being repurposed or the project needs to be re-tested from scratch.
