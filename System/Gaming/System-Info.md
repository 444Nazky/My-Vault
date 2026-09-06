# System Information

## Hardware

### Graphics Cards

| Position | GPU | Type | Driver |
|----------|-----|------|--------|
| Primary | Intel UHD Graphics (Raptor Lake) | Integrated | i915 |
| Secondary | NVIDIA RTX 5050 Laptop GPU | Dedicated | 610.57.04 |

```
$ lspci | grep -iE 'vga|3d'
00:02.0 Intel Corporation Raptor Lake-S UHD Graphics
01:00.0 NVIDIA Corporation GB207M [GeForce RTX 5050 Max-Q / Mobile]
```

### NVIDIA Details

```
$ nvidia-smi --query-gpu=name,driver_version,memory.total --format=csv
name, driver_version, memory.total [MiB]
NVIDIA GeForce RTX 5050 Laptop GPU, 610.57.04, 8192 MiB
```

- VRAM: 8GB GDDR6
- Architecture: Ada Lovelace (GB207M)
- Driver: 610.57.04

### System Specs

Get with these commands:

```bash
# CPU
lscpu | grep -E 'Model name|CPU\(s\)|Thread|Core'

# RAM
free -h

# Full system info
inxi -G
```

## Software

### Operating System

- OS: Arch Linux
- Kernel: (run `uname -r` to check)
- Package Manager: pacman

### Installed Gaming Software

| Software | Version | Location |
|----------|---------|----------|
| Steam | 1.0.0.87-1 | Arch repos |
| Proton GE | 11-6 | ~/.steam/steam/compatibilitytools.d/ |
| NVIDIA Driver | 610.57.04 | System |
| Proton (Steam) | Experimental | Built-in |

### Steam Paths

| Path | Purpose |
|------|---------|
| ~/.steam/steam/ | Main Steam directory |
| ~/.steam/steam/compatibilitytools.d/ | Proton installations |
| ~/.local/share/Steam/steamapps/common/ | Game installations |
| ~/.steam/steam/userdata/ | User settings |

### Game Details

| Property | Value |
|----------|-------|
| Game | Need for Speed Heat |
| Steam App ID | 1222680 |
| Install Path | ~/.local/share/Steam/steamapps/common/Need for Speed Heat |
| Type | Windows (via Proton) |
| Anti-Cheat | Easy Anti-Cheat (EAC) |

## Performance Expectations

### RTX 5050 Laptop Expected FPS

| Settings | 1080p FPS |
|----------|-----------|
| Low | 60-90 |
| Medium | 45-60 |
| High | 30-45 |
| Ultra | 20-35 |

NFS Heat is well-optimized. RTX 5050 should handle 1080p medium-high settings.

### Factors That Affect Performance

1. **Power Limit** - Laptop GPUs are capped (usually 60-80W)
2. **Temperatures** - Thermal throttling starts around 83-87C
3. **CPU** - Modern dual or quad core recommended
4. **RAM** - 16GB recommended
5. **Background apps** - Close unnecessary programs

## Check Commands

```bash
# GPU status
nvidia-smi

# GPU temperature
nvidia-smi -q -d TEMPERATURE

# Power limit
nvidia-smi -q -d POWER_LIMIT

# Real-time GPU monitoring
watch -n 1 nvidia-smi

# Display info
xrandr

# Check if NVIDIA is primary
xrandr --listproviders
```

## Proton GE Installation

```
Location: ~/.steam/steam/compatibilitytools.d/GE-Proton11-6
Source: https://github.com/GloriousEggroll/proton-ge-custom
Version: GE-Proton11-6
Installed: 2026-09-02
Size: ~521MB
```

---

Last Updated: 2026-09-02
