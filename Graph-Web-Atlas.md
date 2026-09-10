# Graph Web Atlas

**Last Updated:** 2026-09-10
**Vault:** 202 notes
**Purpose:** one page with all explanatory diagrams. Index: [[Map of Content]].

Diagram rules used here: strict trees or stars, max 4 outgoing edges per node, plain word labels, flow only downstream.

---

## 1. Vault Map Top

```mermaid
graph TD
    V["Vault 202 files"] --> SYS["System 77"]
    V --> ME["Personal and Dev 74"]
    V --> DO["Work and Ops 45"]
    ME --> PER["Personal 45"]
    ME --> DEV["Development 29"]
    DO --> TSK["Tasks 37"]
    DO --> OPS["IR plus Agents 8"]
    OPS --> IR["Incident Response 6"]
    OPS --> AGT["Agents 2"]
```

## 2. System Folders

```mermaid
graph TD
    SYS["System 77"] --> FIX["Fixes 11"]
    SYS --> DSK["Desktop 39"]
    SYS --> PLT["Platform 20"]
    DSK --> CAE["Caelestia 7"]
    DSK --> INV["Investigation 31"]
    DSK --> DSP["Display Server 1"]
    PLT --> LIN["Linux 12"]
    PLT --> GAM["Gaming 7"]
    PLT --> NEW["Sober Roblox 1"]
```

## 3. Other Folders

```mermaid
graph TD
    PER["Personal 45"] --> SEC["Security 22"]
    PER --> NOTE["Notes 23"]
    NOTE --> DVC["Device 9"]
    NOTE --> SCH["School 3"]
    NOTE --> SES["Sessions and Sheets 11"]
    DEV["Development 29"] --> CODE["Code guides 3"]
    DEV --> VTB["Theme Bug 18"]
    DEV --> PL["Languages 8"]
    TSK["Tasks 37"] --> LAV["Laravel 20"]
    TSK --> FRONT["Frontend 14"]
    TSK --> ROOT["Root guides 3"]
    LAV --> ECOM["Ecommerce PBO 10"]
    LAV --> CRUD["Laravel CRUD 10"]
    FRONT --> NAZ["Nazkypedia 10"]
    FRONT --> RN["React Native 4"]
```

## 4. Full Boot Chain

```mermaid
flowchart TD
    P["Power On"] --> UEFI["UEFI Firmware"]
    UEFI --> UKI["UKI Unified Kernel"]
    UEFI --> GRUB["GRUB menu"]
    UKI --> K["Kernel and initramfs"]
    GRUB --> K
    K --> SYSD["systemd"]
    SYSD --> SDDM["SDDM"]
    SDDM --> HYP["Hyprland Wayland"]
    HYP --> CAE["Caelestia Shell"]
    HYP --> DRM["nvidia drm modeset"]
    DRM --> GPU["RTX 5050"]
    CAE --> APP["Apps"]
```

## 5. NVIDIA Driver Fix Pipeline

```mermaid
flowchart TD
    A["driver fails"] --> B{"GPU visible"}
    B -->|"no"| Z["hardware fault"]
    B -->|"yes"| C["module load fails"]
    C --> D["DKMS broken"]
    D --> E["clear DKMS dir"]
    E --> F["reinstall driver"]
    F --> G["build DKMS module"]
    G --> H["load module"]
    H --> I["smi check OK"]
    I --> J["update env lua"]
    J --> K["update initramfs config"]
    K --> L["rebuild and reboot"]
    L --> M["fixed"]
```

## 6. HDMI Monitor Fix

```mermaid
flowchart TD
    A["HDMI missing"] --> B["driver OK but no output"]
    B --> C{"drm module loaded"}
    C -->|"absent"| D["UKI ignores grub config"]
    C -->|"absent"| E["bumblebee blocks nvidia"]
    D --> F["write kernel cmdline"]
    E --> G["disable bumblebee"]
    G --> H["set drm modeset option"]
    F --> I["rebuild initramfs"]
    H --> I
    I --> J["load drm module"]
    J --> K["monitor appears"]
    K --> L["reboot to verify"]
```

Detail: cmdline gets the modeset flag, bumblebee conf is disabled, then modprobe loads drm at once.

## 7. GRUB Menu Before After

```mermaid
graph LR
    subgraph BEFORE["Before seven entries"]
        A1["UEFI first"]
        A2["Arch duplicate"]
        A3["Advanced"]
        A4["BlackArch"]
        A5["Windows duplicate"]
    end
    subgraph FIXG["Fix commands"]
        F1["disable duplicate script"]
        F2["disable os prober"]
        F3["custom Windows entry"]
        F4["move UEFI last"]
    end
    subgraph AFTER["After three entries"]
        B1["BlackArch"]
        B2["Windows Boot Manager"]
        B3["UEFI last"]
    end
    BEFORE --> FIXG
    FIXG --> AFTER
```

## 8. Hyprland Caelestia Config

