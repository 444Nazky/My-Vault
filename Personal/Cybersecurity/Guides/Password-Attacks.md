# Password Attacks Notes

Standalone note. No links in or out. Authorized testing only.

## Identify First

```bash
hashid '$6$salt$hash'
hash-identifier
```

Wrong mode wastes GPU hours. Confirm hash type before cracking.

## Hashcat Core Modes

```bash
hashcat -m 0 -a 0 hashes.txt rockyou.txt
hashcat -m 1000 -a 0 ntlm.txt rockyou.txt -r rules/best64.rule
hashcat -m 1800 -a 0 sha512crypt.txt rockyou.txt
hashcat -m 22000 -a 0 wifi.hc22000 rockyou.txt
```

- `-a 0` wordlist, `-a 3` mask brute force, `-a 6` wordlist plus mask.
- `--status --status-timer=10` to watch progress.

## Mask Attacks

```bash
hashcat -m 0 -a 3 '?u?l?l?l?l?d?d?s'
```

- `?l ?u ?d ?s ?a` for lower upper digit special all.
- Start narrow from password policy, widen only if needed.

## Rules and Mutations

- best64, d3ad0ne, OneRuleToRuleThemAll for leetspeak and appends.
- Write org-specific rules from recon words: company, product, city, years.

## Online Attacks

```bash
hydra -l admin -P rockyou.txt ssh://target
hydra -L users.txt -P rockyou.txt -t 4 ssh://target
```

- Throttle threads, watch lockout policy, prefer single valid pair then spray passwords, not users.

## Gotchas

- Never crack outside scope, hashes count as sensitive data.
- Dedupe and sort hash files before loading GPU work.
- Save potfile per engagement, never reuse across clients.

## Tags
#note-password-attacks
