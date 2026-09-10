# Graph Web Atlas

**Last Updated:** 2026-09-10
**Vault:** 192 notes
**Purpose:** one page with all explanatory diagrams. See also [[Web-Links-Hub]], [[Map of Content]], [[README]], [[System/Fixes/Visual-Guides]], [[System/System-Architecture]].

---

## 1. Vault Universe

```mermaid
graph TB
    V[Obsidian Vault<br/>192 files] --> IR[07-Incident Response<br/>SEO 6 files]
    V --> AGT[AGENTS<br/>8 AI CLIs]
    V --> SYS[System<br/>~70 files]
    V --> PER[Personal<br/>~40 files]
    V --> DEV[Development<br/>~23 files]
    V --> TSK[Tasks<br/>~37 files]
    SYS --> FIX[Fixes 11<br/>ALL FIXED]
    SYS --> INV[Caelestia-Investigation 31]
    SYS --> LIN[Linux 12]
    SYS --> GAM[Gaming 7<br/>NFS Heat FIXED]
    SYS --> CAE[Caelestia 7]
    SYS --> DSP[Display-Server<br/>trackpad]
    SYS --> NEW[Sober Roblox<br/>INSTALLED 2026-09-09]
    PER --> CYB[Cybersecurity<br/>22 files]
    PER --> DVC[Device 9]
    PER --> SCH[School P3]
    DEV --> VTB[VSCode Theme Bug 19]
    TSK --> ECOM[E-Commerce PBO 10]
    TSK --> CRUD[Laravel CRUD 10]
    TSK --> NAZ[Nazkypedia 10]
    TSK --> RN[React Native 4]
```

## 2. Full Boot Chain (UKI + GRUB)

```mermaid
flowchart TD
    P[Power On] --> UEFI[UEFI Firmware]
    UEFI --> UKI[UKI Unified Kernel<br/>/etc/kernel/cmdline]
    UEFI --> GRUB[GRUB /boot/grub/grub.cfg]
    UKI --> K[Kernel + initramfs<br/>mkinitcpio -P]
    GRUB --> K
    K --> SYS[systemd]
    SYS --> SDDM[SDDM]
    SDDM --> HYP[Hyprland Wayland]
    HYP --> CAE[Caelestia Shell<br/>QuickShell]
    HYP --> DRM[nvidia-drm modeset=1]
    DRM --> GPU[RTX 5050 610.57.04]
    CAE --> APP[Apps: VSCodium Neovim Steam Sober]
```

Related: [[System/System-Architecture]], [[System/Fixes/GRUB-Configuration]], [[System/Fixes/HDMI-Monitor-Fix-NVIDIA-Wayland]].

## 3. NVIDIA Driver Fix Pipeline

```mermaid
flowchart TD
    A[nvidia-smi fails] --> B{lspci sees GPU?}
    B -->|No| Z[Hardware fault]
    B -->|Yes| C[modprobe nvidia fails]
    C --> D[DKMS broken<br/>/var/lib/dkms/nvidia]
    D --> E[rm -rf DKMS dir]
    E --> F[pacman -S nvidia-open-dkms --overwrite]
    F --> G[dkms install nvidia/610.57.04]
    G --> H[modprobe nvidia]
    H --> I[nvidia-smi OK]
    I --> J[env.lua NVIDIA vars]
    J --> K[mkinitcpio MODULES nvidia]
    K --> L[mkinitcpio -P + reboot]
    L --> M[FIXED]
```

Related: [[System/Fixes/NVIDIA-RTX-5050-Investigation]], [[System/Fixes/NVIDIA-RTX-5050-Fix-Commands]], [[System/Fixes/Quick-Reference]].

## 4. HDMI Monitor Fix (UKI vs GRUB trap)

