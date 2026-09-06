# GitHub - Connect Repository Tutorial

## Overview
Tutorial for connecting local repositories to GitHub.

## Prerequisites

### Git Installation
```bash
sudo pacman -S git

# Configure git
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

### GitHub Account
- Create account at github.com
- Set up SSH key or use HTTPS

## Method 1: SSH Key (Recommended)

### Generate SSH Key
```bash
ssh-keygen -t ed25519 -C "your@email.com"

# Start ssh-agent
eval "$(ssh-agent -s)"

# Add key to agent
ssh-add ~/.ssh/id_ed25519
```

### Add Key to GitHub
1. Copy public key
```bash
cat ~/.ssh/id_ed25519.pub
```
2. Go to GitHub Settings > SSH Keys
3. Click "New SSH Key"
4. Paste the public key
5. Click "Add SSH Key"

### Test Connection
```bash
ssh -T git@github.com
```

## Method 2: HTTPS with Token

### Create Personal Access Token
1. Go to GitHub Settings
2. Developer settings > Personal access tokens
3. Generate new token
4. Select scopes (repo, workflow)
5. Copy token

### Use Token
```bash
git remote add origin https://github.com/username/repo.git

# Clone with token
git clone https://username:TOKEN@github.com/username/repo.git
```

## Connecting Existing Repository

### Initialize Local Repo
```bash
mkdir my-project
cd my-project
git init
git add .
git commit -m "Initial commit"
```

### Create Remote Repository
1. Go to GitHub
2. Click "New repository"
3. Name it (e.g., my-project)
4. Don't initialize with README

### Connect to GitHub
```bash
git remote add origin git@github.com:username/my-project.git

# Verify
git remote -v

# Push
git push -u origin main
```

## Common Commands

### Push Changes
```bash
git add .
git commit -m "Your message"
git push origin main
```

### Pull Changes
```bash
git pull origin main
```

### View Status
```bash
git status
git log
```

## Troubleshooting

### Permission Denied (SSH)
```bash
# Check SSH key
ssh-add -l

# Regenerate if needed
ssh-keygen -t ed25519 -C "your@email.com"
```

### Authentication Failed
```bash
# Update remote URL
git remote set-url origin git@github.com:username/repo.git
```

## Tags
#github #git #repository #tutorial
