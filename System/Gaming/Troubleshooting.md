# Troubleshooting

## Issue 1: Game Still Laggy

**Symptoms:**
- Low FPS after configuration
- nvidia-smi shows 0% GPU usage
- Game running on Intel GPU

**Solutions:**

1. **Verify launch options are exact**
   - Open Steam > NFS Heat > Properties > General
   - Launch Options should contain exactly:
     ```
     __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia %command%
     ```
   - No extra quotes, spaces, or characters

2. **Restart Steam**
   - Close Steam completely
   - `pkill steam`
   - Start Steam again

3. **Check Proton GE is selected**
   - Properties > Compatibility
   - Ensure "GE-Proton11-6" is checked and selected

4. **Verify NVIDIA is visible**
   ```bash
   nvidia-smi
   ```
   If this fails, drivers are not working.

## Issue 2: Proton GE Not in Dropdown

**Symptoms:**
- GE-Proton11-6 not appearing
- Option greyed out

**Solutions:**

1. **Check installation**
   ```bash
   ls ~/.steam/steam/compatibilitytools.d/
   ```
   Should show "GE-Proton11-6" folder

2. **Check folder contents**
   ```bash
   ls ~/.steam/steam/compatibilitytools.d/GE-Proton11-6/
   ```
   Should have proton executable

3. **Fix permissions**
   ```bash
   chmod -R 755 ~/.steam/steam/compatibilitytools.d/GE-Proton11-6
   ```

4. **Restart Steam**

## Issue 3: Easy Anti-Cheat Blocking

**Symptoms:**
- Game crashes on startup
- EAC error message
- Multiplayer not working

**Solutions:**

1. **Verify EAC support**
   Proton GE has better EAC support than vanilla Proton

2. **Force EAC runtime**
   Add to launch options:
   ```
   PROTON_EAC_RUNTIME=1 __NV_PRIME_RENDER_OFFLOAD=1 %command%
   ```

3. **Verify game files**
   - Properties > Local Files > Verify Integrity of Game Files

4. **Update Proton GE**
   Get latest version from GitHub releases

## Issue 4: Screen Tearing

**Symptoms:**
- Horizontal lines in image
- Split screen effect

**Solutions:**

1. **Enable V-sync in game**
   NFS Heat > Settings > Display > V-sync > On

2. **Enable in NVIDIA settings**
   NVIDIA X Server Settings > X Server Display Configuration > Force Full Composition Pipeline

3. **Add to launch options**
   ```
   vblank_mode=1 __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia %command%
   ```

## Issue 5: Low FPS Despite NVIDIA

**Symptoms:**
- nvidia-smi shows game running
- Still laggy

**Solutions:**

1. **Check power limit**
   ```bash
   nvidia-smi -q -d POWER_LIMIT
   ```
   Laptop GPUs are power-limited

2. **Check temperature**
   ```bash
   nvidia-smi -q -d TEMPERATURE
   ```
   Throttling occurs near 87C

3. **Close background apps**
   ```bash
   top
   ```
   Kill unnecessary processes

4. **Lower in-game settings**
   Reduce shadows, disable ambient occlusion

## Issue 6: Game Crashes

**Symptoms:**
- Fails to launch
- Crash during loading
- No error message

**Solutions:**

1. **Enable logging**
   Add to launch options:
   ```
   PROTON_LOG=1 __NV_PRIME_RENDER_OFFLOAD=1 %command%
   ```
   Check logs:
   ```bash
   cat ~/.steam/steam/logs/proton_latest.log
   ```

2. **Verify game files**
   Properties > Local Files > Verify Integrity

3. **Delete Proton prefix** (resets settings)
   ```bash
   rm -rf ~/.steam/steam/steamapps/compatdata/1222680/pfx
   ```

4. **Try different Proton**
   Try Proton 8, Proton 9, or Proton Experimental

## Issue 7: No Sound

**Solutions:**

1. **Install audio libs**
   ```bash
   sudo pacman -S libpulse-alsa lib32-libpulse
   ```

2. **Set audio driver**
   Add to launch options:
   ```
   AUDIO_COMBINE_OVERRIDE=1 __NV_PRIME_RENDER_OFFLOAD=1 %command%
   ```

## Issue 8: Controller Not Working

**Solutions:**

1. **Enable Steam Input**
   Properties > Controller > Enable Steam Input

2. **Or disable Steam Input**
   Try "Disable Steam Input" if buttons are wrong

3. **Install xboxdrv**
   ```bash
   sudo pacman -S xboxdrv
   ```

## Diagnostic Commands

```bash
# GPU info
nvidia-smi

# Check game process
ps aux | grep -i nfs

# Monitor GPU usage
watch -n 1 nvidia-smi

# Check Proton logs
ls ~/.steam/steam/logs/
cat ~/.steam/steam/logs/proton_latest.log

# Check libraries
vulkaninfo | head -20
glxinfo | grep "OpenGL renderer"
```

## Getting Help

When asking for help, provide:

1. GPU: `nvidia-smi --query-gpu=name,driver_version --format=csv`
2. Steam version
3. Proton version
4. Launch options (screenshot)
5. Error messages
6. Proton logs

## Useful Links

| Resource | URL |
|----------|-----|
| Proton GE Releases | github.com/GloriousEggroll/proton-ge-custom |
| ProtonDB | protondb.com |
| Arch NVIDIA Wiki | wiki.archlinux.org/title/NVIDIA |

---

Related: [[The-Solution]] - Basic setup guide
Related: [[Launch-Options]] - Variable explanations

## Tags
#note-troubleshooting
