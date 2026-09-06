# Master Map of Content

> **Vault:** Nazky's Knowledge Base
> **Last Updated:** September 2026
> **System:** [[System Hardware Profile|Lenovo 83LY - Arch Linux]]

---

## Quick Navigation

| Section                          | Description                    | Key Notes                                                        |
| -------------------------------- | ------------------------------ | ---------------------------------------------------------------- |
| [[Linux/]]                       | System admin, CLI, BlackArch   | [[System Specifications]], [[CLI Cheatsheet]]                    |
| [[Caelestia-Configuration/]]     | Hyprland + Caelestia shell     | [[Caelestia System Architecture]], [[Caelestia Config Files]]    |
| [[Caelestia-Lag-Investigation/]] | Performance debugging          | [[00 - Investigation Overview]], [[Root Cause - Swappiness 100]] |
| [[Cybersecurity/]]               | Pentesting tools & methodology | [[BlackArch Tools]], [[Blackarch]]                               |
| [[Spreadsheets Auth/]]           | Google Sheets API auth         | [[Spreadsheets Auth]], [[Google Sheets Login API Setup]]         |
| [[Database/]]                    | Laravel database management    | [[Database Management & phpMyAdmin Guide]]                       |
| [[Github/]]                      | Git tutorials                  | [[GitHub - Connect Repository Tutorial]]                         |
| [[Todo/]]                        | Tasks & migration guides       | [[Arch Migration]], [[Arch Linux System Fixes]]                  |
| [[SchoolEvent/]]                 | School project docs            | [[P3]], [[What-to-Create]]                                       |
| [[This Device/]]                 | Device-specific notes          | [[00 - Device Overview]]                                         |
| [[VSCode Theme Bug/]]            | VSCode theme debugging         | [[Bug Report - VSCode Theme Rendering Issue]]                    |
| [[Session-Logs/]]                | Troubleshooting sessions       | [[2026-08-29-Caelestia-Session/]]                                |

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
├── 00 - Master Map of Content.md     <-- YOU ARE HERE
│
├── Linux/
│   ├── System Specifications.md      # Hardware details
│   ├── BlackArch Tools.md            # Security toolkit
│   ├── Hyprland-Optimization.md     # Compositor tuning
│   ├── Chrome-Performance-Guide.md  # Browser optimization
│   ├── ZRAM-Swap-Guide.md          # Memory management
│   └── System-Monitoring-Guide.md   # Resource tracking
│
├── Caelestia-Configuration/          # Desktop environment
│   ├── Caelestia-System-Architecture.md
│   ├── Caelestia-Config-Files-Reference.md
│   └── Hyprland-Keybinds.md
│
├── Cybersecurity/
│   ├── Blackarch/
│   │   ├── BlackArch-Audit.md
│   │   └── BlackArch-Tool-Usage-Cheat-Sheet.md
│   ├── Tools/
│   │   ├── Nmap.md
│   │   ├── Sqlmap.md
│   │   └── Burpsuite.md
│   └── Requierements/
│       └── Owasp.md
│
├── Agent Tasks/
│   ├── Nazkypedia-UI-Improvements/
│   ├── E-Commerce PBO/
│   ├── Laravel-CRUD/
│   └── React-Native-Taskmanager/
│
└── This Device/
    ├── Hardware Specifications.md
    ├── Network Configuration.md
    └── Boot Configuration.md
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