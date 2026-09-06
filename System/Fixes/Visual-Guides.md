# System Fixes - Visual Guide

**Last Updated:** 2026-09-06

---

## NVIDIA Driver Fix - Flowchart

```mermaid
flowchart TD
    A[Problem: NVIDIA not detected] --> B{PCI Detection?}
    B -->|Yes| C[Driver not loaded]
    B -->|No| Z[GPU Hardware Issue]

    C --> D{modprobe nvidia works?}
    D -->|Failed| E[DKMS Module Broken]
    E --> F[Remove DKMS directory]
    F --> G[Reinstall nvidia-open-dkms]
    G --> H[Rebuild DKMS module]
    H --> I[modprobe nvidia]
    I --> J{nvidia-smi works?}
    J -->|Yes| K[Driver Working]
    J -->|No| L[Check kernel headers]
    L --> M[Reinstall linux-headers]

    D -->|Success| K

    K --> N[Update env.lua]
    N --> O[Update mkinitcpio.conf]
    O --> P[Regenerate initramfs]
    P --> Q[Reboot]
    Q --> R[FIXED]
```

---

## GRUB Fix - Before vs After

```mermaid
graph LR
    subgraph BEFORE["BEFORE"]
        A1[UEFI Firmware Settings]
        A2[Arch Linux]
        A3[Arch Linux]
        A4[Advanced options]
        A5[BlackArch]
        A6[Windows]
        A7[Windows - Recovery]
    end

    subgraph AFTER["AFTER"]
        B1[BlackArch]
        B2[BlackArch - Fallback]
        B3[Windows Boot Manager]
        B4[UEFI Firmware Settings]
    end

    style BEFORE fill:#ffcccc
    style AFTER fill:#ccffcc
```

---

## Boot Process - GRUB Menu Flow

```mermaid
sequenceDiagram
    participant U as User
    participant G as GRUB
    participant L as Linux
    participant W as Windows

    U->>G: Power On
    G->>G: Load /boot/grub/grub.cfg
    Note over G: Scripts execute in order:<br/>10_linux, 20_linux_xen,<br/>30_os-prober, 40_custom, 41_uefi-firmware

    U->>G: Select BlackArch
    G->>L: Load Kernel
    L->>L: Boot Complete

    U->>G: Select Windows Boot Manager
    G->>W: Chainload bootmgfw.efi
    W->>W: Windows Boot
```

---

## Disk Layout Diagram

```mermaid
graph TB
    subgraph nvme1n1["nvme1n1 (238.5G) - BlackArch"]
        A1[nvme1n1p1<br/>1G EFI<br/>UUID: 0F61-907D]
        A2[nvme1n1p2<br/>237.5G btrfs<br/>UUID: 67fde82c...]
    end

    subgraph nvme0n1["nvme0n1 (476.9G) - Windows"]
        B1[nvme0n1p1<br/>1G EFI<br/>UUID: 298C-5E1B]
        B2[nvme0n1p2<br/>475.9G NTFS<br/>UUID: BCB6C114...]
    end

    subgraph sda["sda (57.3G) - Backup"]
        C1[sda1<br/>57.3G exfat]
        C2[sda2<br/>32M Ventoy]
    end

    style nvme1n1 fill:#e6f3ff
    style nvme0n1 fill:#fff3e6
    style sda fill:#f0f0f0
```

---

## NVIDIA Module Loading Sequence

```mermaid
sequenceDiagram
    participant K as Kernel
    participant M as mkinitcpio
    participant D as DKMS
    participant N as NVIDIA Module

    Note over K: Boot Process
    K->>M: Load initramfs
    M->>M: MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
    M->>K: Load NVIDIA modules early

    Note over D: DKMS Build
    D->>D: nvidia/610.57.04 registered
    D->>D: Compiles against kernel headers
    D->>D: Outputs to /lib/modules/$(uname -r)/extra/

    K->>N: modprobe nvidia
    N->>N: Initialize GPU
    N-->>K: GPU Ready

    Note over K: User Space
    K->>N: nvidia-smi
    N-->>K: GPU Info displayed
```

---

## GRUB Script Execution Order

```mermaid
graph TD
    subgraph Scripts["GRUB Scripts in /etc/grub.d/"]
        S1["10_linux<br/>DISABLED"]
        S2["20_linux_xen<br/>Xen kernels"]
        S3["30_os-prober<br/>DISABLED via GRUB_DISABLE_OS_PROBER"]
        S4["40_custom<br/>Windows Boot Manager"]
        S5["41_uefi-firmware<br/>Moved to bottom"]
    end

    subgraph Output["Final GRUB Menu"]
        M1["BlackArch"]
        M2["Windows Boot Manager"]
        M3["UEFI Firmware Settings"]
    end

    S1 -.->|Skipped| M1
    S2 -->|Include| M1
    S3 -.->|Skipped| M2
    S4 -->|Custom entry| M2
    S5 -->|Last| M3

    style S1 fill:#ffcccc
    style S3 fill:#ffcccc
    style M1 fill:#ccffcc
    style M2 fill:#ccffcc
    style M3 fill:#ccffcc
```

---

## System State Summary

```mermaid
pie title Fix Status (2026-09-06)
    "NVIDIA RTX 5050" : 100
    "GRUB Configuration" : 100
    "Secure Boot" : 100
```