```mermaid
flowchart TD
    A[HDMI-A-2 missing<br/>Hyprland] --> B[nvidia-smi OK<br/>but drm absent]
    B --> C{lsmod nvidia-drm?}
    C -->|Absent| D[Root cause 1<br/>UKI ignores /etc/default/grub]
    C -->|Absent| E[Root cause 2<br/>bumblebee.conf blacklists nvidia]
    D --> F[Write /etc/kernel/cmdline<br/>root= + nvidia-drm.modeset=1]
    E --> G[mv bumblebee.conf to .disabled]
    G --> H[echo options nvidia-drm modeset=1 to /etc/modprobe.d/nvidia.conf]
    F --> I[mkinitcpio -P]
    H --> I
    I --> J[modprobe nvidia-drm<br/>immediate]
    J --> K[Monitor appears]
    K --> L[reboot verify persistent]
```

Related: [[System/Fixes/HDMI-Monitor-Fix-NVIDIA-Wayland]], [[System/Fixes/README]].

## 5. GRUB Menu Before After

```mermaid
graph LR
    subgraph BEFORE["BEFORE - 7 entries"]
        A1[UEFI first]
        A2[Arch x2 duplicate]
        A3[Advanced]
        A4[BlackArch]
        A5[Windows x2 os-prober]
    end
    subgraph FIX["FIX COMMANDS"]
        F1[chmod -x 10_linux]
        F2[DISABLE_OS_PROBER=true]
        F3[40_custom Windows entry]
        F4[30 to 41_uefi-firmware]
    end
    subgraph AFTER["AFTER - 3 entries"]
        B1[BlackArch]
        B2[Windows Boot Manager]
        B3[UEFI bottom]
    end
    BEFORE --> FIX --> AFTER
```

Related: [[System/Fixes/GRUB-Configuration]], [[System/Fixes/GRUB-Duplicate-Entries]], [[System/Fixes/GRUB-Duplicate-Entries-Fix-Commands]].

## 6. Hyprland Caelestia Config Web

```mermaid
graph TD
    HCONF[hyprland.conf] --> LUA[hyprland.lua]
    LUA --> ENV[env.lua<br/>GBM_BACKEND nvidia-drm]
    LUA --> KEYS[keybinds.lua]
    LUA --> RULES[rules.lua]
    LUA --> GEN[general.lua]
    ENV --> SHELL[caelestia-shell]
    KEYS --> SHELL
    INPUT[input.lua<br/>sensitivity 7.5] --> HYP[Hyprland]
    HYP --> SHELL
    SHELL --> DAEMON[caelestia-daemon]
    SHELL --> LAUNCH[quicklauncher]
    CONF1["~/.config/hypr/"] --> LUA
    CONF2["~/.config/caelestia/hypr/"] --> INPUT
```

Related: [[System/Caelestia/00-Overview]], [[System/Caelestia/Caelestia-Config-Files-Reference]], [[System/Caelestia/Caelestia-Hyprland-Keybinds]], [[System/Display-Server/hyprland-trackpad-sensitivity]].

## 7. Caelestia Performance Investigation

```mermaid
flowchart TD
    A[Lag report<br/>2026-08-30] --> B{Top?}
    B --> C[RAM: swappiness 100<br/>VFS cache pressure]
    B --> D[CPU: governor + Chrome]
    B --> E[Services: MariaDB CUPS<br/>conflicting NM + WiFi]
    B --> F[Hyprland: blur shadow anim]
    C --> G[sysctl tune<br/>swappiness dirty_ratio]
    D --> H[kill tune + governor]
    E --> I[disable MariaDB CUPS<br/>single NM]
    F --> J[reduce blur transparency]
    G --> K[Before vs After<br/>8.7GB stable]
    H --> K
    I --> K
    J --> K
```

Related: [[System/Caelestia-Investigation/00 - Investigation Overview]], [[System/Caelestia-Investigation/Root Cause - Swappiness 100]], [[System/Caelestia-Investigation/Before vs After Comparison]], [[Personal/Session-Logs/2026-08-29-Caelestia-Session/00-Overview]].

