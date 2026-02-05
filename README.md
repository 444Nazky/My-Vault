# Obsidian Vault Index

**Location:** `~/Documents/Obsidian Vault/`
**Last Updated:** 2026-09-10
**Total Notes:** 192 markdown files

---

## Folder Structure

```
Obsidian Vault/
├── 07-Incident Response/        # IR cases
│   └── SEO-Poisoning-Analysis/  # 6 files: 00-Overview to 05-Case-Study
├── AGENTS/                    # AI CLI agents documentation
│   ├── AI-CLI-Agents.md
│   └── README.md
├── Development/               # Development projects & guides
│   ├── Database/              # 2 files: phpMyAdmin guides
│   ├── Github/                # GitHub connect tutorial
<!-- Last updated: 2026-09-12T09:59:49+07:00 -->
│   ├── Prompts/               # empty
│   ├── VSCode/                # empty
│   └── VSCode Theme Bug/      # 19 files: 00-MOC to 15-Matrix + Bug Report + Tags
├── Personal/                  # Personal notes & logs
│   ├── Cybersecurity/         # Blackarch (7), Requierements (6), Tools (9)
│   ├── Device/                # 00-Overview to 08-Boot Configuration (9 files)
│   ├── School/                # P3, P3-2, What-to-Create
│   ├── Session-Logs/          # 2026-08-29-Caelestia-Session (7 files)
│   └── Spreadsheets-Auth/     # 4 files: Sheets API auth
├── System/                    # System configurations & fixes
│   ├── Caelestia/             # 7 files: Overview, Arch, Keybinds, Lock, Mod-Guide, Config-Ref
│   ├── Caelestia-Investigation/ # 31 files: perf debugging
│   ├── Display-Server/        # hyprland-trackpad-sensitivity
│   ├── Fixes/                 # 11 files: NVIDIA, GRUB, HDMI, Secure-Boot, Visuals
│   ├── Gaming/                # 7 files: NFS Heat on Proton GE + NVIDIA PRIME
│   ├── Linux/                 # 12 files: Arch perf, BlackArch, Hyprland, ZRAM, CLI
│   ├── Starship Installation.md
│   ├── Shell Startup Order.md
│   ├── System-Architecture.md
│   ├── Troubleshooting Steps.md
│   ├── Caelestia Dotfiles Context.md
│   ├── KDE-Plasma-Ricing.md
│   ├── hakuspace-niri-setup-2026-09-07.md
│   ├── terminal-config-backup-2026-09-09.md
│   └── roblox-sober-install.md  # NEW 2026-09-09: Sober Flatpak 1.7.1
├── Tasks/                     # Project tasks
│   ├── Arch Migration.md
│   ├── Arch Linux System Fixes.md
│   ├── Automated tools.md
│   ├── E-Commerce PBO/        # 10 files: 00-Index to 09-Verification
│   ├── Laravel-CRUD/          # 10 files: Model to Debugging Guide
│   ├── Nazkypedia-UI-Improvements/ # 10 files: Sessions 1-3 + specs
│   └── React-Native-Taskmanager/ # 4 files: Taskmanager app
├── PROMPTS.md
├── README.md                  # YOU ARE HERE
├── Map of Content.md
└── Path.md
```

---

## Quick Access

| Category | Path |
|----------|------|
| AI Agents | AGENTS/AI-CLI-Agents |
| System Fixes Index | System/Fixes/README |
| NVIDIA Fix | System/Fixes/NVIDIA-RTX-5050-Investigation |
| NVIDIA Commands | System/Fixes/NVIDIA-RTX-5050-Fix-Commands |
| GRUB Fix | System/Fixes/GRUB-Configuration |
| GRUB Commands | System/Fixes/GRUB-Duplicate-Entries-Fix-Commands |
| HDMI Monitor Fix | System/Fixes/HDMI-Monitor-Fix-NVIDIA-Wayland |
| Caelestia Shell Issue | System/Fixes/caelestia-shell-Removal-Issues |
| Caelestia Config | System/Caelestia/00-Overview |
| System Architecture | System/System-Architecture |
| Terminal Setup | System/terminal-config-backup-2026-09-09 |
| Niri Setup | System/hakuspace-niri-setup-2026-09-07 |
| Roblox Sober | System/roblox-sober-install |
| Trackpad | System/Display-Server/hyprland-trackpad-sensitivity |
| Gaming NFS Heat | System/Gaming/README |
| Visual Guides | System/Fixes/Visual-Guides |
| Quick Reference | System/Fixes/Quick-Reference |
| Graphs Index | Graphs/00-Graph-Index - per-topic diagrams |
| Web Links Hub | Web-Links-Hub - pointer page |
| SEO Poisoning IR | 07-Incident Response/SEO-Poisoning-Analysis/00-SEO-Poisoning-Analysis |
| VSCode Theme Bug MOC | Development/VSCode Theme Bug/00 - Map of Content |
| Device Overview | Personal/Device/00 - Device Overview |
| E-Commerce PBO | Tasks/E-Commerce PBO/00 - Index |
| Laravel CRUD | Tasks/Laravel-CRUD/Laravel CRUD |

