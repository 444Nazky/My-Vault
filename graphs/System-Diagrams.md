# System Diagrams


## Full Boot Chain

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'primaryColor': '#2D9CDB', 'lineColor': '#2D9CDB'}}}%%
flowchart TD
 P["Power On"] --> UEFI["UEFI Firmware"]
 UEFI --> UKI["UKI Unified Kernel"]
 UEFI --> GRUB["GRUB menu"]
 UKI --> K["Kernel & initramfs"]
 GRUB --> K
 K --> SYSD["systemd"]
 SYSD --> SDDM["SDDM"]
 SDDM --> HYP["Hyprland Wayland"]
 HYP --> CAE["Caelestia Shell"]
 HYP --> DRM["nvidia drm modeset"]
 DRM --> GPU["RTX 5050"]
 CAE --> APP["Apps"]
 style P fill:#9B51E0,stroke:#9B51E0,color:#fff
 style UKI fill:#2D9CDB,stroke:#2D9CDB,color:#fff
 style K fill:#2D9CDB,stroke:#2D9CDB,color:#fff
 style HYP fill:#56CCF2,stroke:#56CCF2,color:#fff
 style CAE fill:#BB6BD9,stroke:#BB6BD9,color:#fff
 style GPU fill:#F2994A,stroke:#F2994A,color:#fff
 style APP fill:#27AE60,stroke:#27AE60,color:#fff
```

## NVIDIA Driver Fix Pipeline

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'primaryColor': '#EB5757', 'lineColor': '#EB5757'}}}%%
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
 style A fill:#EB5757,stroke:#EB5757,color:#fff
 style Z fill:#EB5757,stroke:#EB5757,color:#fff
 style C fill:#F2994A,stroke:#F2994A,color:#fff
 style D fill:#F2994A,stroke:#F2994A,color:#fff
 style M fill:#27AE60,stroke:#27AE60,color:#fff
 style I fill:#27AE60,stroke:#27AE60,color:#fff
 style L fill:#27AE60,stroke:#27AE60,color:#fff
```

## HDMI Monitor Fix

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'primaryColor': '#F2C94C', 'lineColor': '#F2C94C'}}}%%
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
 style A fill:#F2C94C,stroke:#F2C94C,color:#000
 style C fill:#F2C94C,stroke:#F2C94C,color:#000
 style K fill:#27AE60,stroke:#27AE60,color:#fff
 style L fill:#27AE60,stroke:#27AE60,color:#fff
```

## GRUB Menu Before After

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'primaryColor': '#2D9CDB', 'lineColor': '#2D9CDB'}}}%%
graph LR
 subgraph BEFORE["Before - 7 entries"]
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
 subgraph AFTER["After - 3 entries"]
 B1["BlackArch"]
 B2["Windows Boot Manager"]
 B3["UEFI last"]
 end
 BEFORE -->|apply| FIXG
 FIXG -->|result| AFTER
 style BEFORE fill:#EB5757,stroke:#EB5757,color:#fff
 style FIXG fill:#F2C94C,stroke:#F2C94C,color:#000
 style AFTER fill:#27AE60,stroke:#27AE60,color:#fff
```

## Hyprland Caelestia Config

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'primaryColor': '#56CCF2', 'lineColor': '#56CCF2'}}}%%
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
 style HCONF fill:#2D9CDB,stroke:#2D9CDB,color:#fff
 style LUA fill:#56CCF2,stroke:#56CCF2,color:#fff
 style SHELL fill:#BB6BD9,stroke:#BB6BD9,color:#fff
 style HYP fill:#F2994A,stroke:#F2994A,color:#fff
```

## Caelestia Performance Investigation

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'primaryColor': '#F2C94C', 'lineColor': '#F2C94C'}}}%%
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
 style A fill:#F2C94C,stroke:#F2C94C,color:#000
 style B fill:#F2C94C,stroke:#F2C94C,color:#000
 style C fill:#EB5757,stroke:#EB5757,color:#fff
 style D fill:#EB5757,stroke:#EB5757,color:#fff
 style E fill:#EB5757,stroke:#EB5757,color:#fff
 style F fill:#EB5757,stroke:#EB5757,color:#fff
 style K fill:#27AE60,stroke:#27AE60,color:#fff
```

