# Waydroid + GAPPS + Play Store Setup

Date: 2026-09-15
System: BlackArch (Arch-based), kernel `7.2.6-arch2-1`, Hyprland (Wayland), Intel UHD + RTX 5050 hybrid GPU.

## What Was Done

Installed Waydroid 1.6.3 (AUR) with the GAPPS (Play Store) image on an Arch/BlackArch box, fixed networking + kernel + ARM app compatibility, and moved it to multi-window mode for Hyprland.

## Key Facts / Decisions

- **Root access**: `sudo` has no password on this box; a wrapper `~/ .local/bin/sudo` → `pkexec sudo` is used so `yay` builds work.
- **Binder**: Kernel 7.2.x uses Rust binder (`CONFIG_ANDROID_BINDER_IPC_RUST=y`) + binderfs. No DKMS module needed. Mounts at `/dev/binderfs` (`anbox-binder`, `anbox-vndbinder`, `anbox-hwbinder`).
- **GPU**: hybrid Intel+NVIDIA requires chmod 777 on `/dev/dri/renderD*`; Waydroid picks the iGPU. Keep the compositor on a single GPU or expect flicker (dual-GPU known issue).

## 1. Install + Networking

- Installed: `lxc`, `python-pyclip`, `waydroid` (AUR), enabled `waydroid-container.service`.
- Container network: LXC veth → `waydroid0` bridge (192.168.240.0/24) → dnsmasq (DHCP + DNS, upstream 127.0.0.53) → NAT → `wlan0`.
- **UFW was the silent breaker** (default DROP): allowed 67/udp, allowed route in on `waydroid0`, allowed DNS to 192.168.240.0/24, and added persistent NAT masquerade in `/etc/ufw/before.rules`:
  ```
  *nat
  :POSTROUTING ACCEPT [0:0]
  -A POSTROUTING -s 192.168.240.0/24 -o wlan0 -j MASQUERADE
  COMMIT
  ```

## 2. Switching to the GAPPS Image (Play Store)

- `waydroid init -s GAPPS` download from SourceForge was **corrupt twice** (hash mismatch vs manifest). Worked around by:
  1. Grabbing latest GAPPS entry + sha256 from `https://ota.waydro.id/system/lineage/waydroid_x86_64/GAPPS.json`.
  2. Downloading with `curl -L -C -` (resumable) from `master.dl.sourceforge.net` (~250 KB/s, ~40 min).
  3. Serving the verified zip from a **local OTA channel** so init imports instead of re-downloading:
     ```
     # /var/tmp/ota/lineage/waydroid_x86_64/GAPPS.json
     {"response": [{"datetime": 1775208984, "filename": "lineage-20.0-20260403-GAPPS-waydroid_x86_64-system.zip",
     "id": "811ab2dd7ad1b0b4964bddf020fa450275ea1af2d5b0ac10d5ceced0ac1908a3", "size": 1190930612,
     "romtype": "GAPPS", "url": "file:///var/tmp/gapps-system.zip", "version": "20.0"}]}
     ```
     then `pkexec waydroid init -s GAPPS -c file:///var/tmp/ota`.
  4. Restored `system_ota` to the real URL afterwards and set `system_type = GAPPS` in `/var/lib/waydroid/waydroid.cfg`.
- Leftover: `/var/tmp/gapps-system.zip` (1.19 GB) — safe to delete; `/var/tmp/ota/` manifest for re-init.

## 3. Kernel Reboot (7.2.3 → 7.2.6)

- After a reboot, Waydroid failed with `Error: Unknown device type` — `ip` could not create the bridge.
- Root cause: booted kernel `7.2.3-arch1-2` had **no module dir in `/lib/modules`** (removed by an update), so `bridge.ko` couldn't load.
- Installed kernel `7.2.6-arch2-1` (has `bridge.ko` + Rust binder). The ESP UKI had already been rebuilt, so a plain reboot picked it up. Booting via UKI at `/boot/EFI/Linux/arch-linux.efi`; grub shows only "Windows" because Linux boots through the UKI (`15_uki`).