---

## Status: All Fixes Complete (Updated 2026-09-10)

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

### HDMI Monitor on NVIDIA Wayland - FIXED 2026-09-07
- UKI cmdline fixed: `nvidia-drm.modeset=1` added to `/etc/kernel/cmdline`
- Bumblebee blacklist disabled
- `options nvidia-drm modeset=1` in `/etc/modprobe.d/nvidia.conf`
<!-- Last updated: 2026-09-11T09:30:14+07:00 -->
- Verified with `modprobe nvidia-drm`

### Gaming NFS Heat - FIXED
- Proton GE 11-6 + `__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia`
- Forced dGPU instead of Intel iGPU
- See System/Gaming/README for setup

### Roblox via Sober - INSTALLED 2026-09-09
- Flatpak `org.vinegarhq.Sober` 1.7.1, 18.5 MB
- Wayland/Hyprland compatible, RTX 5050 passthrough confirmed
- Wrapper at `~/.local/bin/sober`
- See System/roblox-sober-install for details

### SEO Poisoning IR - INVESTIGATION COMPLETE 2026-09-07
- Target `kurmamedia.com` (72.61.209.233, Hostinger ID)
- HTTP down, DNS active - likely suspended/taken down
- Full framework: Modus/IoC, Commands, Remediation, Checklist, Case Study
- See 07-Incident Response/SEO-Poisoning-Analysis/00-SEO-Poisoning-Analysis for the framework

### VSCode Theme Bug - DOCUMENTED
- 19 files: root cause (APC Customize UI++ alpha), fix guide, prevention, matrix
- See Development/VSCode Theme Bug/00 - Map of Content for the full series

### Secure Boot - INFO
- Keep disabled for gaming compatibility

---

## Fixes Summary

| Issue | Status | Document |
|-------|--------|----------|
| NVIDIA RTX 5050 Driver | FIXED | System/Fixes/NVIDIA-RTX-5050-Investigation |
| GRUB Duplicate Entries | FIXED | System/Fixes/GRUB-Configuration |
| GRUB Menu Order | FIXED | System/Fixes/GRUB-Duplicate-Entries |
| HDMI Monitor NVIDIA Wayland | FIXED 2026-09-07 | System/Fixes/HDMI-Monitor-Fix-NVIDIA-Wayland |
| Secure Boot | Reference | System/Fixes/Secure-Boot-Guide |
| Caelestia Shell Removal | FIXED | System/Fixes/caelestia-shell-Removal-Issues |
| NFS Heat Intel vs NVIDIA | FIXED | System/Gaming/README |
| Roblox Sober Install | INSTALLED 2026-09-09 | System/roblox-sober-install |
| SEO Poisoning kurmamedia | INVESTIGATED 2026-09-07 | 07-Incident Response/SEO-Poisoning-Analysis/00-SEO-Poisoning-Analysis |
| VSCode Theme Rendering | DOCUMENTED | Development/VSCode Theme Bug/Bug Report - VSCode Theme Rendering Issue |

---

## Visual Documentation

| Document | Content |
|---------|---------|
| System/Fixes/Visual-Guides | Mermaid flowcharts, before/after diagrams |
| System/System-Architecture | System diagrams, boot process, NVIDIA pipeline |
| System/Fixes/Quick-Reference | ASCII diagrams, one-liner commands |

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
1. Check Map of Content for full overview
2. Add new files to appropriate category folders
3. Update this index when adding new categories
4. Run System/Fixes/Visual-Guides updates when system changes

## Tags
#note-readme
