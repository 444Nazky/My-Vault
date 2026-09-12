# Vault Overview Diagrams


## Vault Map Top

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'primaryColor': '#2D9CDB', 'primaryTextColor': '#ffffff', 'primaryBorderColor': '#2D9CDB', 'lineColor': '#2D9CDB', 'secondaryColor': '#27AE60', 'tertiaryColor': '#9B51E0'}}}%%
graph TD
 V["Vault 202 files"] -->|contains| SYS["System 77"]
 V -->|contains| ME["Personal & Dev 74"]
 V -->|contains| DO["Work & Ops 45"]
 ME -->|has| PER["Personal 45"]
 ME -->|has| DEV["Development 29"]
 DO -->|has| TSK["Tasks 37"]
 DO -->|has| OPS["IR + Agents 8"]
 OPS -->|has| IR["Incident Response 6"]
 OPS -->|has| AGT["Agents 2"]
 style V fill:#2D9CDB,stroke:#2D9CDB,color:#fff
 style SYS fill:#27AE60,stroke:#27AE60,color:#fff
 style ME fill:#9B51E0,stroke:#9B51E0,color:#fff
 style DO fill:#F2994A,stroke:#F2994A,color:#fff
 style TSK fill:#56CCF2,stroke:#56CCF2,color:#fff
 style IR fill:#EB5757,stroke:#EB5757,color:#fff
```

## System Folders

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'primaryColor': '#2D9CDB', 'lineColor': '#2D9CDB'}}}%%
graph TD
 SYS["System 77"] --> FIX["Fixes 11"]
 SYS --> DSK["Desktop 39"]
 SYS --> PLT["Platform 20"]
 DSK --> CAE["Caelestia 7"]
 DSK --> INV["Investigation 31"]
 DSK --> DSP["Display 1"]
 PLT --> LIN["Linux 12"]
 PLT --> GAM["Gaming 7"]
 PLT --> NEW["Sober Roblox 1"]
 style SYS fill:#2D9CDB,stroke:#2D9CDB,color:#fff
 style FIX fill:#27AE60,stroke:#27AE60,color:#fff
 style INV fill:#EB5757,stroke:#EB5757,color:#fff
 style CAE fill:#BB6BD9,stroke:#BB6BD9,color:#fff
 style LIN fill:#56CCF2,stroke:#56CCF2,color:#fff
 style GAM fill:#F2994A,stroke:#F2994A,color:#fff
```

## Other Folders

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'primaryColor': '#2D9CDB', 'lineColor': '#2D9CDB'}}}%%
graph TD
 PER["Personal 45"] --> SEC["Security 22"]
 PER --> NOTE["Notes 23"]
 NOTE --> DVC["Device 9"]
 NOTE --> SCH["School 3"]
 NOTE --> SES["Sessions & Sheets 11"]
 DEV["Development 29"] --> CODE["Code guides 3"]
 DEV --> VTB["Theme Bug 18"]
 DEV --> PL["Languages 8"]
 TSK["Tasks 37"] --> LAV["Laravel 20"]
 TSK --> FRONT["Frontend 14"]
 FRONT --> NAZ["Nazkypedia 10"]
 FRONT --> RN["React Native 4"]
 style PER fill:#9B51E0,stroke:#9B51E0,color:#fff
 style SEC fill:#EB5757,stroke:#EB5757,color:#fff
 style DEV fill:#2D9CDB,stroke:#2D9CDB,color:#fff
 style TSK fill:#56CCF2,stroke:#56CCF2,color:#fff
 style LAV fill:#F2994A,stroke:#F2994A,color:#fff
 style FRONT fill:#BB6BD9,stroke:#BB6BD9,color:#fff
```

## Fix Status Dashboard

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'primaryColor': '#27AE60', 'lineColor': '#27AE60'}}}%%
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
 style A fill:#27AE60,stroke:#27AE60,color:#fff
 style B fill:#27AE60,stroke:#27AE60,color:#fff
 style C fill:#27AE60,stroke:#27AE60,color:#fff
 style D fill:#27AE60,stroke:#27AE60,color:#fff
 style E fill:#27AE60,stroke:#27AE60,color:#fff
 style F fill:#27AE60,stroke:#27AE60,color:#fff
 style G fill:#27AE60,stroke:#27AE60,color:#fff
 style H fill:#27AE60,stroke:#27AE60,color:#fff
 style Z fill:#2D9CDB,stroke:#2D9CDB,color:#fff
```

