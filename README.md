# Obsidian Vault Index

**Location:** `~/Documents/Obsidian Vault/`
**Last Updated:** 2026-09-12
**Total Notes:** 301 markdown files

---

## Folder Structure

```
Obsidian Vault/
├── 07-Incident Response/        # IR cases
│   └── SEO-Poisoning-Analysis/  # 6 files: 00-Overview to 05-Case-Study
├── AGENTS/                      # AI CLI agents documentation
│   ├── AI-CLI-Agents.md
│   └── README.md
├── attachments/                 # visual assets (orange-nodes, SVGs, subfolders)
│   ├── cybersecurity/           # SVG diagrams
│   ├── development/             # SVG diagrams
│   ├── macbook/                 # SVG diagrams
│   ├── system/                  # SVG diagrams
│   ├── orange-nodes-overview.png
│   ├── orange-nodes-overview.svg
│   └── orange-nodes-README.md
├── Development/                 # Development projects & guides
│   ├── Database/                # 2 files: phpMyAdmin guides
│   ├── Github/                  # GitHub connect tutorial
│   ├── Guides/                  # coding guides (zero external links)
│   ├── Programming-Languages/   # 17 languages + cheatsheets
│   │   ├── Managed/             # CSharp, Java, Kotlin, Swift, Dart, TypeScript
│   │   ├── Scripting/           # Python, PHP, Lua, Bash, SQL, Haskell
│   │   └── Systems/             # C, Cpp, Rust, Zig, Go
│   ├── Database/                # 2 files
│   ├── Github/                  # 1 file
│   ├── VSCode Theme Bug/        # 18 files: 00-MOC to 15-Matrix + Bug Report + Tags
│   └── Prompts/                 # (removed)
├── Graphs/                      # 12 files: diagrams + SVGs + notes
│   ├── 00-Graph-Index.md
│   ├── Vault-Overview.md
│   ├── System-Diagrams.md
│   ├── Gaming-Diagrams.md
│   ├── Security-IR-Diagrams.md
│   ├── Dev-Tasks-Diagrams.md
│   ├── auto-vault.md / .svg
│   ├── knowledge-graph.md / .svg
│   └── vault-stack.md / .svg
├── Orphans/                     # unattached notes
├── Personal/                    # Personal notes & logs
│   ├── Cybersecurity/           # Blackarch (7), Tools (9), Requierements (6), Guides (8)
│   ├── Device/                  # 00-Overview to 08-Boot (9 files)
│   ├── School/                  # P3, P3-2, What-to-Create
│   ├── Session-Logs/            # 2026-08-29-Caelestia-Session (7 files)
│   └── Spreadsheets-Auth/       # 4 files
├── plans/                       # 10 files: 00-Plan-Index to 09-Price-Breakdown (MacBook, Bahasa)
├── Stuffs-coded/                # misc coded projects
│   └── g1/                      # data.json, index.js, package.json, README
├── System/                      # System configurations & fixes
│   ├── Caelestia/               # 7 files: Overview, Arch, Keybinds, Lock, Mod-Guide, Config-Ref
│   ├── Caelestia-Investigation/ # 31 files: perf debugging, WiFi managers
│   ├── Display-Server/          # hyprland-trackpad-sensitivity
│   ├── Fixes/                   # 11 files: NVIDIA, GRUB, HDMI, Secure-Boot
│   ├── Gaming/                  # 7 files: NFS Heat, Sober, GPU decisions
│   ├── Linux/                   # 12 files: Arch perf, BlackArch, Hyprland, ZRAM, CLI
│   ├── Ricing/                  # 6 files + code configs
│   ├── WiFi Troubleshooting/    # 7 files: 00-Overview to 06-Quick-Reference (2026-09-12)
│   ├── Starship Installation.md
│   ├── Shell Startup Order.md
│   ├── System-Architecture.md
│   ├── Troubleshooting Steps.md
│   ├── Caelestia Dotfiles Context.md
│   ├── KDE-Plasma-Ricing.md
│   ├── hakuspace-niri-setup-2026-09-07.md
│   ├── terminal-config-backup-2026-09-09.md
│   └── roblox-sober-install.md  # NEW 2026-09-09: Sober Flatpak 1.7.1
├── Tasks/                       # Project tasks
│   ├── Arch Migration.md
│   ├── Arch Linux System Fixes.md
│   ├── Automated tools.md
│   ├── E-Commerce PBO/          # 10 files: 00-Index to 09-Verification
│   ├── Laravel-CRUD/            # 10 files: Model to Debugging Guide
│   ├── Nazkypedia-UI-Improvements/ # 10 files
│   └── React-Native-Taskmanager/  # 4 files
├── Graphs/                      # per-topic diagrams
│   ├── 00-Graph-Index.md
│   ├── Vault-Overview.md
│   ├── System-Diagrams.md
│   ├── Gaming-Diagrams.md
│   ├── Security-IR-Diagrams.md
│   └── Dev-Tasks-Diagrams.md
├── PROMPTS.md
│   Path.md
├── Map of Content.md            # MASTER INDEX
├── README.md                    # YOU ARE HERE
├── Tags-Index.md
├── GitHub-Cheatsheet.md
└── Web-Links-Hub.md
```

