# Master Map of Content

> **Vault:** Nazky's Knowledge Base
> **Last Updated:** September 10, 2026
> **Total Notes:** 192 markdown files
> **System:** [[System Hardware Profile|Lenovo 83LY - Arch Linux]]

---

## Quick Navigation

| Section                          | Description                    | Key Notes                                                        |
| -------------------------------- | ------------------------------ | ---------------------------------------------------------------- |
| [[System/Linux/]]                | System admin, CLI, BlackArch   | [[System Specifications]], [[CLI Cheatsheet]] - 12 files         |
| [[System/Caelestia/]]            | Hyprland + Caelestia shell     | [[Caelestia System Architecture]], [[Caelestia Config Files]] - 7 files |
| [[System/Caelestia-Investigation/]] | Performance debugging       | [[00 - Investigation Overview]], [[Root Cause - Swappiness 100]] - 31 files |
| [[System/Fixes/]]                | System fixes and guides        | [[NVIDIA-RTX-5050-Investigation]], [[GRUB-Configuration]], [[HDMI-Monitor-Fix-NVIDIA-Wayland]] - 11 files |
| [[System/Gaming/]]               | NFS Heat Proton GE + PRIME     | [[System-Info]], [[The-Problem]], [[README]] - 7 files           |
| [[System/Display-Server/]]       | Wayland/Hyprland input         | [[hyprland-trackpad-sensitivity]]                                |
| [[07-Incident Response/SEO-Poisoning-Analysis/]] | SEO Judi Slot IR | [[00-SEO-Poisoning-Analysis]], [[05-Case-Study-kurmamedia]] - 6 files, complete 2026-09-07 |
| [[Personal/Cybersecurity/]]      | Pentesting tools and methodology | [[BlackArch Tools]], [[Blackarch]] - Blackarch 7, Requierements 6, Tools 9 |
| [[Personal/Device/]]             | Device-specific notes          | [[00 - Device Overview]] to [[08 - Boot Configuration]] - 9 files |
| [[Personal/School/]]             | School project docs            | [[P3]], [[What-to-Create]]                                       |
| [[Personal/Session-Logs/]]       | Troubleshooting sessions       | [[2026-08-29-Caelestia-Session/]] - 7 files                      |
| [[Personal/Spreadsheets-Auth/]]  | Google Sheets API auth         | [[Spreadsheets Auth]], [[Google Sheets Login API Setup]] - 4 files |
| [[Development/Database/]]        | Laravel database management    | [[Database Management & phpMyAdmin Guide]] - 2 files             |
| [[Development/Github/]]          | Git tutorials                  | [[GitHub - Connect Repository Tutorial]]                         |
| [[Development/VSCode Theme Bug/]] | VSCode theme debugging        | [[Bug Report - VSCode Theme Rendering Issue]], [[00 - Map of Content]] - 19 files |
| [[Tasks/E-Commerce PBO/]]        | Laravel E-Commerce errors      | [[00 - Index]] to [[09 - Verification]] - 10 files               |
| [[Tasks/Laravel-CRUD/]]          | Laravel CRUD guide             | [[Laravel CRUD]], [[E-Commerce PBO - Debugging Guide]] - 10 files |
| [[Tasks/Nazkypedia-UI-Improvements/]] | Wiki UI overhaul          | [[README]], [[Session-1-UI-Overhaul]] to Session-3 - 10 files    |
| [[Tasks/React-Native-Taskmanager/]] | Mobile taskmanager         | [[PEMBUATAN APLIKASI TASKMANAGER]] - 4 files                     |
| [[Tasks/]] root                  | Migration guides               | [[Arch Migration]], [[Arch Linux System Fixes]], [[Automated tools]] |
| [[AGENTS/]]                      | AI CLI agents                  | [[AI-CLI-Agents]] - 8 tools documented                           |

---

## System Overview

```mermaid
graph TB
    subgraph Hardware["Hardware Profile"]
        CPU[CPU: i7-13650HX<br/>20 cores @ 2.6GHz]
        RAM[RAM: 15GB DDR5<br/>4800MT/s]
        GPU[GPU: RTX 5050 8GB<br/>+ Intel UHD]
        Storage[Storage: 2x NVMe<br/>238GB + 477GB]
    end
    
    subgraph Software["Software Stack"]
        OS[BlackArch Linux]
        DE[Hyprland + Caelestia]
        Shell[Fish Shell]
        Terminal[Foot Terminal]
        Apps[Apps: VSCodium<br/>Neovim, Steam]
    end
    
    subgraph Status["Current Status"]
        MemStatus[RAM: ~8.7GB / 15GB]
        SwapStatus[Swap: 0B<br/>ZRAM enabled]
        CPUStatus[CPU: Variable]
    end
```

