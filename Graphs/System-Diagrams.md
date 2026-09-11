# System Diagrams

**Part of:** [[00-Graph-Index]]

## Full Boot Chain

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

## NVIDIA Driver Fix Pipeline

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

## HDMI Monitor Fix

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

## GRUB Menu Before After

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

## Hyprland Caelestia Config

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

## Caelestia Performance Investigation

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

## Trackpad Sensitivity Fix

```mermaid
flowchart LR
    A["list devices"] --> B["find touchpad"]
    B --> C["edit input lua"]
    C --> D["reload Hyprland"]
    D --> E["test speed"]
    E --> F["done"]
```

Repeat edit plus reload until the speed feels right.

## Device Hardware Map

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

Tags: #graph #system
