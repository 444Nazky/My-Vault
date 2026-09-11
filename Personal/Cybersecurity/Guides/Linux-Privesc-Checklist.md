# Linux Privilege Escalation Checklist

Standalone note. No links in or out. Authorized testing only.

## Fast Enumeration

```bash
id; sudo -l; uname -a
cat /etc/os-release
ps aux | head -30
ss -tulpn
```

## Files and Perms

```bash
find / -perm -4000 -type f 2>/dev/null
find / -writable -type d 2>/dev/null | grep -v proc
ls -la /etc/cron* /var/spool/cron/
cat /etc/passwd | grep -v nologin
```

## Credentials Lying Around

```bash
grep -ri "password" /home /opt /srv 2>/dev/null | head
history | grep -i -E "pass|token|key" | head
env | grep -i -E "key|token|secret"
ls -la ~/.ssh/ ; cat ~/.bash_history
```

## Kernel and Services

```bash
uname -r
dpkg -l | grep -i kernel
systemctl list-units --type=service --state=running
```

## Usual Wins

- sudo misconfig: version, token, or NOPASSWD binary abuse.
- SUID binaries with known GTFOBins patterns.
- Writable cron scripts or PATH hijack in cron context.
- Docker group membership equals root equivalent.
- Kernel older than distro support window.

## Gotchas

- Enumerate before exploiting, noisy exploits burn the engagement.
- Check bothLinEnum style scripts output by hand, tools miss context.
- Clean up files and processes you created when done.

## Tags
#note-linux-privesc-checklist
