# Active Directory Basics

Standalone note. No links in or out. Authorized testing only.

## Enum First

```bash
nxc smb 192.168.1.0/24 -u guest -p '' --shares
nxc ldap 192.168.1.10 -u user -p 'pass' --users
bloodhound-python -u user -p 'pass' -d corp.local -ns 192.168.1.10
```

- Shares, users, password policy, and delegation before any attack.
- BloodHound map shows shortest path to Domain Admins.

## Common Attacks

- Kerberoasting: request service tickets, crack offline with hashcat mode 13100.
- AS-REP roasting: users without pre-auth, hashcat mode 18200.
- Password spray one password across many users, never many passwords on one user.
- Pass-the-hash with nxc using NT hash directly, no cracking needed.
- PetitPotam plus ADCS misconfig equals fast domain compromise when present.

## Post Compromise

- Dump NTDS only in scope, secretsdump via DCSync needs replication rights.
- Golden ticket needs krbtgt hash, silver needs service hash.
- Document every account touched for the report.

## Gotchas

- Spray slowly, lockout policy ends engagements early.
- Time skew breaks Kerberos, sync with NTP first.
- Lab it first: Ghost SPNs and ESC vectors vary by patch level.

Tags: #activedirectory #pentesting #windows
