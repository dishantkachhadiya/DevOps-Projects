# EC2 Instance

I launched a new EC2 instance on AWS, connected to it over SSH, installed Nginx, and deployed a simple static website to it.

Project URL: https://roadmap.sh/projects/ec2-instance

## What I used

- **AMI:** Ubuntu Server
- **Instance type:** t2.micro (AWS Free Tier)
- **VPC/Subnet:** default VPC and subnet for the region
- **Security group:** inbound rules for port 22 (SSH) and port 80 (HTTP)
- **Key pair:** new key pair created for this instance
- **Public IP:** auto-assigned

## Steps

### 1. Launch the EC2 instance

Launched through the EC2 console with:
- Ubuntu Server AMI
- `t2.micro` instance type
- Default VPC and subnet
- Security group allowing:
  - SSH (port 22) from anywhere
  - HTTP (port 80) from anywhere
- A newly created key pair
- Auto-assigned public IP enabled

### 2. Connect via SSH

```bash
ssh -i ~/.ssh/<key-name>.pem ubuntu@<instance-public-ip>
```

### 3. Update packages and install Nginx

```bash
sudo apt update
sudo apt install nginx -y
sudo systemctl enable --now nginx
```

### 4. Create a simple static website

Built a small single-file HTML site (`index.html`) with two sections (Home / About) toggled using the `:target` CSS selector and anchor links, so no JavaScript is needed for basic navigation.

### 5. Deploy the site

Copied the file directly into Nginx's default web root:

```bash
scp -i ~/.ssh/<key-name>.pem index.html ubuntu@<instance-public-ip>:/tmp/
ssh -i ~/.ssh/<key-name>.pem ubuntu@<instance-public-ip>
sudo mv /tmp/index.html /var/www/html/index.html
```

### 6. Access the website

```
http://<instance-public-ip>
```

Confirmed the site loads correctly, with the Home/About navigation working as expected.


## Notes

- No custom Nginx config file was needed this time, the site was placed directly in the default web root (`/var/www/html/`), which Nginx serves out of the box.
- Stretch goals (custom domain via Route 53, HTTPS via Let's Encrypt, CI/CD via CodePipeline) were not implemented in this pass, since Let's Encrypt requires a real domain name (it doesn't issue certificates for bare IP addresses).
- Remember to terminate the EC2 instance when done to avoid ongoing charges.