## Architecture Flow

### System Components
```mermaid
graph TD
    A[System Boot] --> B[Kernel Loading]
    B --> C[Systemd Init]
    C --> D[Display Manager<br/>SDDM]
    D --> E[Hyprland<br/>Wayland Compositor]
    E --> F[Caelestia<br/>Desktop Shell]
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
    Recon[Reconnaissance<br/>nmap, amass, theHarvester] --> Scan[Scanning<br/>masscan, netcat]
    Scan --> Enum[Enumeration<br/>dirsearch, ffuf, gobuster]
    Enum --> Vuln[Vulnerability<br/>nikto, nuclei, nmap scripts]
    Vuln --> Exploit[Exploitation<br/>metasploit, burpsuite]
    Exploit --> Cracking[Password Attacks<br/>hashcat, john, hydra]
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

## Fix Status Dashboard (Updated 2026-09-10)

```mermaid
flowchart TD
    A[NVIDIA RTX 5050<br/>610.57.04] -->|FIXED| Z[All Green]
    B[GRUB duplicates<br/>+ menu order] -->|FIXED| Z
    C[Caelestia shell removal] -->|FIXED| Z
    D[HDMI nvidia-drm modeset<br/>2026-09-07] -->|FIXED| Z
    E[NFS Heat PRIME offload<br/>Proton GE 11-6] -->|FIXED| Z
    F[Roblox Sober 1.7.1<br/>2026-09-09] -->|INSTALLED| Z
    G[SEO kurmamedia IR<br/>2026-09-07] -->|INVESTIGATED| Z
    H[VSCode Theme Bug<br/>19 files] -->|DOCUMENTED| Z
    Z --> I[Vault indexes refreshed<br/>2026-09-10]
```

## Vault Growth Map

```mermaid
graph LR
    Root[Vault 192 files] --> IR[07-IR<br/>6 files]
    Root --> SYS[System<br/>~70 files]
    Root --> PER[Personal<br/>~40 files]
    Root --> DEV[Development<br/>~23 files]
    Root --> TSK[Tasks<br/>~37 files]
    Root --> AGT[AGENTS<br/>2 files]
    SYS --> FIX[Fixes 11]
    SYS --> INV[Investigation 31]
    SYS --> LIN[Linux 12]
    SYS --> GAM[Gaming 7]
    SYS --> CAE[Caelestia 7]
    TSK --> ECOM[E-Com PBO 10]
    TSK --> CRUD[Laravel CRUD 10]
    TSK --> NAZ[Nazkypedia 10]
    TSK --> RN[React Native 4]
    DEV --> VTB[VSCode Bug 19]
```

## Incident Response Workflow

```mermaid
flowchart LR
    A[SEO Poisoning<br/>kurmamedia.com] --> B{DNS active?<br/>72.61.209.233}
    B -->|Yes| C[HTTP check]
    B -->|No| D[Closed]
    C -->|Timeout| E[Hostinger suspended?]
    C -->|Judi keywords| F[Cloaking confirmed]
    E --> G[Document IoC<br/>01-Mod-Operandus]
    F --> G
    G --> H[Run commands<br/>02-Investigation]
    H --> I[Remediate<br/>03-Hardening]
    I --> J[Checklist<br/>04-Checklist]
    J --> K[Case study<br/>05-kurmamedia]
```

## Gaming Pipeline

```mermaid
flowchart LR
    A[Intel iGPU default<br/>laggy] --> B[Install Proton GE 11-6]
    B --> C[Set compat tool]
    C --> D[Launch flags<br/>PRIME offload]
    D --> E[NVIDIA RTX 5050<br/>8GB renders]
    E --> F[NFS Heat smooth]
    G[Sober Flatpak 1.7.1<br/>org.vinegarhq.Sober] --> H[Wayland Hyprland]
    H --> I[Roblox on Linux<br/>GPU passthrough]
```

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
    A[#archlinux] --> B[#blackarch]
    B --> C[#hyprland]
    C --> D[#wayland]
    D --> E[#caelestia]
    
    F[#performance] --> G[#optimization]
    G --> H[#troubleshooting]
    
    I[#pentesting] --> J[#cybersecurity]
    J --> K[#security]
    
    L[#laravel] --> M[#php]
    M --> N[#backend]
    N --> O[#api]
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