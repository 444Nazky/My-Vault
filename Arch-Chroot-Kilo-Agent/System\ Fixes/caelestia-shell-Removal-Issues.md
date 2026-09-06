# caelestia-shell Removal Issues

**Date:** 2026-09-06

**What Happened:**
1. **GRUB Disappeared:** Removing caelestia-shell did not delete Arch Linux or files, but if the package or its update hook modified system packages, kernel targets, or boot configurations, or if an incomplete `yay -Syu` transaction occurred during removal, GRUB lost track of boot entries in NVRAM/EFI.

2. **Hyprland Broke:** Hyprland desktop configuration was directly dependent on caelestia-shell for its graphical interface (top bar, launcher, control center). Uninstalling it left Hyprland with missing UI binaries and custom assets.

3. **Btrfs Mounting Error:** When attempting to repair the system via the Live ISO, standard mounting failed because the Arch partition uses Btrfs subvolumes (`@`, `@home`). Mounting the partition raw instead of targeting the `@` subvolume prevented `arch-chroot` from finding `/proc` and system directories.

4. **Kilo CLI Error:** The `EEXIST` error occurred because the binary `/usr/bin/kilo` was already present from a previous installation attempt or package manager pull.

**Should You Avoid Removing It in the Future?**
No, but handle desktop shells and core UI packages with extra caution.

**Identify Dependencies First:**
Desktop shells like Caelestia handle crucial UI functions. Removing them removes your primary session manager and panel setup unless you have a fallback desktop or bar (like Waybar or Rofi) configured.

**Avoid Canceling Updates Mid-Transaction:**
Removing or conflicting packages during a full system upgrade (`yay -Syu`) can leave package states or system hooks partially configured.

**Advice for Future Management:**
- **Keep a Fallback Environment:** Maintain a simple secondary desktop environment or bare-bones Hyprland config (with standard tools like `waybar` or `kitty`) so you retain a working graphical desktop if your main shell breaks.
- **Use Btrfs Snapshots:** Since the system uses Btrfs, set up `snapper` or `timeshift` with `grub-btrfs`. If a package update breaks the system in the future, you can instantly rollback to a working snapshot directly from the GRUB menu without needing a Live ISO USB.
- **Handle AUR Conflicts Safely:** When `yay` reports package conflicts during an upgrade, check if one package is simply replacing another as an updated dependency before choosing to remove or overwrite core system components.