## 8. Trackpad Sensitivity Fix

```mermaid
flowchart LR
    A[hyprctl devices] --> B[elan06fa touchpad found]
    B --> C[edit input.lua<br/>hl.device sensitivity 7.5]
    C --> D[hyprctl reload]
    D --> E[Test cursor speed]
    E -->|Too fast slow| C
    E -->|OK| F[DONE]
```

Related: [[System/Display-Server/hyprland-trackpad-sensitivity]].

## 9. NFS Heat Gaming Fix

```mermaid
flowchart TD
    A[NFS Heat laggy<br/>Intel iGPU] --> B[Install Proton GE 11-6<br/>compatibilitytools.d]
    B --> C[Steam Play force GE-Proton]
    C --> D[Launch flags<br/>PRIME offload]
    D --> E[__NV_PRIME_RENDER_OFFLOAD=1]
    D --> F[__GLX_VENDOR_LIBRARY_NAME=nvidia]
    D --> G["%command% keep"]
    E --> H[RTX 5050 renders]
    F --> H
    H --> I[nvidia-smi verify<br/>SMOOTH]
```

Related: [[System/Gaming/README]], [[System/Gaming/The-Problem]], [[System/Gaming/The-Solution]], [[System/Gaming/Launch-Options]], [[System/Gaming/System-Info]].

## 10. Roblox Sober Install

```mermaid
flowchart LR
    A[Want Roblox on Hyprland] --> B[flatpak install org.vinegarhq.Sober 1.7.1]
    B --> C[GNOME runtime 50<br/>18.5 MB + Wine bundled]
    C --> D[Desktop entry<br/>app launcher]
    C --> E["~/.local/bin/sober wrapper<br/>flatpak run"]
    E --> F[sober launch GUI]
    E --> G[sober launch_uri rblox://]
    F --> H[Wayland OK<br/>RTX 5050 passthrough]
```

Related: [[System/roblox-sober-install]], [[System/Gaming/Troubleshooting]].

## 11. Gaming GPU Decision Tree

```mermaid
flowchart TD
    A[Game slow?] --> B{nvidia-smi running process?}
    B -->|No| C[Running on Intel<br/>add PRIME flags]
    B -->|Yes| D{FPS still low?}
    D -->|Yes| E[Check Proton version<br/>use GE 11-6]
    D -->|No| F[Fixed]
    C --> F
    E --> F
    G[Roblox?] --> H[Use Sober flatpak<br/>not Wine manual]
    H --> F
```

## 12. SEO Poisoning Kill Chain

```mermaid
flowchart TD
    A[Initial Access<br/>vuln plugin bruteforce upload] --> B[Persistence<br/>.htaccess PHP eval cron DB hook]
    B --> C[Cloaking<br/>Googlebot sees judi slot<br/>user sees legit]
    C --> D[IoC: rewrite rules<br/>wp-config functions.php]
    D --> E[IoC: sitemap slots casino pkv<br/>display:none links]
    E --> F[Google indexes spam<br/>traffic hijack]
```

Related: [[07-Incident Response/SEO-Poisoning-Analysis/00-SEO-Poisoning-Analysis]], [[07-Incident Response/SEO-Poisoning-Analysis/01-Mod-Operandus-IoC]], [[07-Incident Response/SEO-Poisoning-Analysis/02-Investigation-Commands]].

## 13. IR Remediation Pipeline

```mermaid
flowchart LR
    A[Snapshot<br/>forensics wget md5sum] --> B[Integrity<br/>grep backdoor htaccess diff crontab]
    B --> C[Isolate<br/>maintenance mode]
    C --> D[Clean<br/>replace core reset creds]
    D --> E[Harden<br/>update WAF least-priv]
    E --> F[Re-index<br/>Search Console]
    F --> G[Checklist 04 verified]
```

