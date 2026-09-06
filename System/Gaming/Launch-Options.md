# Launch Options Explained

## The Command

```
__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia %command%
```

This goes in Steam > NFS Heat > Properties > Launch Options

## Breaking It Down

### `__NV_PRIME_RENDER_OFFLOAD=1`

**What it does:** Enables NVIDIA PRIME render offloading

**Without this:** Game renders on Intel GPU (slow)
**With this:** Game renders on NVIDIA GPU (fast)

PRIME is NVIDIA's Linux technology for hybrid graphics. It lets the NVIDIA GPU do the heavy rendering, then passes finished frames to the Intel GPU for display.

### `__GLX_VENDOR_LIBRARY_NAME=nvidia`

**What it does:** Routes OpenGL calls to NVIDIA driver instead of Intel

**Without this:** OpenGL applications use Intel driver
**With this:** OpenGL applications use NVIDIA driver

This is needed because NFS Heat uses OpenGL for some graphics.

### `%command%`

**What it does:** Steam replaces this with the actual game command

**Important:** Never remove this or the game will not start.

### The Space

There must be a space between the two variables, not a comma:

**Correct:** `__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia %command%`
**Wrong:** `__NV_PRIME_RENDER_OFFLOAD=1,__GLX_VENDOR_LIBRARY_NAME=nvidia %command%`

## Other Useful Variables

### For Vulkan Games

```bash
__NV_PRIME_RENDER_OFFLOAD=1 __VK_LAYER_NV_optimus=NVIDIA_only %command%
```

### For Async Shader Compilation (faster loading)

```bash
DXVK_ASYNC=1 __NV_PRIME_RENDER_OFFLOAD=1 %command%
```

### For Debugging (writes logs)

```bash
PROTON_LOG=1 __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia %command%
```

Logs appear in: `~/.steam/steam/logs/`

## Proton Variables

### Common PROTON_ Variables

| Variable | Values | Effect |
|----------|--------|--------|
| PROTON_NO_ESYNC | 0, 1 | Disable eventfd sync |
| PROTON_NO_FSYNC | 0, 1 | Disable futex sync |
| PROTON_LOG | 0, 1 | Enable logging |
| PROTON_DUMP_DEBUG_INFO | 0, 1 | Dump debug on crash |

### Example with Proton Variables

```bash
PROTON_NO_ESYNC=1 PROTON_LOG=1 __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia %command%
```

## NVIDIA OpenGL Variables

### Threaded Optimization

```bash
__GL_THREADED_OPTIMIZATION=1 __NV_PRIME_RENDER_OFFLOAD=1 %command%
```

Enables multi-threaded OpenGL rendering.

### Shader Cache

```bash
__GL_SHADER_DISK_CACHE=1 __NV_PRIME_RENDER_OFFLOAD=1 %command%
```

Caches compiled shaders to disk (faster subsequent launches).

## Variable Order

Order generally does not matter. Suggested order:

1. Proton/Wine variables (PROTON_*, DXVK_*)
2. NVIDIA/OpenGL variables (__NV_*, __GL_*)
3. Game command (%command%)

## Verify Variables Are Working

### Check GPU Usage

While game is running:
```bash
nvidia-smi
```

Look for the game process. If GPU usage is 0%, the variables are not working.

### Check Process Environment

```bash
# Find game PID
ps aux | grep -i nfs

# Check its environment
cat /proc/<PID>/environ | tr '\0' '\n' | grep NV
```

You should see `__NV_PRIME_RENDER_OFFLOAD=1` in the output.

## Troubleshooting

### Variables Not Working

1. Check for typos (they are case-sensitive)
2. No extra spaces or quotes
3. Restart Steam after changes
4. Make sure Proton GE is actually selected

### Game Still on Intel

1. Verify nvidia-smi works
2. Check Proton GE is selected (not vanilla Proton)
3. Try the alternative Vulkan variable
4. Check NVIDIA is GPU index 1: `NVIDIA_VISIBLE_DEVICES=1`

---

Related: [[The-Solution]] - How to apply these
Related: [[Troubleshooting]] - If problems persist