## 4. ARM Translation (libndk) — App Availability

- Symptom: "Magic Chess Go Go" (`com.mobilechess.gp`) unavailable in Play Store. It is **ARM-only** (arm64-v8a); Waydroid advertised `x86_64,x86` → Play Store filtered it out.
- Fix (from [casualsnek/waydroid_script](https://github.com/casualsnek/waydroid_script)):
  ```
  git clone https://github.com/casualsnek/waydroid_script /var/tmp/waydroid_script
  cd /var/tmp/waydroid_script && python3 -m venv venv && venv/bin/pip install -r requirements.txt
  pkexec venv/bin/python3 main.py install libndk
  ```
- Result: `ro.product.cpu.abilist = x86_64,x86,arm64-v8a,armeabi-v7a,armeabi`, `ro.dalvik.vm.native.bridge = libndk_translation.so`, libs in `/var/lib/waydroid/overlay/system/`.
- **Note**: libndk (Google guybrush) chosen over libhoudini (better on Intel) because 2025/2026 libhoudini builds have a hard-coded expiry. Reinstall libndk after any `waydroid init` image update.

## 5. Hyprland: Multi-Window Mode (resize/portrait/tiling)

- Symptom: full-UI window was fixed-size — wouldn't rotate to portrait or adapt when tiled beside other windows.
- Fix: `waydroid prop set persist.waydroid.multi_windows true` (must be set **while the session is running**, then restart container). Apps now open as resizable, tileable windows; portrait apps respect their orientation.
- Fallbacks if a black overlay appears (older Hyprland issue): `persist.waydroid.use_subsurface false` + `persist.waydroid.no_background_subsurface true`, or `windowrulev2 = opacity 0.6 0.6, class:Waydroid`.

## 6. Play Protect Certification (uncertified device)

- Waydroid GAPPS is uncertified (`test-keys` fingerprint). Many apps refuse install/login until the GSF ID is registered at https://www.google.com/android/uncertified.
- GSF Android ID (18-digit, NOT Settings.Secure ANDROID_ID): `4299995604260554896`
- Retrieve anytime:
  ```
  pkexec waydroid shell -- sh -c 'ANDROID_RUNTIME_ROOT=/apex/com.android.runtime ANDROID_DATA=/data \
    ANDROID_TZDATA_ROOT=/apex/com.android.tzdata ANDROID_I18N_ROOT=/apex/com.android.i18n \
    sqlite3 /data/user/$(cmd activity get-current-user)/*/*/gservices.db "select * from main where name=\"android_id\";"'
  ```
- Wait a few minutes after registering, then restart Waydroid.

## Quirks / Limitations

- **Window mapping flake on Hyprland**: if the UI never maps, the container freezes (because `suspend_action = freeze`). Fix: `waydroid session stop && waydroid show-full-ui` to relaunch.
- **Play Integrity**: even certified, Waydroid cannot pass Play Integrity → games like Magic Chess may still hard-block login/server-side. Would need Magisk + LSPosed device spoofing (out of scope).
- Hybrid-GPU flicker: use [waydroid-choose-gpu.sh](https://github.com/Quackdoc/waydroid-scripts/blob/main/waydroid-choose-gpu.sh) to pin the iGPU if rendering glitches.

## Useful Commands

| Action | Command |
| ------ | ------- |
| Status | `waydroid status` |
| Launch UI | `waydroid show-full-ui` |
| Stop UI | `waydroid session stop` |
| Root shell into Android | `pkexec waydroid shell` |
| List packages | `pkexec waydroid shell -- pm list packages \| grep -i play` |
| Restart container | `pkexec systemctl restart waydroid-container` |
| Set prop (session running) | `waydroid prop set persist.waydroid.multi_windows true` |

## Tags
 #waydroid #android #hyprland #gapps #arm-translation