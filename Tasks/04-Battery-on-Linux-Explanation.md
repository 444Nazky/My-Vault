Battery Optimization Summary

Changes Made:
1. Installed auto-cpufreq for CPU frequency management
2. Installed powertop for power analysis
3. Installed supergfxctl for GPU switching
4. Enabled Lenovo Conservation Mode (set to 100% limit, value 0)
5. Disabled power-profiles-daemon service
6. Created systemd service for conservation mode persistence

Bug Identified:
- GPU switching via supergfxctl did not work automatically
- Requires system reboot to take effect
- Manual intervention needed after reboot

Fix:
- Reboot laptop
- Run: pkexec supergfxctl --switch integrated

Battery Limit Update:
- Conservation mode set to value 0 (100% charge limit)
- Values 2, 3, 4 (80%, 90%, 95%) are NOT supported on this hardware
- Only values 0 (100%) and 1 (60-65%) are supported
- To disable battery limit: echo 0 | sudo tee /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode
