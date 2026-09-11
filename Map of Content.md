# Master Map of Content

> **Vault:** Nazky's Knowledge Base
> **Last Updated:** September 10, 2026
> **Total Notes:** 192 markdown files
> **System:** [[System Hardware Profile|Lenovo 83LY - Arch Linux]]

---

## Quick Navigation

| Section                          | Description                    | Key Notes                                                        |
| -------------------------------- | ------------------------------ | ---------------------------------------------------------------- |
| System/Linux/                      | System admin, CLI, BlackArch   | System Specifications, CLI Cheatsheet - 12 files                 |
| System/Caelestia/                  | Hyprland + Caelestia shell     | Caelestia System Architecture, Caelestia Config Files - 7 files  |
| System/Caelestia-Investigation/    | Performance debugging          | 00 - Investigation Overview, Root Cause - Swappiness 100 - 31 files |
| System/Fixes/                      | System fixes and guides        | NVIDIA-RTX-5050-Investigation, GRUB-Configuration, HDMI-Monitor-Fix-NVIDIA-Wayland - 11 files |
| System/Gaming/                     | NFS Heat Proton GE + PRIME     | System-Info, The-Problem, README - 7 files                       |
| System/Display-Server/             | Wayland/Hyprland input         | hyprland-trackpad-sensitivity                                    |
| 07-Incident Response/SEO-Poisoning-Analysis/ | SEO Judi Slot IR   | 00-SEO-Poisoning-Analysis, 05-Case-Study-kurmamedia - 6 files, complete 2026-09-07 |
| Personal/Cybersecurity/            | Pentesting tools and methodology | BlackArch Tools, Blackarch - Blackarch 7, Requierements 6, Tools 9 |
| Personal/Device/                   | Device-specific notes          | 00 - Device Overview to 08 - Boot Configuration - 9 files        |
| Personal/School/                   | School project docs            | P3, What-to-Create                                               |
| Personal/Session-Logs/             | Troubleshooting sessions       | 2026-08-29-Caelestia-Session - 7 files                           |
| Personal/Spreadsheets-Auth/        | Google Sheets API auth         | Spreadsheets Auth, Google Sheets Login API Setup - 4 files       |
| Development/Database/              | Laravel database management    | Database Management and phpMyAdmin Guide - 2 files               |
| Development/Github/                | Git tutorials                  | GitHub - Connect Repository Tutorial                             |
| Development/VSCode Theme Bug/      | VSCode theme debugging         | Bug Report - VSCode Theme Rendering Issue, 00 - Map of Content - 19 files |
| Tasks/E-Commerce PBO/              | Laravel E-Commerce errors      | 00 - Index to 09 - Verification - 10 files                       |
| Tasks/Laravel-CRUD/                | Laravel CRUD guide             | Laravel CRUD, E-Commerce PBO - Debugging Guide - 10 files        |
| Tasks/Nazkypedia-UI-Improvements/  | Wiki UI overhaul          | README, Session-1-UI-Overhaul to Session-3 - 10 files            |
| Tasks/React-Native-Taskmanager/    | Mobile taskmanager         | PEMBUATAN APLIKASI TASKMANAGER - 4 files                         |
| Tasks/ root                        | Migration guides               | Arch Migration, Arch Linux System Fixes, Automated tools         |
| AGENTS/                            | AI CLI agents                  | AI-CLI-Agents - 8 tools documented                               |

---

## System Overview

```mermaid
graph TB
    subgraph Hardware["Hardware Profile"]
        CPU["CPU i7 13650HX 20 cores"]
        RAM["RAM 15GB DDR5"]
        GPU["RTX 5050 plus Intel UHD"]
        Storage["2x NVMe drives"]
    end
    
    subgraph Software["Software Stack"]
        OS[BlackArch Linux]
        DE["Hyprland and Caelestia"]
        Shell[Fish Shell]
        Terminal[Foot Terminal]
        Apps["VSCodium Neovim Steam"]
    end
    
    subgraph Status["Current Status"]
        MemStatus["RAM mostly used"]
        SwapStatus["ZRAM enabled"]
        CPUStatus[CPU: Variable]
    end
```

## Architecture Flow

### System Components
```mermaid
graph TD
    A[System Boot] --> B[Kernel Loading]
    B --> C[Systemd Init]
    C --> D["SDDM display manager"]
    D --> E["Hyprland compositor"]
    E --> F["Caelestia shell"]
    F --> G[Applications]
    G --> H[User Workspace]
```

### Performance Pipeline
```mermaid
flowchart LR
    A[Performance Issues] --> B{Diagnosis}
    B --> C[RAM Analysis]
    B --> D[CPU Analysis]
    B --> E[Disk I/O]
    B --> F[Network]
    
    C --> G[Swappiness]
    D --> H[Frequency Scaling]
    E --> I[Scheduler]
    F --> J[Latency]
    
    G --> K[System Optimized]
    H --> K
    I --> K
    J --> K
```

## Recent Activity

### Timeline
```mermaid
gantt
    dateFormat  YYYY-MM-DD
    title System Maintenance Timeline
    
    section Aug 30
    Fix Caelestia Lag      :active, 2026-08-30, 3h
    Fix Swappiness        :active, 2026-08-30, 1h
    Disable MariaDB       :active, 2026-08-30, 30m
    
    section Sep 7
    Niri Haku Setup        :done, 2026-09-07, 4h
    HDMI Fix NVIDIA Wayland :done, 2026-09-07, 2h
    SEO IR kurmamedia       :done, 2026-09-07, 3h
    
    section Sep 9
    Terminal Config Backup :done, 2026-09-09, 30m
    Roblox Sober Install    :done, 2026-09-09, 1h

    section Sep 10
    Vault Index Refresh     :done, 2026-09-10, 1h
    
    section This Week
    Arch Migration      :done, 2026-08-25, 2d
    BlackArch Setup     :done, 2026-08-27, 4h
    Gaming Config       :done, 2026-08-29, 2h
```

