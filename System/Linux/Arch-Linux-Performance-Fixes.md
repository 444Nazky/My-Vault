# Arch Linux Performance Fixes

Performance optimizations for Arch Linux systems.

## System Performance

### Kernel Parameters

Add to `/etc/sysctl.d/99-performance.conf`:

```
# VM Settings
vm.swappiness=10
vm.vfs_cache_pressure=50
vm.dirty_ratio=15
vm.dirty_background_ratio=5

# Network
net.core.rmem_max=134217728
net.core.wmem_max=134217728
```

Apply with: `sudo sysctl --system`

### Early OOM Killer

Adjust in `/etc/sysctl.d/99-oom.conf`:

```
vm.oom_dump_tasks=1
vm.oom_kill_allocating_task=0
```

## Desktop Performance

### Hyprland Optimizations

Edit `~/.config/hypr/hyprland.conf`:

```
# Disable animations for performance
animations {
    enabled = false
}

# Reduce blur effects
decoration {
    blur {
        enabled = false
    }
}

# Disable shadows
general {
    gaps_out = 0
    gaps_in = 0
}
```

### Graphics

For NVIDIA in `/etc/environment`:

```
__GL_YIELD=USLEEP
__GL_THREADED_OPTIMIZATION=1
__GL_SHADER_DISK_CACHE=1
```

## CPU Performance

### CPU Governor

Install `cpupower`: `sudo pacman -S cpupower`

Set to performance mode:

```bash
# For current session
sudo cpupower frequency-set -g performance

# Persistent
sudo systemctl enable cpupower
```

Edit `/etc/default/cpupower`:

```
GOVERNOR='performance'
```

### Thermal Settings

Check thermals: `sensors`

Monitor: `watch -n 1 sensors`

## Memory Optimization

### ZRAM

Install: `yay -S zram-generator`

Create `/etc/systemd/zram-generator.conf`:

```
[zram0]
zram-size = ram * 2
compression-algorithm = zstd
```

### Disable Unnecessary Services

Check running: `systemctl list-units --type=service --state=running`

Common to disable:
- `bluetooth` (if unused)
- `cups` (if no printer)
- `mariadb` (if not used)

Disable: `sudo systemctl disable --now <service>`

## Disk Performance

### TRIM for SSDs

Check if supported: `hdparm -I /dev/sda | grep TRIM`

Enable weekly TRIM:

```bash
sudo systemctl enable fstrim.timer
```

### Noatime

Add to `/etc/fstab` for root partition:

```
UUID=xxx / ext4 noatime,errors=remount-ro 0 1
```

## Network Optimization

### DNS Cache

Install `dnsmasq`: `sudo pacman -S dnsmasq`

Enable: `sudo systemctl enable --now dnsmasq`

### TCP BBR

Add to `/etc/sysctl.d/99-bbr.conf`:

```
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
```

## Browser Performance

### Chrome/Chromium Flags

```
--enable-features=VaapiVideoDecoder
--ignore-gpu-blocklist
--enable-gpu-rasterization
```

### Firefox

Set `about:config`:
- `gfx.webrender.all` = true
- `layers.acceleration.force-enabled` = true

## Gaming Performance

### Steam/Proton

Add to game launch options:

```
__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia %command%
```

### NVIDIA Settings

```bash
nvidia-settings -a '[gpu:0]/GpuPowerMizerMode=1'  # Prefer max performance
```

## Process Priority

### Nice Values

Run with higher priority:

```bash
nice -n -10 <command>
```

### cgroups

For persistent game prioritization, configure in systemd.

## Monitoring

### System Monitoring

```bash
# CPU/Memory
htop

# Disk I/O
iotop

# GPU
nvidia-smi -l 1

# Network
nethogs
```

## Related

- [[System Specifications]]
- [[Troubleshooting]]
- [[Hyprland-Optimization]]

---

Tags: #archlinux #linux #performance #optimization
