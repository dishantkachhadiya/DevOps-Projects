# SSH Remote Server Setup

I set up a Linux server on AWS (EC2) and configured SSH access using two different SSH key pairs.

Project Page URL

https://roadmap.sh/projects/

## What I used

- **Provider:** AWS EC2
- **OS:** Ubuntu 26.04 LTS
- **Default user:** `ubuntu`

## Steps

### 1. Generate two SSH key pairs (on my laptop)

```bash
ssh-keygen -t ed25519 -f ~/.ssh/server-key1 -C "key1"
ssh-keygen -t ed25519 -f ~/.ssh/server-key2 -C "key2"
```

- `-t ed25519` is the key type (modern, short and secure)
- `-f` sets the file name
- `-C` adds a label

Each command creates a private key (stays on my laptop) and a `.pub` public key (goes on the server).

### 2. Launch the EC2 instance

1. In the EC2 console, imported `server-key1.pub` under **Key Pairs**.
2. Launched an Ubuntu instance and selected `server-key1` as its key pair.
3. Allowed **SSH (port 22)** in the security group.
4. Copied the instance's public IP.

### 3. Connect with key 1

```bash
ssh -i ~/.ssh/server-key1 ubuntu@<server-ip>
```

### 4. Add key 2 to the server

AWS only installs the key chosen at launch, so I added the second one manually from my laptop:

```bash
cat ~/.ssh/server-key2.pub | ssh -i ~/.ssh/server-key1 ubuntu@<server-ip> "cat >> ~/.ssh/authorized_keys"
```

`>>` appends to the file, so key 1 stays valid. Each line in `authorized_keys` is one allowed public key.

### 5. Test both keys

```bash
ssh -i ~/.ssh/server-key1 ubuntu@<server-ip>
ssh -i ~/.ssh/server-key2 ubuntu@<server-ip>
```

Both log in without a password.

### 6. Set up SSH aliases

Added this to `~/.ssh/config` on my laptop:

```
Host aws-key1
    HostName <server-ip>
    User ubuntu
    IdentityFile ~/.ssh/server-key1
    IdentitiesOnly yes

Host aws-key2
    HostName <server-ip>
    User ubuntu
    IdentityFile ~/.ssh/server-key2
    IdentitiesOnly yes
```

Now I can connect with:

```bash
ssh aws-key1
ssh aws-key2
```

## Problems I ran into

| Problem | Cause | Fix |
|---------|-------|-----|
| `Identity file not accessible` | The private key file didn't exist on my laptop | Generated a new key pair and added its public key to the server |
| `Permission denied (publickey)` | The server had no public key matching the private key I used | Added the correct `.pub` key to `authorized_keys` |
| `no such identity` | I ran the commands on the server instead of my laptop | Ran them on my laptop, where the private keys are
