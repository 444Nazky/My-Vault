# Vault Path Index
# Last Updated: 2026-09-10 - 192 markdown files

Obsidian Vault/
├── 07-Incident Response/
│   └── SEO-Poisoning-Analysis/          # 6 files - COMPLETE 2026-09-07
│       ├── 00-SEO-Poisoning-Analysis.md
│       ├── 01-Mod-Operandus-IoC.md
│       ├── 02-Investigation-Commands.md
│       ├── 03-Remediation-Hardening.md
│       ├── 04-Checklist.md
│       └── 05-Case-Study-kurmamedia.md
├── AGENTS/
│   ├── AI-CLI-Agents.md
│   └── README.md
├── Development/
│   ├── Database/                        # 2 files
│   │   ├── Database Management & phpMyAdmin Guide.md
│   │   └── How to use phpmyadmin.md
│   ├── Github/                          # 1 file
│   │   └── GitHub - Connect Repository Tutorial.md
│   ├── Prompts/                         # empty
│   ├── VSCode/                          # empty
│   └── VSCode Theme Bug/                # 19 files - DOCUMENTED
│       ├── 00 - Map of Content.md
│       ├── 01 to 15 - guides, cheatsheets, matrix
│       ├── Bug Report - VSCode Theme Rendering Issue.md
│       └── Tags Index - VSCode Theme Bug.md
├── Personal/
│   ├── Cybersecurity/
│   │   ├── Blackarch/                   # 7 files
│   │   ├── Tools/                       # 9 files: Burpsuite, Dirsearch x2, Fuzzing, Nmap, Nuclei, SQLi, Sqlmap, cheatsheet
│   │   └── Requierements/               # 6 files: Bootcamp, Database, Login Auth, Owasp, Pentest, SysReq
│   ├── Device/                          # 9 files
│   │   ├── 00 - Device Overview.md
│   │   └── 01 to 08 - Hardware to Boot Configuration
│   ├── School/
│   │   ├── P3.md
│   │   ├── P3 - 2.md
│   │   └── What-to-Create.md
│   ├── Session-Logs/
│   │   └── 2026-08-29-Caelestia-Session/ # 7 files
│   └── Spreadsheets-Auth/               # 4 files
├── System/
│   ├── Caelestia/                       # 7 files
│   │   ├── 00-Overview.md
│   │   ├── Caelestia-System-Architecture.md
│   │   └── Keybinds, Lock, Mod-Guide, Config-Ref, Reduce-Transparency
│   ├── Caelestia-Investigation/         # 31 files - FIXED
│   ├── Display-Server/
│   │   └── hyprland-trackpad-sensitivity.md
│   ├── Fixes/                           # 11 files - ALL FIXED
│   │   ├── README.md
│   │   ├── NVIDIA-RTX-5050-Investigation.md
│   │   ├── NVIDIA-RTX-5050-Fix-Commands.md
│   │   ├── GRUB-Configuration.md
│   │   ├── GRUB-Duplicate-Entries.md
│   │   ├── GRUB-Duplicate-Entries-Fix-Commands.md
│   │   ├── HDMI-Monitor-Fix-NVIDIA-Wayland.md  # FIXED 2026-09-07
│   │   ├── caelestia-shell-Removal-Issues.md
│   │   ├── Secure-Boot-Guide.md
│   │   ├── Quick-Reference.md
│   │   └── Visual-Guides.md
│   ├── Gaming/                          # 7 files - FIXED (NFS Heat PRIME)
│   │   ├── README.md
│   │   ├── Setup-Log.md / System-Info.md
│   │   ├── The-Problem.md / The-Solution.md
│   │   └── Launch-Options.md / Troubleshooting.md
│   ├── Linux/                           # 12 files
│   ├── Starship Installation.md
│   ├── Shell Startup Order.md
│   ├── System-Architecture.md
│   ├── Troubleshooting Steps.md
│   ├── Caelestia Dotfiles Context.md
│   ├── KDE-Plasma-Ricing.md
│   ├── hakuspace-niri-setup-2026-09-07.md
│   ├── terminal-config-backup-2026-09-09.md
│   └── roblox-sober-install.md          # INSTALLED 2026-09-09
├── Tasks/
│   ├── Arch Migration.md
│   ├── Arch Linux System Fixes.md
│   ├── Automated tools.md
│   ├── E-Commerce PBO/                  # 10 files: 00-Index to 09-Verification
│   ├── Laravel-CRUD/                    # 10 files
│   ├── Nazkypedia-UI-Improvements/      # 10 files: Sessions 1-3
│   └── React-Native-Taskmanager/        # 4 files
├── README.md                            # Index - updated 2026-09-10
├── Map of Content.md                    # MOC with graphs - updated 2026-09-10
├── Path.md                              # YOU ARE HERE
└── PROMPTS.md                           # Do NOT edit (AI rule)

## Fix Graph
System-Boot --> Kernel --> Systemd --> SDDM --> Hyprland --> Caelestia --> Apps
NVIDIA-FIXED + GRUB-FIXED + HDMI-FIXED + Gaming-FIXED + Sober-INSTALLED = All-Green 2026-09-10

## IR Graph
SEO-Poisoning --> DNS-Check --> HTTP-Check --> IoC --> Commands --> Remediation --> Checklist --> Case-Study

## Dev Graph
Laravel --> MySQL --> API --> Vue --> Vite-Build
E-Com-PBO-errors --> Laravel-CRUD-guide --> Nazkypedia-UI --> React-Native-Taskmanager
