# Master Map of Content

> **Vault:** Nazky's Knowledge Base
> **Last Updated:** September 2026
> **System:** [[System Hardware Profile|Lenovo 83LY - Arch Linux]]

---

## Quick Navigation

| Section                          | Description                    | Key Notes                                                        |
| -------------------------------- | ------------------------------ | ---------------------------------------------------------------- |
| [[System/Linux/]]                | System admin, CLI, BlackArch   | [[System Specifications]], [[CLI Cheatsheet]]                    |
| [[System/Caelestia/]]            | Hyprland + Caelestia shell     | [[Caelestia System Architecture]], [[Caelestia Config Files]]    |
| [[System/Caelestia-Investigation/]] | Performance debugging          | [[00 - Investigation Overview]], [[Root Cause - Swappiness 100]] |
| [[Personal/Cybersecurity/]]      | Pentesting tools & methodology | [[BlackArch Tools]], [[Blackarch]]                               |
| [[Personal/Spreadsheets-Auth/]]  | Google Sheets API auth         | [[Spreadsheets Auth]], [[Google Sheets Login API Setup]]         |
| [[Development/Database/]]        | Laravel database management    | [[Database Management & phpMyAdmin Guide]]                       |
| [[Development/Github/]]          | Git tutorials                  | [[GitHub - Connect Repository Tutorial]]                         |
| [[Tasks/]]                       | Tasks & migration guides       | [[Arch Migration]], [[Arch Linux System Fixes]]                  |
| [[Personal/School/]]             | School project docs            | [[P3]], [[What-to-Create]]                                       |
| [[Personal/Device/]]             | Device-specific notes          | [[00 - Device Overview]]                                         |
| [[Development/VSCode Theme Bug/]] | VSCode theme debugging         | [[Bug Report - VSCode Theme Rendering Issue]]                    |
| [[Personal/Session-Logs/]]       | Troubleshooting sessions       | [[2026-08-29-Caelestia-Session/]]                                |
| [[System/Fixes/]]                | System fixes & guides          | [[NVIDIA-RTX-5050-Investigation]], [[GRUB-Configuration]]        |
| [[System/Gaming/]]               | Gaming setup & troubleshooting | [[System-Info]], [[The-Problem]]                                  |

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
    
    section Sep 9
    Terminal Config Backup :done, 2026-09-09, 30m
    
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

## Folder Structure

```
Obsidian Vault/
├── Map of Content.md     <-- YOU ARE HERE
│
├── System/
│   ├── Linux/            # System admin, CLI, BlackArch
│   │   ├── System Specifications.md
│   │   ├── BlackArch Tools.md
│   │   ├── Hyprland-Optimization.md
│   │   ├── Chrome-Performance-Guide.md
│   │   ├── ZRAM-Swap-Guide.md
│   │   ├── System-Monitoring-Guide.md
│   │   └── CLI Cheatsheet.md
│   ├── Caelestia/        # Desktop environment
│   │   ├── Caelestia System Architecture.md
│   │   ├── Caelestia Config Files.md
│   │   ├── Hyprland Keybinds.md
│   │   ├── Caelestia Lock Settings.md
│   │   ├── Caelestia Modification Guide.md
│   │   └── Hyprland - Reduce Transparency.md
│   ├── Caelestia-Investigation/  # Performance debugging
│   ├── Fixes/            # System fixes
│   ├── Gaming/
│   ├── Display-Server/
│   ├── Starship Installation.md
│   ├── Shell Startup Order.md
│   ├── System-Architecture.md
│   ├── Troubleshooting Steps.md
│   ├── Caelestia Dotfiles Context.md
│   ├── KDE-Plasma-Ricing.md
│   ├── hakuspace-niri-setup-2026-09-07.md
│   └── terminal-config-backup-2026-09-09.md
│
├── Personal/
│   ├── Cybersecurity/
│   │   ├── Blackarch/
│   │   ├── Tools/
│   │   └── Requierements/
│   ├── Device/
│   ├── School/
│   ├── Session-Logs/
│   └── Spreadsheets-Auth/
│
├── Development/
│   ├── Database/
│   ├── Github/
│   ├── VSCode Theme Bug/
│   └── Prompts/
│
└── Tasks/
    ├── Arch Migration.md
    ├── Arch Linux System Fixes.md
    ├── Automated tools.md
    ├── E-Commerce PBO/
    ├── Laravel-CRUD/
    ├── Nazkypedia-UI-Improvements/
    └── React-Native-Taskmanager/
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