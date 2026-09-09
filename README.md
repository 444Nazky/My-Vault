# Obsidian Vault Index

**Location:** `~/Documents/Obsidian Vault/`
**Last Updated:** 2026-09-09

---

## Folder Structure

```
Obsidian Vault/
├── AGENTS/                    # AI CLI agents documentation
├── Development/               # Development projects & guides
│   ├── Database/
│   ├── Github/
│   ├── Prompts/
│   └── VSCode Theme Bug/
├── Personal/                  # Personal notes & logs
│   ├── Cybersecurity/
│   ├── Device/
│   ├── School/
│   ├── Session-Logs/
│   └── Spreadsheets-Auth/
├── System/                    # System configurations & fixes
│   ├── Caelestia/          # Caelestia Hyprland config
│   ├── Caelestia-Investigation/
│   ├── Display-Server/
│   ├── Fixes/               # System fixes
│   ├── Gaming/
│   ├── Linux/
│   ├── Starship Installation.md
│   ├── Shell Startup Order.md
│   ├── System-Architecture.md
│   ├── Troubleshooting Steps.md
│   ├── Caelestia Dotfiles Context.md
│   ├── KDE-Plasma-Ricing.md
│   ├── hakuspace-niri-setup-2026-09-07.md
│   └── terminal-config-backup-2026-09-09.md
├── Tasks/                     # Project tasks
├── PROMPTS.md
├── README.md
└── Map of Content.md
```

---

## Quick Access

| Category | Path |
|----------|------|
| AI Agents | [[AGENTS/AI-CLI-Agents]] |
| System Fixes | [[System/Fixes/README]] |
| NVIDIA Fix | [[System/Fixes/NVIDIA-RTX-5050-Investigation]] |
| GRUB Fix | [[System/Fixes/GRUB-Configuration]] |
| Caelestia Shell Issue | [[System/Fixes/caelestia-shell-Removal-Issues]] |
| Caelestia Config | [[System/Caelestia/00-Overview]] |
| System Architecture | [[System/System-Architecture]] |
| Terminal Setup | [[System/terminal-config-backup-2026-09-09]] |
| Visual Guides | [[System/Fixes/Visual-Guides]] |
| Quick Reference | [[System/Fixes/Quick-Reference]] |

---

## Status: All Fixes Complete

### NVIDIA RTX 5050 - FIXED
- DKMS rebuilt
- Driver loaded
- Wayland environment configured
- env.lua updated with NVIDIA variables

### GRUB Configuration - FIXED
- Duplicate Arch entries removed (disabled 10_linux)
- Duplicate Windows entries removed (disabled os-prober)
- Windows Boot Manager added manually
- UEFI Firmware moved to bottom of menu

### Caelestia Shell Issue - FIXED
- Identified root causes from caelestia-shell removal
- Lessons learned documented
- Btrfs mount advice included

### Secure Boot - INFO
- Keep disabled for gaming compatibility

---

## Fixes Summary

| Issue | Status | Document |
|-------|--------|----------|
| NVIDIA RTX 5050 Driver | FIXED | [[System/Fixes/NVIDIA-RTX-5050-Investigation]] |
| GRUB Duplicate Entries | FIXED | [[System/Fixes/GRUB-Configuration]] |
| GRUB Menu Order | FIXED | [[System/Fixes/GRUB-Duplicate-Entries]] |
| Secure Boot | Reference | [[System/Fixes/Secure-Boot-Guide]] |
| Caelestia Shell Removal | FIXED | [[System/Fixes/caelestia-shell-Removal-Issues]] |

---

## Visual Documentation

| Document | Content |
|---------|---------|
| [[System/Fixes/Visual-Guides]] | Mermaid flowcharts, before/after diagrams |
| [[System/System-Architecture]] | System diagrams, boot process, NVIDIA pipeline |
| [[System/Fixes/Quick-Reference]] | ASCII diagrams, one-liner commands |

---

## AI CLI Agents

| Tool | Version | Location |
|------|---------|----------|
| Claude Code | 2.1.263 | Current session |
| OpenCode | 1.18.29 | `/usr/bin/opencode` |
| Grok | 1.0.13 | `/usr/bin/grok` |
| Gemini CLI | 0.57.0 | `~/.local/npm/bin/gemini` |
| FreeBuff | 0.0.154 | `/usr/bin/freebuff` |
| Kilo | 7.5.15 | `/usr/bin/kilo` |
| Hermes | 0.21.0 | `~/.local/bin/hermes` |
| Ollama | 0.33.3 | `/usr/bin/ollama` |

---

## Maintenance

To update this vault:
1. Check [[Map of Content]] for full overview
2. Add new files to appropriate category folders
3. Update this index when adding new categories
4. Run [[System/Fixes/Visual-Guides]] updates when system changes