## Timeline

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'primaryColor': '#2D9CDB', 'secondaryColor': '#27AE60', 'tertiaryColor': '#F2C94C', 'lineColor': '#2D9CDB'}}}%%
gantt
 dateFormat YYYY-MM-DD
 title Vault Timeline
 section Aug
 Caelestia session and lag fix :done, 2026-08-29, 2d
 section Sep 07
 Niri Haku Setup :done, 2026-09-07, 1d
 HDMI Fix NVIDIA Wayland :done, 2026-09-07, 1d
 SEO IR kurmamedia :done, 2026-09-07, 1d
 section Sep 09
 Terminal Config Backup :done, 2026-09-09, 1h
 Roblox Sober Install :done, 2026-09-09, 1h
 section Sep 10
 Vault Index Refresh :done, 2026-09-10, 1h
 Graph split per topic :done, 2026-09-10, 2h
 Tag cleanup :done, 2026-09-10, 1h
 section Sep 11
 Language families :done, 2026-09-11, 2h
 MacBook plans :done, 2026-09-11, 1h
 LLM setup note :done, 2026-09-11, 30m
 section This Week
 Arch Migration :done, 2026-08-25, 2d
 BlackArch Setup :done, 2026-08-27, 4h
 Gaming Config :done, 2026-08-29, 2h
```

## Tag Web

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'primaryColor': '#2D9CDB', 'lineColor': '#2D9CDB'}}}%%
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
 style ARCH fill:#2D9CDB,stroke:#2D9CDB,color:#fff
 style BLACK fill:#9B51E0,stroke:#9B51E0,color:#fff
 style HYP fill:#56CCF2,stroke:#56CCF2,color:#fff
 style WAY fill:#BB6BD9,stroke:#BB6BD9,color:#fff
 style CAE fill:#F2994A,stroke:#F2994A,color:#fff
 style PERF fill:#27AE60,stroke:#27AE60,color:#fff
 style OPT fill:#27AE60,stroke:#27AE60,color:#fff
 style FIXG fill:#27AE60,stroke:#27AE60,color:#fff
 style PENT fill:#EB5757,stroke:#EB5757,color:#fff
 style CYB2 fill:#EB5757,stroke:#EB5757,color:#fff
 style SEC fill:#EB5757,stroke:#EB5757,color:#fff
 style LAR fill:#56CCF2,stroke:#56CCF2,color:#fff
 style PHP fill:#56CCF2,stroke:#56CCF2,color:#fff
 style GAME2 fill:#F2994A,stroke:#F2994A,color:#fff
 style NV2 fill:#F2994A,stroke:#F2994A,color:#fff
 style PROTON fill:#F2994A,stroke:#F2994A,color:#fff
 style IR2 fill:#EB5757,stroke:#EB5757,color:#fff
 style SEO2 fill:#EB5757,stroke:#EB5757,color:#fff
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
%%{init: {'theme': 'default', 'themeVariables': { 'primaryColor': '#2D9CDB', 'lineColor': '#2D9CDB'}}}%%
flowchart TD
 NEWB["new here"] -->|read| README2["read README first"]
 README2 -->|open| MAP2["open Map of Content"]
 MAP2 -->|pick| TOPIC["pick a topic folder"]
 TOPIC -->|read| NOTE2["read the note"]
 NOTE2 -->|see| GRAPHS2["see Graphs index for diagrams"]
 style NEWB fill:#9B51E0,stroke:#9B51E0,color:#fff
 style README2 fill:#2D9CDB,stroke:#2D9CDB,color:#fff
 style MAP2 fill:#2D9CDB,stroke:#2D9CDB,color:#fff
 style TOPIC fill:#56CCF2,stroke:#56CCF2,color:#fff
 style NOTE2 fill:#BB6BD9,stroke:#BB6BD9,color:#fff
 style GRAPHS2 fill:#27AE60,stroke:#27AE60,color:#fff
```

## Tags
#note-vault-overview
