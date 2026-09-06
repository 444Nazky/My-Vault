# System Architecture Overview

**Last Updated:** 2026-09-06

---

## BlackArch System Diagram

```mermaid
graph TB
    subgraph Boot["Boot Process"]
        B1[Power On]
        B2[UEFI/BIOS]
        B3[GRUB Menu]
        B4[Linux Kernel]
        B5[Systemd]
        B6[Display Manager]
    end

    subgraph Desktop["Desktop Environment"]
        H[Hyprland<br/>Wayland]
        C[Caelestia Shell<br/>QuickShell]
        W[Waybar<br/>Notifications]
        S[Sidebar<br/>Widgets]
    end

    subgraph Graphics["Graphics Stack"]
        GPU[NVIDIA RTX 5050<br/>nvidia-open-dkms]
        DRI[DRM/DRI]
        GBM[GBM Backend]
    end

    subgraph Audio["Audio"]
        PW[PipeWire]
        PA[PulseAudio]
    end

    B1 --> B2
    B2 --> B3
    B3 --> B4
    B4 --> B5
    B5 --> B6
    B6 --> H
    H --> C
    H --> W
    H --> S
    H --> DRI
    DRI --> GPU
    GBM --> GPU

    style Boot fill:#e6f3ff
    style Desktop fill:#fff3e6
    style Graphics fill:#f0fff0
```

---

## Hyprland Configuration Architecture

```mermaid
graph LR
    subgraph Config["Hyprland Config"]
        A[hyprland.conf<br/>Main config]
        B[hyprland.lua<br/>Lua entry]
        C[env.lua<br/>Environment vars]
        D[keybinds.lua<br/>Keybindings]
        E[rules.lua<br/>Window rules]
        F[general.lua<br/>General settings]
    end

    subgraph Caelestia["Caelestia"]
        G[caelestia-shell]
        H[caelestia-daemon]
        I[quicklauncher]
    end

    subgraph Sources["Config Locations"]
        L1[/home/nazky/.config/hypr/]
        L2[/home/nazky/.config/caelestia/hypr/]
    end

    A --> B
    B --> C
    B --> D
    B --> E
    B --> F

    C --> G
    D --> G
    E --> G
    F --> G

    style Config fill:#e6f3ff
    style Caelestia fill:#fff3e6
    style Sources fill:#f0f0f0
```

---

## Dual Boot Setup

```mermaid
graph TB
    subgraph Boot["GRUB Menu Order"]
        M1[BlackArch]
        M2[Windows Boot Manager]
        M3[UEFI Firmware Settings]
    end

    subgraph Linux["BlackArch (nvme1n1)"]
        L1[EFI Partition<br/>0F61-907D]
        L2[btrfs Root<br/>67fde82c...]
        L3[Swap]
    end

    subgraph Windows["Windows (nvme0n1)"]
        W1[EFI Partition<br/>298C-5E1B]
        W2[NTFS<br/>BCB6C114...]
    end

    M1 --> L1
    L1 --> L2
    L2 --> L3

    M2 --> W1
    W1 --> W2

    M3 --> FW[BIOS Setup]

    style Boot fill:#e6f3ff
    style Linux fill:#ccffcc
    style Windows fill:#ffffcc
```

---

## NVIDIA Wayland Pipeline

```mermaid
sequenceDiagram
    participant App as Application
    participant WL as Wayland
    participant GBM as GBM
    participant NV as NVIDIA Driver
    participant GPU as RTX 5050

    App->>WL: Create surface
    WL->>GBM: Request buffer
    GBM->>NV: Allocate DMA-BUF
    NV-->>GBM: Return buffer
    GBM-->>WL: Buffer ready
    WL-->>App: Surface ready

    Note over GPU: NVIDIA Environment Variables:<br/>GBM_BACKEND=nvidia-drm<br/>NVIDIA_VISIBLE_DEVICES=GPU-0<br/>NVIDIA_DRIVER_CAPABILITIES=all
```

---

## Fix Status Timeline

```mermaid
gantt
    title System Fixes 2026-09-06
    dateFormat  HH-mm
    section NVIDIA
    DKMS Fix           :done, 11:00, 5m
    Driver Install     :done, 11:05, 10m
    env.lua Update     :done, 11:10, 2m
    mkinitcpio Update  :done, 11:12, 2m
    section GRUB
    Disable 10_linux   :done, 11:20, 1m
    OS-Prober Disable  :done, 11:21, 1m
    Windows Entry      :done, 11:22, 5m
    UEFI Order Fix    :done, 11:27, 1m
    Regenerate GRUB    :done, 11:28, 2m
```
