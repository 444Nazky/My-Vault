---
title: Git SSH Workflow Troubleshooting
date: 2026-10-11
tags: [git, ssh, workflow, troubleshooting, push, remote, authentication]
status: completed
---

# Git SSH Workflow Troubleshooting

## Overview

This document details the resolution of HTTPS non-fast-forward push errors, remote URL overrides, and SSH key configurations encountered during the development workflow.

## Problem Statement

During development, the following Git workflow issues were encountered:

1. **Non-fast-forward Push Rejections**: Pushes rejected when remote had commits not present locally
2. **Remote URL Mismatch**: HTTPS vs SSH URL confusion causing authentication issues
3. **SSH Key Configuration**: Potential SSH key setup issues for secure Git operations

## Solutions

### Non-Fast-Forward Push Errors

#### Cause

The remote repository contained commits that were not in the local branch, typically because:
- Another developer pushed changes
- The remote was updated via pull request
- The local branch diverged from remote

#### Resolution

1. **Pull Before Push** (Recommended):
   ```bash
   git pull --rebase origin main
   # Resolve any conflicts
   git push origin main
   ```

2. **Force Push** (Use with caution - only when you control the remote):
   ```bash
   git push --force-with-lease origin main
   ```

3. **Check Remote Status**:
   ```bash
   git fetch origin
   git log HEAD..origin/main --oneline  # Commits in remote not in local
   git log origin/main..HEAD --oneline  # Commits in local not in remote
   ```

### Remote URL Override

#### HTTPS vs SSH

Git supports two URL formats for remote repositories:

**HTTPS Format**:
```
https://github.com/username/repository.git
```

**SSH Format**:
```
git@github.com:username/repository.git
```

#### Configuration

To switch remote URL to SSH:

```bash
# Check current remote URL
git remote -v

# Set SSH URL
git remote set-url origin git@github.com:username/repository.git

# Verify change
git remote -v
```

To switch back to HTTPS:

```bash
git remote set-url origin https://github.com/username/repository.git
```

### SSH Key Configuration

#### Prerequisites

Ensure SSH key exists:

```bash
# Check for existing keys
ls -la ~/.ssh/

# Generate new SSH key (if needed)
ssh-keygen -t ed25519 -C "your_email@example.com"

# Start SSH agent
eval "$(ssh-agent -s)"

# Add key to agent
ssh-add ~/.ssh/id_ed25519

# Test connection
ssh -T git@github.com
```

#### Verification

```bash
# Check remote uses SSH
git remote get-url origin

# Should show: git@github.com:username/repository.git

# Test authentication
ssh -T git@github.com
```

## Best Practices

1. **Always pull before push** to avoid non-fast-forward errors
2. **Use SSH for authentication** to avoid credential prompts
3. **Verify remote URL** before pushing, especially after cloning
4. **Use --force-with-lease** instead of --force when necessary (safer)
5. **Keep SSH keys secure** and rotate periodically

## Related Commands

```bash
# Inspect current branch and remote
git status
git branch -vv
git log --oneline -10

# Sync with remote
git fetch origin
git pull origin main

# Check what would be pushed
git diff --stat origin/main..HEAD
git log --oneline origin/main..HEAD

# Remote configuration
git remote -v
git remote get-url origin
git remote set-url origin <new-url>
```

## Troubleshooting Checklist

- [ ] SSH key exists in ~/.ssh/
- [ ] SSH agent is running
- [ ] Key is added to ssh-agent
- [ ] Remote URL uses SSH format
- [ ] SSH key is registered with GitHub
- [ ] Local branch is up to date with remote
- [ ] No uncommitted changes blocking pull

## Related Documentation

- `AUDIT_OVERHAUL_REPORT.md` in project root
- Git documentation: https://git-scm.com/doc
- GitHub SSH guide: https://docs.github.com/en/authentication/connecting-to-github-with-ssh