Related: [[07-Incident Response/SEO-Poisoning-Analysis/03-Remediation-Hardening]], [[07-Incident Response/SEO-Poisoning-Analysis/04-Checklist]].

## 14. kurmamedia Case Verdict

```mermaid
graph TD
    T[kurmamedia.com<br/>2026-09-07] --> DNS[DNS 72.61.209.233<br/>Hostinger Jakarta ACTIVE]
    T --> HTTP[HTTP timeout<br/>NO RESPONSE]
    T --> MAP[sitemap NOT FOUND<br/>Google cache NONE]
    DNS --> V[Verdict: suspended or down<br/>not serving spam now]
    HTTP --> V
    MAP --> V
    V --> N[Monitor + harden<br/>see 03-Remediation]
```

Related: [[07-Incident Response/SEO-Poisoning-Analysis/05-Case-Study-kurmamedia]].

## 15. Cybersecurity Toolkit Pipeline

```mermaid
flowchart LR
    A[Recon<br/>nmap amass theHarvester] --> B[Scan<br/>masscan netcat]
    B --> C[Enum<br/>dirsearch ffuf gobuster]
    C --> D[Vuln<br/>nikto nuclei nmap-scripts]
    D --> E[Exploit<br/>metasploit burpsuite]
    E --> F[Crack<br/>hashcat john hydra sqlmap]
```

Related: [[Personal/Cybersecurity/Tools/Nmap]], [[Personal/Cybersecurity/Tools/Dirsearch]], [[Personal/Cybersecurity/Tools/Nuclei]], [[Personal/Cybersecurity/Tools/Sqlmap]], [[Personal/Cybersecurity/Tools/Burpsuite]].

## 16. Web Vuln Tool Web

```mermaid
graph TD
    BURP[Burpsuite<br/>proxy repeater] --> FUZZ[Fuzzing<br/>ffuf payloads]
    DIR[Dirsearch<br/>wordlist enum] --> FUZZ
    NUC[Nuclei<br/>templates CVE] --> VULN[Vuln confirmed]
    FUZZ --> VULN
    SQLI[SQL injection<br/>manual] --> SQLMAP[Sqlmap<br/>dump automate]
    SQLMAP --> VULN
    VULN --> OWASP[Owasp Top 10<br/>report]
```

Related: [[Personal/Cybersecurity/Tools/cheatsheet]], [[Personal/Cybersecurity/Tools/Fuzzing]], [[Personal/Cybersecurity/Tools/Dirsearch pt2]], [[Personal/Cybersecurity/Tools/SQL injection]], [[Personal/Cybersecurity/Requierements/Owasp]], [[Personal/Cybersecurity/Requierements/Penetration testing]].

## 17. Laravel CRUD MVC Loop

```mermaid
flowchart LR
    R[routes web.php] --> C[ItemController<br/>index store update destroy]
    C --> M[Item.php Model<br/>Eloquent]
    M --> DB[(MySQL<br/>migration)]
    C --> V[views items/<br/>blade forms]
    V --> R
    VAL[Form Requests<br/>Validation] --> C
    REL[Eloquent Relationships] --> M
```

Related: [[Tasks/Laravel-CRUD/Laravel CRUD]], [[Tasks/Laravel-CRUD/Routes]], [[Tasks/Laravel-CRUD/Controller]], [[Tasks/Laravel-CRUD/Model]], [[Tasks/Laravel-CRUD/Migration]], [[Tasks/Laravel-CRUD/Views]], [[Tasks/Laravel-CRUD/Validation]], [[Tasks/Laravel-CRUD/Form Requests]], [[Tasks/Laravel-CRUD/Eloquent Relationships]].

## 18. E-Commerce PBO Error Map

