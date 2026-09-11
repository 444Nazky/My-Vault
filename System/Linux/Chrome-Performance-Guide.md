# Chrome Performance Guide

## Overview
Optimization guide for Chrome/Chromium browser on Linux.

## Memory Optimization

### Reduce Memory Usage
```bash
# Flags to try in chrome://flags
# Empty idle background tabs: Enabled
# Automatic tab discarding: Enabled
# Hardware-accelerated video decode: Enabled

# Launch flags
google-chrome --enable-tab-auditing
google-chrome --disable-extensions
google-chrome --process-per-site
```

### Extensions to Consider
- Great Suspender (suspend tabs)
- Memory Saver mode (built-in)
- uBlock Origin (lightweight adblock)

## GPU Acceleration

### Enable Hardware Acceleration
```bash
# In chrome://settings
# System > Use hardware acceleration when available

# Verify GPU status
chrome://gpu
```

### NVIDIA Specific
```bash
# Add to ~/.config/chrome-flags.conf
--enable-gpu-rasterization
--enable-zero-copy
--ignore-gpu-blocklist
```

## Network Optimization

### Faster Loading
```bash
# DNS prefetch
--dns-prefetch-disabled

# Preconnect
# Enable preconnect in chrome://flags
```

### QUIC Protocol
```bash
# Enable QUIC
--enable-quic
--quic-version=h3-25
```

## Performance Settings

### Disable Features
- Smooth Scrolling (if causing lag)
- Hardware-accelerated video decode (if unstable)
- Background sync

### Resource Settings
```bash
# Limit renderer processes
--renderer-process-limit=2

# Disable background apps
--disable-background-apps
```

## Caching

### Cache Location
```bash
# Default
~/.cache/google-chrome/

# Move to faster disk
ln -s /path/to/fast/cache ~/.cache/google-chrome
```

### Clear Cache
```bash
# From Chrome
# Settings > Privacy > Clear browsing data

# Manual
rm -rf ~/.cache/google-chrome/*
```

## Developer Tools Optimization

### Disable Heavy Features
- Disable JavaScript sampling
- Disable CSS source maps
- Disable JavaScript source maps

## Tags
 #performance