```mermaid
graph TD
    HCONF["hyprland conf"] --> LUA["hyprland lua"]
    LUA --> ENV["env lua"]
    LUA --> KEYS["keybinds lua"]
    LUA --> RULES["rules lua"]
    LUA --> GEN["general lua"]
    ENV --> SHELL["caelestia shell"]
    KEYS --> SHELL
    RULES --> SHELL
    GEN --> SHELL
    INPUT["input lua"] --> HYP["Hyprland"]
    HYP --> SHELL
    SHELL --> DAEMON["daemon"]
    SHELL --> LAUNCH["quicklauncher"]
```

Config lives under the hypr and caelestia config dirs. Trackpad sensitivity is set in input lua.

## 9. Caelestia Performance Investigation

```mermaid
flowchart TD
    A["lag report"] --> B{"bottleneck"}
    B --> C["RAM swappiness high"]
    B --> D["CPU governor"]
    B --> E["extra services"]
    B --> F["heavy effects"]
    C --> G["tune sysctl"]
    D --> H["tune CPU"]
    E --> I["disable services"]
    F --> J["reduce effects"]
    G --> K["verified faster"]
    H --> K
    I --> K
    J --> K
```

Root causes found: swappiness 100, VFS cache pressure, MariaDB and CUPS running, conflicting network managers.

## 10. Trackpad Sensitivity Fix

```mermaid
flowchart LR
    A["list devices"] --> B["find touchpad"]
    B --> C["edit input lua"]
    C --> D["reload Hyprland"]
    D --> E["test speed"]
    E --> F["done"]
```

Repeat edit plus reload until the speed feels right.

## 11. NFS Heat Gaming Fix

```mermaid
flowchart TD
    A["game laggy on Intel"] --> B["install Proton GE"]
    B --> C["force Proton in Steam"]
    C --> D["set PRIME flags"]
    D --> E["offload render"]
    D --> F["use nvidia GL"]
    E --> H["Nvidia renders"]
    F --> H
    H --> I["smooth game"]
```

Flags used: PRIME offload plus nvidia GL vendor, verified with smi.

## 12. Roblox Sober Install

```mermaid
flowchart LR
    A["want Roblox on Hyprland"] --> B["install Sober flatpak"]
    B --> C["runtime plus Wine bundled"]
    C --> D["desktop entry"]
    C --> E["cli wrapper"]
    E --> F["launch GUI"]
    E --> G["launch game URI"]
    F --> H["Wayland plus GPU OK"]
```

Sober 1 point 7 point 1, 18 point 5 MB, RTX passthrough confirmed.

## 13. Gaming GPU Decision Tree

```mermaid
flowchart TD
    A["game slow"] --> B{"gpu busy"}
    B -->|"no"| C["add PRIME flags"]
    B -->|"yes"| D{"fps still low"}
    D -->|"yes"| E["switch Proton version"]
    D -->|"no"| F["fixed"]
    C --> F
    E --> F
```

Roblox path is covered in section 12.

## 14. SEO Poisoning Kill Chain

```mermaid
flowchart TD
    A["initial access"] --> B["persistence"]
    B --> C["cloaking"]
    C --> D["rewrite rules found"]
    D --> E["spam sitemap found"]
    E --> F["search index poisoned"]
```

Vectors: vulnerable plugin, brute force, malicious upload. Persistence via htaccess, PHP backdoor, cron job, DB hook. Cloaking shows gambling content to Googlebot only.

## 15. IR Remediation Pipeline

```mermaid
flowchart LR
    A["snapshot"] --> B["integrity check"]
    B --> C["isolate site"]
    C --> D["clean core"]
    D --> E["harden"]
    E --> F["reindex"]
    F --> G["checklist done"]
```

## 16. kurmamedia Case Verdict

```mermaid
graph TD
    T["kurmamedia site"] --> DNS["DNS active"]
    T --> HTTP["HTTP timeout"]
    T --> MAP["no sitemap"]
    DNS --> V["verdict suspended"]
    HTTP --> V
    MAP --> V
    V --> N["monitor site"]
```

Hosted on Hostinger Jakarta, DNS resolves but the server serves nothing. Likely suspended or taken down.

## 17. Cybersecurity Toolkit Pipeline

```mermaid
flowchart LR
    A["recon"] --> B["scan"]
    B --> C["enum"]
    C --> D["vuln check"]
    D --> E["exploit"]
    E --> F["crack"]
```

Tools per stage: nmap and amass, masscan, dirsearch and ffuf, nikto and nuclei, metasploit and burpsuite, hashcat and john and sqlmap.

## 18. Web Vuln Tool Web

```mermaid
graph TD
    BURP["Burp proxy"] --> FUZZ["Fuzz payloads"]
    DIR["Dirsearch enum"] --> FUZZ
    FUZZ --> VULN["vuln confirmed"]
    NUC["Nuclei templates"] --> VULN
    SQLI["manual SQLi"] --> SQLMAP["Sqlmap dump"]
    SQLMAP --> VULN
    VULN --> OWASP["Owasp report"]
```