## Trackpad Sensitivity Fix

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'primaryColor': '#56CCF2', 'lineColor': '#56CCF2'}}}%%
flowchart LR
 A["list devices"] --> B["find touchpad"]
 B --> C["edit input lua"]
 C --> D["reload Hyprland"]
 D --> E["test speed"]
 E --> F["done"]
 style A fill:#2D9CDB,stroke:#2D9CDB,color:#fff
 style F fill:#27AE60,stroke:#27AE60,color:#fff
```

## Device Hardware Map

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'primaryColor': '#9B51E0', 'lineColor': '#9B51E0'}}}%%
graph TB
 CPU["fast Intel CPU"] --> OS["BlackArch Hyprland"]
 RAM["15GB DDR5"] --> OS
 GPU1["Intel iGPU"] --> PRIME["PRIME offload"]
 GPU2["RTX 5050 8GB"] --> PRIME
 PRIME --> GAME["games render"]
 NV1["Linux NVMe"] --> BOOT["boot menu"]
 NV2["Windows NVMe"] --> BOOT
 BOOT --> OS
 style CPU fill:#2D9CDB,stroke:#2D9CDB,color:#fff
 style OS fill:#BB6BD9,stroke:#BB6BD9,color:#fff
 style GPU2 fill:#F2994A,stroke:#F2994A,color:#fff
 style PRIME fill:#56CCF2,stroke:#56CCF2,color:#fff
 style GAME fill:#27AE60,stroke:#27AE60,color:#fff
 style BOOT fill:#F2C94C,stroke:#F2C94C,color:#000
```

## ZRAM Swap Flow

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'primaryColor': '#2D9CDB', 'lineColor': '#2D9CDB'}}}%%
flowchart TD
 PRESS["memory pressure"] --> ZRAMQ{"zram ready"}
 ZRAMQ -->|"yes"| COMP2["compress in RAM"]
 ZRAMQ -->|"no"| DISK2["disk swap"]
 COMP2 --> FAST["fast reclaim"]
 DISK2 --> SLOWD["slow reclaim"]
 style PRESS fill:#F2C94C,stroke:#F2C94C,color:#000
 style ZRAMQ fill:#F2C94C,stroke:#F2C94C,color:#000
 style COMP2 fill:#2D9CDB,stroke:#2D9CDB,color:#fff
 style FAST fill:#27AE60,stroke:#27AE60,color:#fff
 style DISK2 fill:#EB5757,stroke:#EB5757,color:#fff
 style SLOWD fill:#EB5757,stroke:#EB5757,color:#fff
```

## Slow System Triage

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'primaryColor': '#F2C94C', 'lineColor': '#F2C94C'}}}%%
flowchart TD
 SLOW2["system slow"] --> CPUQ{"cpu high"}
 CPUQ -->|"yes"| HTOP["check htop"]
 CPUQ -->|"no"| MEMQ{"ram full"}
 MEMQ -->|"yes"| FREE["check free and swap"]
 MEMQ -->|"no"| DISKQ["check disk IO"]
 style SLOW2 fill:#EB5757,stroke:#EB5757,color:#fff
 style CPUQ fill:#F2C94C,stroke:#F2C94C,color:#000
 style MEMQ fill:#F2C94C,stroke:#F2C94C,color:#000
```

## Service Cleanup

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'primaryColor': '#56CCF2', 'lineColor': '#56CCF2'}}}%%
flowchart LR
 LIST["list services"] --> USEDQ{"used"}
 USEDQ -->|"no"| STOP["stop and disable"]
 USEDQ -->|"yes"| KEEP["keep running"]
 STOP --> VERIFY["verify boot faster"]
 style LIST fill:#2D9CDB,stroke:#2D9CDB,color:#fff
 style USEDQ fill:#F2C94C,stroke:#F2C94C,color:#000
 style STOP fill:#EB5757,stroke:#EB5757,color:#fff
 style KEEP fill:#27AE60,stroke:#27AE60,color:#fff
 style VERIFY fill:#27AE60,stroke:#27AE60,color:#fff
```

## Tags
#note-system-diagrams
