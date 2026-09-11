# Vault Overview Diagrams

**Part of:** [[00-Graph-Index]]

## Vault Map Top

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

## System Folders

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

## Other Folders

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

## Fix Status Dashboard

```mermaid
flowchart TD
    A["NVIDIA driver"] -->|"fixed"| Z["All Green"]
    B["GRUB menu"] -->|"fixed"| Z
    C["Caelestia shell"] -->|"fixed"| Z
    D["HDMI drm output"] -->|"fixed"| Z
    E["NFS Heat PRIME"] -->|"fixed"| Z
    F["Sober install"] -->|"done"| Z
    G["SEO investigation"] -->|"done"| Z
    H["Theme bug docs"] -->|"done"| Z
    Z --> I["indexes refreshed"]
```

## Timeline

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

## Tag Web

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

## Fix Status Pie

```mermaid
pie title Fix completion
    "NVIDIA driver" : 20
    "GRUB menu" : 20
    "HDMI drm" : 20
    "Gaming PRIME" : 15
    "Sober install" : 15
    "SEO investigated" : 10
```

## Notes Per Folder

```mermaid
pie title Notes per folder
    "System" : 77
    "Personal" : 45
    "Tasks" : 37
    "Development" : 29
    "Incident Response" : 6
    "AGENTS" : 2
    "Root" : 6
```

## How to Navigate

```mermaid
flowchart TD
    NEWB["new here"] --> README2["read README first"]
    README2 --> MAP2["open Map of Content"]
    MAP2 --> TOPIC["pick a topic folder"]
    TOPIC --> NOTE2["read the note"]
    NOTE2 --> GRAPHS2["see Graphs index for diagrams"]
```

Tags: #graph #overview