```mermaid
flowchart TD
    A[composer create / clone] --> B{autoload fails?}
    B -->|Yes| E02[02-Error autoload<br/>composer dump-autoload]
    B -->|No| C{app key?}
    C -->|Missing| E03[03-Error App Key<br/>php artisan key:generate]
    C -->|OK| D{mysqli?}
    D -->|Missing| E04[04-Error mysqli<br/>install php-mysqli]
    D -->|OK| E{driver?}
    E -->|Wrong| E05[05-Error Driver<br/>fix DB_CONNECTION]
    E -->|OK| F{connection refused?}
    F -->|Yes| E06[06-Error Connection<br/>.env host port user]
    F -->|No| G[07-Database Setup<br/>migrate seed]
    G --> H[08-Env Config]
    H --> I[09-Verification OK]
```

Related: [[Tasks/E-Commerce PBO/00 - Index]], [[Tasks/E-Commerce PBO/01 - Quick Start]], [[Tasks/E-Commerce PBO/07 - Database Setup]], [[Tasks/E-Commerce PBO/09 - Verification]], [[Tasks/Laravel-CRUD/E-Commerce PBO - Debugging Guide]].

## 19. Nazkypedia UI Sessions

```mermaid
gantt
    dateFormat  YYYY-MM-DD
    title Nazkypedia UI Improvements
    section Session 1
    Global CSS Nav Components :done, 2026-08-01, 3d
    section Session 2
    Navbar Hero Responsive    :done, 2026-08-05, 3d
    section Session 3
    Cart Hamburger Mobile     :done, 2026-08-10, 3d
```

```mermaid
graph TD
    S1[Session-1 overhaul<br/>layout tokens] --> NAV[Navbar]
    S1 --> HERO[Hero]
    S1 --> FOOT[Footer]
    S2[Session-2 fixes] --> NAV
    S2 --> HERO
    S3[Session-3 fixes] --> CART[Cart]
    S3 --> MOB[Hamburger mobile]
    NAV --> COL[Color Blue Teal Orange<br/>dark mode]
    CART --> TEST[Testing-Checklist]
    MOB --> TEST
    TEST --> FUT[Future-Improvements]
```

Related: [[Tasks/Nazkypedia-UI-Improvements/README]], [[Tasks/Nazkypedia-UI-Improvements/Session-1-UI-Overhaul]], [[Tasks/Nazkypedia-UI-Improvements/Session-2-Navbar-Hero-Fixes]], [[Tasks/Nazkypedia-UI-Improvements/Session-3-Cart-Hamburger-Fixes]], [[Tasks/Nazkypedia-UI-Improvements/Color-Scheme]], [[Tasks/Nazkypedia-UI-Improvements/Testing-Checklist]].

## 20. React Native Taskmanager

```mermaid
flowchart TD
    A[create-expo-app TaskManager] --> B[npm start]
    B --> C[Navigation<br/>stack tabs]
    C --> D[CRUD tasks]
    D --> E[AsyncStorage persist]
    D --> F[categories due-dates priority]
    F --> G[Animations]
    G --> H[Backlog done]
```

Related: [[Tasks/React-Native-Taskmanager/PEMBUATAN APLIKASI TASKMANAGER]], [[Tasks/React-Native-Taskmanager/Developer Project Hub & Backlog]], [[Tasks/React-Native-Taskmanager/Animations]], [[Tasks/React-Native-Taskmanager/Technical Cheat Sheet & Command Engine]].

## 21. VSCode Theme Bug Chain

```mermaid
flowchart TD
    A[APC Customize UI++<br/>alpha color edits] --> B[settings.json broken<br/>colorCustomizations]
    B --> C[Theme renders wrong<br/>transparent unreadable]
    C --> D[Snapshot extensions]
    D --> E[Manual fix guide<br/>remove APC keys restore]
    E --> F[Backup strategy]
    F --> G[Prevention checklist]
    G --> H[Compatibility matrix]
```

Related: [[Development/VSCode Theme Bug/00 - Map of Content]], [[Development/VSCode Theme Bug/Bug Report - VSCode Theme Rendering Issue]], [[Development/VSCode Theme Bug/03 - Manual Fix Guide]], [[Development/VSCode Theme Bug/13 - Backup Strategy]].