## 19. Laravel CRUD MVC

```mermaid
flowchart LR
    R["routes"] --> C["controller"]
    C --> M["model"]
    M --> DB[("database")]
    C --> V["views"]
    VAL["validation"] --> C
    REL["relations"] --> M
```

Views render from controller data and link back to routes.

## 20. E-Commerce PBO Error Map

```mermaid
flowchart TD
    A["fresh clone"] --> B{"autoload works"}
    B -->|"no"| E02["fix autoload"]
    B -->|"yes"| C{"app key set"}
    C -->|"no"| E03["generate app key"]
    C -->|"yes"| D{"mysqli present"}
    D -->|"no"| E04["install mysqli"]
    D -->|"yes"| E{"driver correct"}
    E -->|"no"| E05["fix driver"]
    E -->|"yes"| F{"db connects"}
    F -->|"no"| E06["fix env"]
    F -->|"yes"| G["migrate and seed"]
    G --> H["verify app"]
```

## 21. Nazkypedia UI Sessions

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
    S1["Session one"] --> NAV["Navbar"]
    S1 --> HERO["Hero"]
    S1 --> FOOT["Footer"]
```

```mermaid
graph TD
    S2["Session two"] --> NAV2["Navbar polish"]
    S2 --> HERO2["Hero polish"]
```

```mermaid
graph TD
    S3["Session three"] --> CART["Cart"]
    S3 --> MOB["Mobile menu"]
    CART --> TEST["Testing"]
    MOB --> TEST
    TEST --> FUT["Future work"]
```

Each session restyles the shared Navbar and Hero components. Colors are Blue Teal Orange plus dark mode.

## 22. React Native Taskmanager

```mermaid
flowchart TD
    A["create expo app"] --> B["start dev server"]
    B --> C["add navigation"]
    C --> D["task CRUD"]
    D --> E["persist storage"]
    E --> F["categories plus priority"]
    F --> G["animations"]
    G --> H["done"]
```

## 23. VSCode Theme Bug Chain

```mermaid
flowchart TD
    A["bad theme plugin"] --> B["settings broken"]
    B --> C["theme renders wrong"]
    C --> D["snapshot extensions"]
    D --> E["manual fix"]
    E --> F["backup plan"]
    F --> G["prevention list"]
    G --> H["compat matrix"]
```

Cause was the APC Customize plugin writing bad alpha colors.

## 24. Spreadsheets Auth Decision

```mermaid
flowchart TD
    A["need sheets API"] --> B{"server to server"}
    B -->|"yes"| C["service account"]
    B -->|"no"| D{"public read only"}
    D -->|"yes"| E["API key"]
    D -->|"no"| F["OAuth login"]
    F --> G["compare and throttle"]
```

## 25. Device Hardware Map

```mermaid
graph TB
    CPU["fast Intel CPU"] --> OS["BlackArch Hyprland"]
    RAM["15GB DDR5"] --> OS
    GPU1["Intel iGPU"] --> PRIME["PRIME offload"]
    GPU2["RTX 5050 8GB"] --> PRIME
    PRIME --> GAME["games render"]
    NV1["Linux NVMe"] --> BOOT["boot menu"]
    NV2["Windows NVMe"] --> BOOT
    BOOT --> OS
```

## 26. School P3 Build Order

```mermaid
flowchart LR
    A["spec"] --> B["database"]
    B --> C["auth"]
    C --> D["product CRUD"]
    D --> E["orders and API"]
    E --> F["frontend pages"]
    F --> G["docs"]
```

## 27. Timeline Web

```mermaid
gantt
    dateFormat  YYYY-MM-DD
    title Vault Timeline
    section Aug
    Caelestia session and lag fix :done, 2026-08-29, 2d
    section Sep 07
    Niri setup            :done, 2026-09-07, 1d
    HDMI fix and SEO IR   :done, 2026-09-07, 1d
    section Sep 09
    Terminal backup and Sober :done, 2026-09-09, 1d
    section Sep 10
    Atlas and index refresh   :done, 2026-09-10, 1d
```

## 28. Tag Web

```mermaid
graph TD
    ARCH["arch"] --> BLACK["blackarch"]
    BLACK --> HYP["hyprland"]
    HYP --> WAY["wayland"]
    WAY --> CAE["caelestia"]
    PERF["perf"] --> OPT["opt"]
    OPT --> FIXG["fix"]
    PENT["pentest"] --> CYB2["cyber"]
    CYB2 --> SEC["sec"]
    LAR["laravel"] --> PHP["php"]
    PHP --> BACK["backend"]
    BACK --> API2["api"]
    GAME2["gaming"] --> NV2["nvidia"]
    NV2 --> PROTON["proton"]
    IR2["incident"] --> SEO2["seo"]
```

## 29. Fix Status Pie

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