---

## Quick Access

| Category | Path |
|----------|------|
| WiFi Troubleshooting | System/WiFi Troubleshooting/00-Overview |
| Orange Nodes Visual | attachments/orange-nodes-overview.png |
| Graphs Index | Graphs/00-Graph-Index |
| System Fixes Index | System/Fixes/README |
| NVIDIA Fix | System/Fixes/NVIDIA-RTX-5050-Investigation |
| GRUB Fix | System/Fixes/GRUB-Configuration |
| HDMI Monitor Fix | System/Fixes/HDMI-Monitor-Fix-NVIDIA-Wayland |
| Caelestia Shell Issue | System/Fixes/caelestia-shell-Removal-Issues |
| MacBook Plans | plans/00-Plan-Index |
| Graph SVGs | Graphs/auto-vault, knowledge-graph, vault-stack |
| Graph Index | Graphs/00-Graph-Index |
| Web Links Hub | Web-Links-Hub |
| SEO Poisoning IR | 07-Incident Response/SEO-Poisoning-Analysis/00-SEO-Poisoning-Analysis |
| VSCode Theme Bug MOC | Development/VSCode Theme Bug/00 - Map of Content |
| Device Overview | Personal/Device/00 - Device Overview |
| E-Commerce PBO | Tasks/E-Commerce PBO/00 - Index |
| Laravel CRUD | Tasks/Laravel-CRUD/Laravel CRUD |
| WiFi Troubleshooting | System/WiFi Troubleshooting/00-Overview |

---

## Recent Additions (2026-09-12)

### WiFi Fix - COMPLETE
- Intel AX211 WiFi card was in D4 power state (PCI disabled, ACPI S4)
- Driver probe timed out (`error -110`)
- Fixed via system reboot - proper PCI reinitialization
- Now connected to Gladi_ASTS6 (5GHz, 22 dBm)

### Graph Coloring - COMPLETE
- All 6 diagram files in Graphs/ now have Mermaid color theming
- 8-color palette: Blue (processes), Green (fixed), Red (problems), Yellow (decisions), Purple (data), Orange (tools), Cyan (network), Pink (UI)
- Orange nodes visual attachment created

---

## Status: All Fixes Complete (Updated 2026-09-12)

### WiFi Intel AX211 - FIXED
- PCI device enabled, driver loaded, probe successful
- Connected to Gladi_ASTS6 (5GHz)
- See System/WiFi Troubleshooting/ for full investigation

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
<!-- Last updated: 2026-09-12T01:00:00+07:00 -->
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
- 18 files: root cause (APC Customize UI++ alpha), fix guide, prevention, matrix
- See Development/VSCode Theme Bug/00 - Map of Content for the full series

### WiFi Troubleshooting - DOCUMENTED 2026-09-12
- Intel AX211 D4 power state issue diagnosed and fixed
- Orange nodes visual reference created
- Full investigation in System/WiFi Troubleshooting/

### Secure Boot - INFO
- Keep disabled for gaming compatibility

---

## Fixes Summary

| Issue | Status | Document |
|-------|--------|----------|
| WiFi Intel AX211 | FIXED 2026-09-12 | System/WiFi Troubleshooting/00-Overview |
| NVIDIA RTX 5050 Driver | FIXED | System/Fixes/NVIDIA-RTX-5050-Investigation |
| GRUB Duplicate Entries | FIXED | System/Fixes/GRUB-Configuration |
| GRUB Menu Order | FIXED | System/Fixes/GRUB-Duplicate-Entries |
| HDMI Monitor NVIDIA Wayland | FIXED 2026-09-07 | System/Fixes/HDMI-Monitor-Fix-NVIDIA-Wayland |
| Secure Boot | Reference | System/Fixes/Secure-Boot-Guide |
| Caelestia Shell Removal | FIXED | System/Fixes/caelestia-shell-Removal-Issues |
| NFS Heat Intel vs NVIDIA | FIXED | System/Gaming/README |
| Roblox Sober Install | INSTALLED 2026-09-09 | System/roblox-sober-install |
| SEO Poisoning kurmamedia | INVESTIGATED 2026-09-07 | 07-Incident Response/SEO-Poisoning-Analysis/00-SEO-Poisoning-Analysis |
| VSCode Theme Rendering | DOCUMENTED | Development/VSCode Theme Bug/Bug Report |
| WiFi Troubleshooting | DOCUMENTED 2026-09-12 | System/WiFi Troubleshooting/00-Overview |

---

## Visual Documentation

| Document | Content |
|---------|---------|
| System/Fixes/Visual-Guides | Mermaid flowcharts, before/after diagrams |
| System/System-Architecture | System diagrams, boot process, NVIDIA pipeline |
| System/Fixes/Quick-Reference | ASCII diagrams, one-liner commands |
| Graphs/ | 6 diagram pages, all colored (Graphs/00-Graph-Index) |
| attachments/orange-nodes-overview.png | Orange node visual across all diagrams |

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
