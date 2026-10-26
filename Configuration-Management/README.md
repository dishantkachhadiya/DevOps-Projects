# Configuration Management (Ansible)

An Ansible playbook that configures a Linux server end to end: base setup and hardening, installs and configures Nginx, deploys a static site, and adds an SSH public key, all organized into reusable, independently runnable roles.

Project URL: https://roadmap.sh/projects/configuration-management

## Structure

```
Configuration-Management/
├── setup.yml              # main playbook
├── inventory.ini          # server(s) to configure
└── roles/
    ├── base/
    │   └── tasks/main.yml     # updates, utilities, fail2ban
    ├── nginx/
    │   └── tasks/main.yml     # installs and starts nginx
    ├── app/
    │   ├── tasks/main.yml     # deploys the static site
    │   └── files/site.tar.gz  # the site being deployed
    └── ssh/
        ├── tasks/main.yml     # adds a public key
        └── files/deploy_key.pub
```

## What each role does

| Role | What it does |
|------|---------------|
| `base` | Updates apt cache, upgrades packages, installs common utilities (`curl`, `wget`, `vim`, `git`, `unzip`, `htop`), installs and enables `fail2ban` |
| `nginx` | Installs nginx, enables and starts the service, opens port 80 in `ufw` if it's active |
| `app` | Copies a tarball of a static site to the server, extracts it into `/var/www/html`, restarts nginx |
| `ssh` | Adds a given public key to the target user's `authorized_keys` |

Every task is tagged with its role name, so each role can be run on its own.

## Setup

### 1. Install Ansible (on your laptop, not the server)

```bash
sudo apt update
sudo apt install ansible -y
ansible --version
```

### 2. Set the target server in `inventory.ini`

```ini
[web]
<server-ip> ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/<your-key>.pem
```

Replace `<server-ip>` and `<your-key>.pem` with your actual server's IP and SSH private key path.

### 3. Add your own public key

Replace the placeholder content of `roles/ssh/files/deploy_key.pub` with a real public key, for example:

```bash
cat ~/.ssh/id_ed25519.pub > roles/ssh/files/deploy_key.pub
```

### 4. (Optional) Replace the site being deployed

The `app` role deploys whatever is packaged in `roles/app/files/site.tar.gz`. A simple two-file site (`index.html` + `style.css`) is included by default. To use your own site:

```bash
cd your-site-folder
tar -czf site.tar.gz *
cp site.tar.gz /path/to/Configuration-Management/roles/app/files/site.tar.gz
```

### 5. Test connectivity

```bash
ansible -i inventory.ini web -m ping
```

A successful response looks like:
```
<server-ip> | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

## Running the playbook

Run every role, in order:

```bash
ansible-playbook -i inventory.ini setup.yml
```

Run only a specific role, using its tag:

```bash
ansible-playbook -i inventory.ini setup.yml --tags "base"
ansible-playbook -i inventory.ini setup.yml --tags "nginx"
ansible-playbook -i inventory.ini setup.yml --tags "app"
ansible-playbook -i inventory.ini setup.yml --tags "ssh"
```

## Verifying the result

After running the playbook:

```bash
# Confirm the site is live
curl http://<server-ip>

# Confirm fail2ban is running
ssh -i ~/.ssh/<your-key>.pem ubuntu@<server-ip> "sudo systemctl status fail2ban"

# Confirm the new SSH key works
ssh -i ~/.ssh/<new-key> ubuntu@<server-ip>
```

## Stretch goal: deploy from GitHub instead of a tarball

To pull the site from a GitHub repo instead of uploading a tarball, the `app` role's tasks can be swapped for something like:

```yaml
- name: Clone or update the site repository
  git:
    repo: "https://github.com/<username>/<repo>.git"
    dest: /var/www/html
    version: main
    force: yes
  tags: app
```

This replaces the `copy` + `unarchive` tasks with a single `git` module task that clones the repo on first run and pulls updates on subsequent runs.

## Notes

- `become: yes` in `setup.yml` runs all tasks with `sudo`, since installing packages and writing to `/var/www/html` requires root privileges.
- Re-running the playbook is safe: Ansible's modules (`apt`, `systemd`, `copy`, `unarchive`, `authorized_key`) are idempotent, so running `setup.yml` multiple times won't cause duplicate installs or errors.
