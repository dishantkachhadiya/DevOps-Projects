# Static Site Server

I set up a Linux server on AWS (EC2), installed Nginx to serve a static site, and used `rsync` to deploy the site from my laptop.

Project URL: https://roadmap.sh/projects/static-site-server

## What I used

- **Provider:** AWS EC2
- **OS:** Ubuntu 26.04 LTS
- **Web server:** Nginx
- **Deployment:** rsync over SSH

## Steps

### 1. Confirm SSH access

Reused the same EC2 instance and SSH key setup from the [SSH Remote Server Setup](../SSH-Remote-Server-Setup/README.md) project.

```bash
ssh -i ~/.ssh/static-server.pem ubuntu@<server-ip>
```

### 2. Install and configure Nginx

```bash
sudo apt update
sudo apt install nginx -y
sudo systemctl enable --now nginx
```

Opened port **80 (HTTP)** in the EC2 security group, the same way port 22 was opened for SSH.

### 3. Build a static site locally

```
static-site/
├── index.html
├── style.css
└── images/
    └── photo.jpg
```

A simple one-page site with basic HTML, a linked stylesheet, and an image.

### 4. Point Nginx at the site

Created a folder on the server for the site files:

```bash
sudo mkdir -p /var/www/static-site
sudo chown -R ubuntu:ubuntu /var/www/static-site
```

Created an Nginx config at `/etc/nginx/sites-available/static-site`:

```nginx
server {
    listen 80;
    server_name <server-ip>;

    root /var/www/static-site;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

Enabled it and removed the default site:

```bash
sudo ln -s /etc/nginx/sites-available/static-site /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl reload nginx
```

### 5. Deploy with rsync

```bash
rsync -avz -e "ssh -i ~/.ssh/static-server.pem" ./ ubuntu@<server-ip>:/var/www/static-site/
```

- `-a` preserves file attributes
- `-v` verbose output
- `-z` compresses during transfer
- `-e` sets the SSH command/key to use

### 6. `deploy.sh` script

```bash
#!/bin/bash
rsync -avz -e "ssh -i ~/.ssh/static-server.pem" ./ ubuntu@<server-ip>:/var/www/static-site/
```

```bash
chmod +x deploy.sh
./deploy.sh
```

Running `./deploy.sh` re-syncs the site any time it's updated locally.

### 7. Result

Visited `http://<server-ip>` in the browser and confirmed the custom site loads instead of the default Nginx welcome page.

## Notes

- No domain name used; the site is served from the server's public IP as allowed by the project requirements.
