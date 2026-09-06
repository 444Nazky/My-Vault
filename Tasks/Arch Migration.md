# Arch Migration

## Overview
Migration notes and checklist for Arch Linux system setup and configuration.

## Pre-Migration Checklist

### Backup
- Backup all dotfiles
- Export package list: `pacman -Qq > pkglist.txt`
- Backup system configuration files
- Export user configurations

### Partition Strategy
- 238GB NVMe: Root partition (Btrfs)
- 477GB NVMe: Home partition (Btrfs)
- EFI partition: 512MB
- Swap: ZRAM (compressed in-memory)

### Key Packages
```
base base-devel linux linux-firmware
sudo vim git curl wget
hyprland waybar foot dolphin
firefox vscodium-bin
```

## Installation Steps

### 1. Boot Preparation
- Create bootable USB with Arch ISO
- Disable Secure Boot or sign kernel
- Connect to network

### 2. Partition Setup
```bash
lsblk
cfdisk /dev/nvme0n1  # 238GB drive
cfdisk /dev/nvme1n1  # 477GB drive
```

### 3. Base Installation
```bash
pacstrap /mnt base base-devel linux linux-firmware
pacstrap /mnt vim git curl wget sudo
pacstrap /mnt networkmanager wpa_supplicant
pacstrap /mnt hyprland waybar foot dolphin
```

### 4. Post-Install Configuration
- Generate fstab: `genfstab -U /mnt >> /mnt/etc/fstab`
- Chroot into system: `arch-chroot /mnt`
- Set timezone, locale, hostname
- Install bootloader (systemd-boot or GRUB)

## Post-Migration

### Restore Configurations
- Copy dotfiles from backup
- Restore package list: `pacman -S $(cat pkglist.txt)`
- Configure desktop environment

### Verify Installation
- Check network connectivity
- Verify graphics acceleration
- Test audio output
- Confirm disk mounting

## Tags
#archlinux #migration #installation #system
