# Thermal & Power Management

Device thermal and power configuration documentation.

## Temperature Monitoring

### Check Current Temperatures

```bash
# Using sensors
sensors

# Using nvidia-smi (if NVIDIA)
nvidia-smi -q -d temperature

# All cores
cat /sys/class/thermal/thermal_zone*/temp
```

### Thermal Zones

Typical locations:
- CPU: `thermal_zone0`
- GPU: `thermal_zone1`
- Battery: `thermal_zone2`

### Temperature Ranges

| Component | Normal | Warning | Critical |
|----------|--------|---------|----------|
| CPU | 30-50 C | 70-80 C | 90+ C |
| GPU | 30-60 C | 75-85 C | 90+ C |
| Battery | 20-35 C | 40-50 C | 60+ C |

## Power Management

### Power Profiles

Check available profiles:

```bash
powerprofilesctl list
```

Set performance mode:

```bash
sudo powerprofilesctl set performance
```

### TLP (Advanced Power Management)

Install: `sudo pacman -S tlp tlp-rdw`

Enable: `sudo systemctl enable --now tlp`

Configuration: `/etc/tlp.conf`

### Thermald

Intel thermal daemon:

```bash
sudo pacman -S thermald
sudo systemctl enable --now thermald
```

## CPU Frequency

### cpupower

```bash
# Check available frequencies
cpupower frequency-info

# Set governor
sudo cpupower frequency-set -g performance

# List governors
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_available_governors
```

### Governors

| Governor | Description |
|---------|-------------|
| performance | Max frequency always |
| powersave | Min frequency always |
| schedutil | Based on demand (recommended) |
| ondemand | Older demand-based |
| conservative | Gradual changes |

## NVIDIA Power Management

### Check Power Limit

```bash
nvidia-smi -q -d POWER_LIMIT
```

### Set Performance Mode

```bash
nvidia-smi -pm ENABLED
nvidia-smi -pl <watts>
```

### GPU Clock Offset

For laptops, set persistent performance mode in `/etc/X11/xorg.conf`:

```
Section "Device"
    Identifier "NVIDIA"
    Driver "nvidia"
    Option "RegistryDwords" "PowerMizerEnable=0x1; PerfLevelSrc=0x2222; PowerMizerLevel=0x3"
EndSection
```

## Battery Management

### Battery Status

```bash
# Check charge
upower -i /org/freedesktop/UPower/devices/battery_BAT0

# Detailed info
cat /sys/class/power_supply/BAT0/status
```

### Charging Threshold

For battery longevity on laptops:

```bash
# If supported (ASUS, Lenovo, etc.)
echo 80 | sudo tee /sys/class/power_supply/BAT0/charge_control_end_threshold
```

## Fan Control

### Check Fan Speed

```bash
sensors | grep -i fan
```

### Fan Curves

For custom fan control, install `fancontrol`:

```bash
sudo pacman -S lm_sensors
sudo sensors-detect
sudo systemctl enable --now fancontrol
```

Configure in `/etc/fancontrol`.

## Cooling

### Reduce CPU Heat

1. Clean vents and fans
2. Use laptop cooling pad
3. Undervolt CPU (if supported)

### Undervolting

Use `intel-undervolt` or BIOS settings to reduce voltage.

### Thermal Paste

Consider repasting if temps are high under load.

## Power Profiles (systemd)

### Tuned

```bash
sudo pacman -S tuned
sudo systemctl enable --now tuned
tuned-adm profile throughput-performance
```

### Auto-cpufreq

```bash
yay -S auto-cpufreq
sudo systemctl enable --now auto-cpufreq
```

## Troubleshooting

### High Temps

1. Check for dust in vents
2. Verify fans are spinning
3. Check thermal paste
4. Reduce background processes
5. Undervolt if possible

### Fans Not Spinning

1. Check `sensors` output
2. Verify fan connection
3. Check BIOS settings
4. Install fancontrol

### Thermal Throttling

If temps exceed thermal throttle threshold:
- Performance drops significantly
- System may freeze

Solutions:
- Clean cooling system
- Repaste CPU/GPU
- Use cooling pad
- Undervolt
- Limit CPU power

---

Related: [[01 - Hardware Specifications]]
Related: [[06 - USB Devices]]

---

## Tags
#note-thermal-power