## 22. Spreadsheets Auth Decision

```mermaid
flowchart TD
    A[Need Sheets API?] --> B{Server to server?}
    B -->|Yes| C[Service Account<br/>no user consent]
    B -->|No| D{Read public only?}
    D -->|Yes| E[API Key<br/>simplest]
    D -->|No| F[OAuth 2.0<br/>user login]
    F --> G[Laravel Eloquent compare<br/>IP throttling]
```

Related: [[Personal/Spreadsheets-Auth/Spreadsheets Auth]], [[Personal/Spreadsheets-Auth/Google Sheets Login API Setup]], [[Personal/Spreadsheets-Auth/Laravel Eloquent Comparison]], [[Personal/Spreadsheets-Auth/IP Throttling]].

## 23. Device Hardware Map

```mermaid
graph TB
    CPU[i7-13650HX<br/>20 cores] --> OS[BlackArch Arch<br/>Hyprland]
    RAM[15GB DDR5] --> OS
    GPU1[Intel UHD<br/>iGPU default] --> PRIME[PRIME offload]
    GPU2[RTX 5050 8GB<br/>610.57.04] --> PRIME
    PRIME --> GAME[NFS Heat + Sober]
    NVME1[nvme1n1 238GB<br/>BlackArch btrfs] --> BOOT[GRUB UKI]
    NVME2[nvme0n1 477GB<br/>Windows NTFS] --> BOOT
    BOOT --> OS
```

Related: [[Personal/Device/00 - Device Overview]], [[Personal/Device/01 - Hardware Specifications]], [[Personal/Device/08 - Boot Configuration]], [[System/Linux/System Specifications]].

## 24. School P3 Build Order

```mermaid
flowchart LR
    A[What-to-Create spec] --> B[DB schema migrate seed]
    B --> C[Laravel auth]
    C --> D[Product CRUD]
    D --> E[Orders + API]
    E --> F[Frontend layout listing detail cart checkout]
    F --> G[P3 docs]
```

Related: [[Personal/School/What-to-Create]], [[Personal/School/P3]], [[Tasks/E-Commerce PBO/00 - Index]].

## 25. Timeline Web

```mermaid
gantt
    dateFormat  YYYY-MM-DD
    title Vault Timeline
    section Aug
    Caelestia session + lag fix :done, 2026-08-29, 2d
    section Sep 07
    Niri setup            :done, 2026-09-07, 1d
    HDMI fix + SEO IR     :done, 2026-09-07, 1d
    section Sep 09
    Terminal backup + Sober :done, 2026-09-09, 1d
    section Sep 10
    Atlas + index refresh   :done, 2026-09-10, 1d
```

## 26. Tag Web

```mermaid
graph TD
    ARCH[#archlinux] --> BLACK[#blackarch]
    BLACK --> HYP[#hyprland]
    HYP --> WAY[#wayland]
    WAY --> CAE[#caelestia]
    PERF[#performance] --> OPT[#optimization]
    OPT --> FIX[#troubleshooting]
    PENT[#pentesting] --> CYB[#cybersecurity]
    CYB --> SEC[#security]
    LAR[#laravel] --> PHP[#php]
    PHP --> BACK[#backend]
    BACK --> API[#api]
    GAME[#gaming] --> NV[#nvidia]
    NV --> PROTON[#proton]
    IR[#incident-response] --> SEO[#seo-poisoning]
```

## 27. Fix Status Pie (2026-09-10)

```mermaid
pie title Fix completion
    "NVIDIA driver" : 20
    "GRUB menu" : 20
    "HDMI drm" : 20
    "Gaming PRIME" : 15
    "Sober install" : 15
    "SEO investigated" : 10
```

Tags: #graph #moc #atlas #diagram #web
