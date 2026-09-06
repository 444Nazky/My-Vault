# NFS Heat on Arch Linux

Complete documentation for running Need for Speed Heat on Arch Linux using Steam with Proton GE and NVIDIA GPU.

## Quick Fix

The game was lagging because it was running on the Intel integrated GPU instead of the NVIDIA RTX 5050. The fix:

1. Install Proton GE
2. Set Proton GE as the compatibility tool in Steam
3. Add launch options to force NVIDIA GPU

## Files in This Folder

| File | Description |
|------|-------------|
| [[Setup-Log]] | Step-by-step log of what was configured |
| [[The-Problem]] | Why NFS Heat was laggy |
| [[The-Solution]] | How to fix the lag |
| [[System-Info]] | Your hardware and software specs |
| [[Launch-Options]] | Explanation of the launch flags |
| [[Troubleshooting]] | Common issues and solutions |

## Summary

**Problem:** Hybrid graphics laptop (Intel + NVIDIA). Without configuration, games run on Intel GPU = laggy.

**Solution:** Use Proton GE and add these launch options in Steam:

```
__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia %command%
```

## Hardware

- GPU: NVIDIA RTX 5050 Laptop GPU (8GB)
- Secondary: Intel UHD Graphics (Raptor Lake)
- Driver: NVIDIA 610.57.04
- OS: Arch Linux

## What Was Done

1. Downloaded and installed Proton GE 11-6
2. Configured NVIDIA PRIME offloading
3. Set up Steam compatibility settings
4. Created documentation

## Next Steps

Follow [[The-Solution]] to configure Steam properly, then launch the game.

---

Tags: #gaming #linux #arch #nfs #steam #proton #nvidia
