# Caelestia

## Overview
Caelestia shell documentation and configuration reference.

## What is Caelestia
Caelestia is a shell/environment built on top of Hyprland that provides a cohesive desktop experience with custom configurations, scripts, and themes.

## Key Components

### Shell
- Based on Hyprland (Wayland)
- Custom scripts and automation
- Theme integration
- Window management rules

### Configuration Files
```
~/.config/caelestia/
├── config.conf
├── scripts/
├── themes/
└── autostart
```

## Common Tasks

### Auto-Lock Settings
```bash
# Check current settings
cat ~/.config/caelestia/config.conf | grep -i lock

# Disable auto-lock
# Set in config: general { idle_timeout = 0 }
```

### Layout Geometry
```bash
# Check current geometry settings
cat ~/.config/caelestia/config.conf | grep -i geometry
```

## Related Notes
- [[Caelestia Configuration]]
- [[Caelestia System Architecture]]
- [[Caelestia-Lag-Investigation]]

## Tags
#caelestia #hyprland #wayland #shell #configuration