## Cross-Reference Hubs

### Performance & Optimization
```mermaid
mindmap
  root((Performance))
    Memory
      ZRAM Configuration
      Swappiness Tuning
      Cache Pressure
      Process Monitoring
    CPU
      Frequency Governor
      Process Priority
      Core Isolation
    Disk
      I/O Scheduler
      Mount Options
      Filesystem Cache
    Network
      Buffer Sizes
      Connection Limits
      Latency Tuning
```

### Cybersecurity Toolkit
```mermaid
graph TD
    Recon["Recon tools"] --> Scan["Scan tools"]
    Scan --> Enum["Enum tools"]
    Enum --> Vuln["Vuln check"]
    Vuln --> Exploit["Exploit tools"]
    Exploit --> Cracking["Password tools"]

Tools per stage: nmap and amass, masscan, dirsearch and ffuf, nikto and nuclei, metasploit and burpsuite, hashcat and john.
```

### Development Stack
```mermaid
graph TB
    subgraph Backend["Backend"]
        Laravel[Laravel PHP]
        MySQL[(MySQL Database)]
        API[REST API]
    end
    
    subgraph Frontend["Frontend"]
        Vue[Vue.js]
        Tailwind[Tailwind CSS]
        Build[Vite Build]
    end
    
    Laravel --> MySQL
    Vue --> Build
    Laravel --> API
    API --> Vue
```

## Topic Diagrams

Diagrams now live per topic in Graphs/00-Graph-Index, not merged here.

## Folder Structure

```
Obsidian Vault/ (192 md files, updated 2026-09-10)
├── Map of Content.md     <-- YOU ARE HERE
├── README.md / Path.md / PROMPTS.md
│
├── 07-Incident Response/
│   └── SEO-Poisoning-Analysis/  # 6 files: 00-Overview to 05-Case-Study
├── AGENTS/                # AI-CLI-Agents.md + README.md
│
├── System/
│   ├── Linux/            # 12 files: Arch-Perf, BlackArch, Hyprland, ZRAM, CLI, Monitoring
│   ├── Caelestia/        # 7 files: 00-Overview, Architecture, Keybinds, Lock, Mod-Guide, Config-Ref
│   ├── Caelestia-Investigation/  # 31 files: perf debugging
│   ├── Fixes/            # 11 files: NVIDIA x2, GRUB x3, HDMI, Secure-Boot, Quick-Ref, Visuals, README
│   ├── Gaming/           # 7 files: README, Setup-Log, Problem, Solution, System-Info, Launch, Troubleshooting
│   ├── Display-Server/   # hyprland-trackpad-sensitivity.md
│   ├── Starship Installation.md
│   ├── Shell Startup Order.md
│   ├── System-Architecture.md
│   ├── Troubleshooting Steps.md
│   ├── Caelestia Dotfiles Context.md
│   ├── KDE-Plasma-Ricing.md
│   ├── hakuspace-niri-setup-2026-09-07.md
│   ├── terminal-config-backup-2026-09-09.md
│   └── roblox-sober-install.md  # 2026-09-09
│
├── Personal/
│   ├── Cybersecurity/
│   │   ├── Blackarch/    # 7 files
│   │   ├── Tools/        # 9 files: Burp, Nmap, Nuclei, Sqlmap, Dirsearch, Fuzzing
│   │   └── Requierements/ # 6 files: Owasp, Pentest, Auth, DB
│   ├── Device/           # 9 files: 00-Overview to 08-Boot
│   ├── School/           # P3, P3-2, What-to-Create
│   ├── Session-Logs/     # 2026-08-29-Caelestia-Session (7 files)
│   └── Spreadsheets-Auth/ # 4 files
│
├── Development/
│   ├── Database/         # 2 files
│   ├── Github/           # 1 file
│   ├── Prompts/          # empty
│   ├── VSCode/           # empty
│   └── VSCode Theme Bug/ # 19 files: 00-MOC to 15-Matrix + Report + Tags
│
└── Tasks/
    ├── Arch Migration.md / Arch Linux System Fixes.md / Automated tools.md
    ├── E-Commerce PBO/   # 10 files
    ├── Laravel-CRUD/     # 10 files
    ├── Nazkypedia-UI-Improvements/  # 10 files
    └── React-Native-Taskmanager/    # 4 files
```

## Tag Ecosystem

### Related Tags
```mermaid
graph TD
    A["arch"] --> B["blackarch"]
    B --> C["hyprland"]
    C --> D["wayland"]
    D --> E["caelestia"]
    
    F["perf"] --> G["opt"]
    G --> H["fix"]
    
    I["pentest"] --> J["cyber"]
    J --> K["sec"]
    
    L["laravel"] --> M["php"]
    M --> N["backend"]
    N --> O["api"]
```

## Resource Usage

```mermaid
pie title Memory Allocation
    "Chrome + Apps" : 5.2
    "System Processes" : 1.8
    "Available" : 8
    "Cache/Buffers" : 0
```

**Tags:** #moc #index #navigation #vault #knowledge-base