# System Architecture Overview

**Last Updated:** 2026-09-06

---

## BlackArch System Diagram

```mermaid
graph TB
    subgraph Boot["Boot Process"]
        B1[Power On]
        B2[UEFI BIOS]
        B3[GRUB Menu]
        B4[Linux Kernel]
        B5[Systemd]
        B6[Display Manager]
    end

    subgraph Desktop["Desktop Environment"]
        H[Hyprland]
        C[Caelestia Shell]
        W[Waybar]
        S[Sidebar]
    end

    subgraph Graphics["Graphics Stack"]
        GPU["RTX 5050 driver"]
        DRI[DRM stack]
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
        A["hyprland conf main"]
        B["lua entry"]
        C["env vars"]
        D["keybinds"]
        E["window rules"]
        F["general settings"]
    end

    subgraph Caelestia["Caelestia"]
        G[caelestia-shell]
        H[caelestia-daemon]
        I[quicklauncher]
    end

    subgraph Sources["Config Locations"]
        L1["hypr config dir"]
        L2["caelestia config dir"]
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
        L1["EFI Linux"]
        L2["btrfs root"]
        L3[Swap]
    end

    subgraph Windows["Windows (nvme0n1)"]
        W1["EFI Windows"]
        W2["NTFS Windows"]
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

    Note over GPU: env sets GBM backend plus device caps
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
