# IaC on AWS (Terraform)

Terraform code that provisions an EC2 instance on AWS, a security group allowing SSH and HTTP, and an SSH key pair, all defined as code instead of being clicked through the console.

The original project asks for DigitalOcean; I built the AWS equivalent instead, using an `aws_instance` and `aws_security_group` in place of a `digitalocean_droplet`.

Project URL: https://roadmap.sh/projects/iac-digital-ocean

## What gets created

| Resource | Purpose |
|---|---|
| `aws_key_pair` | Registers a local SSH public key with AWS so it can be attached to the instance |
| `aws_security_group` | Allows inbound SSH (22) and HTTP (80), and all outbound traffic |
| `aws_instance` | A `t2.micro` EC2 instance using the key pair and security group above |

## Files

```
IaC-on-AWS/
├── main.tf                     # resources: key pair, security group, instance
├── variables.tf                # input variables
├── outputs.tf                  # the instance's public IP and ID
├── terraform.tfvars.example    # template for your own terraform.tfvars
└── .gitignore                  # keeps state files and secrets out of git
```

## Setup

### 1. Install Terraform

```bash
sudo apt update
sudo apt install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt install terraform -y
terraform -version
```

### 2. Create an AWS access key

IAM console → Users → your user → **Security credentials** → **Create access key**.

### 3. Find the current Ubuntu AMI for your region

AMI IDs are region-specific and change over time, so look up the current one rather than reusing an old ID:

```bash
aws ec2 describe-images \
  --owners 099720109477 \
  --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-noble-24.04-amd64-server-*" \
  --query 'Images | sort_by(@, &CreationDate)[-1].ImageId' \
  --region ap-south-1
```

### 4. Create your `terraform.tfvars`

```bash
cp terraform.tfvars.example terraform.tfvars
```

Fill in your real access key, secret key, region, and the AMI ID found above. This file is gitignored and never committed.

### 5. Initialize Terraform

```bash
terraform init
```

Downloads the AWS provider plugin.

## Running it

```bash
terraform plan      # shows what will be created, without creating anything
terraform apply      # creates the resources (type 'yes' to confirm)
```

## Connecting to the instance

```bash
terraform output instance_public_ip
ssh -i ~/.ssh/id_ed25519 ubuntu@<public-ip>
```

## Tearing it down

```bash
terraform destroy
```

Removes every resource this configuration created, so nothing keeps billing after you're done.

## Problems I ran into

<!-- Fill in anything you actually hit, e.g. a stale AMI ID, a region mismatch, a key path issue -->

## Stretch goal: configure with Ansible

Point the inventory from the [Configuration Management](../Configuration-Management/README.md) project at this instance's new public IP and run the same playbook against it:

```ini
[web]
<new-instance-ip> ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_ed25519
```

```bash
ansible-playbook -i inventory.ini setup.yml
```

## Notes

- `terraform.tfstate` tracks the real-world resources Terraform is managing. It can contain sensitive data and should never be committed; it's excluded via `.gitignore`.
- Running `terraform apply` again after a change only updates what's different, Terraform compares the desired state in the `.tf` files against the current state and applies the minimal diff.
- Always run `terraform destroy` when finished to avoid ongoing EC2 charges.
