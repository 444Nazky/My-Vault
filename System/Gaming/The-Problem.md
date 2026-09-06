# The Problem: NFS Heat Lag

## The Symptom

NFS Heat runs extremely laggy on this Arch Linux laptop, even though it has an RTX 5050 GPU.

## Root Cause

### Hybrid Graphics

This laptop has two GPUs:

| GPU | Type | Performance |
|-----|------|-------------|
| Intel UHD Graphics | Integrated | Low power, used by default |
| NVIDIA RTX 5050 | Dedicated | High performance, needs explicit opt-in |

### How It Works on Linux

By default, Linux sends all graphics output through the Intel integrated GPU. The NVIDIA GPU sits idle unless specifically told to render.

This is called **PRIME/Optimus** - NVIDIA's technology for switching between GPUs.

### Why This Causes Lag

| GPU | Expected FPS |
|-----|-------------|
| Intel UHD | 10-30 FPS ( slideshow ) |
| NVIDIA RTX 5050 | 60+ FPS |

Running NFS Heat without GPU offloading = running on Intel = unplayable.

### What Makes It Worse

1. **Proton** runs games through Wine (Windows compatibility layer)
2. Proton defaults to the system GPU (Intel)
3. The game cannot see the NVIDIA GPU without environment variables
4. Easy Anti-Cheat adds complexity to GPU switching

## The Solution

Force the game to use NVIDIA via:

1. **Proton GE** - Better GPU management than vanilla Proton
2. **Launch options** - Environment variables that enable PRIME offloading

## Key Concepts

### PRIME Render Offload

PRIME tells the NVIDIA driver: "Render this application's graphics on the dedicated GPU, then pass frames to Intel for display."

### Environment Variables

| Variable | What It Does |
|----------|--------------|
| `__NV_PRIME_RENDER_OFFLOAD=1` | Enable PRIME offloading |
| `__GLX_VENDOR_LIBRARY_NAME=nvidia` | Route OpenGL through NVIDIA |

### Proton GE vs Vanilla Proton

| Feature | Proton (Steam) | Proton GE |
|---------|-----------------|-----------|
| Game compatibility | Good | Excellent |
| Anti-cheat support | Basic | Better (includes EAC fixes) |
| GPU management | Manual | Easier |
| Updates | With Steam | Frequent, independent |

---

Related: [[The-Solution]] - How to fix this
Related: [[Launch-Options]] - Deep dive on the variables
