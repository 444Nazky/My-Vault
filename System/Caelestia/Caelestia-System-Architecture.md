# Caelestia System Architecture

> **Desktop Environment:** Hyprland + Caelestia Shell
> **Category:** Configuration
> **Last Updated:** September 2026

---

## Architecture Overview

```mermaid
flowchart TB
    subgraph Display["Display Pipeline"]
        App[Applications] --> Comp[Compositor<br/>Hyprland]
        Comp --> DR[Display Server]
    end
    
    subgraph Shell["Caelestia Shell"]
        DR --> Bar[Waybar<br/>Status Bar]
        DR --> Menu[App Launcher<br/>Wofi]
        DR --> Scripts[Custom Scripts<br/>Auto-start]
    end
    
    subgraph Hardware["Hardware"]
        GPU[GPU Rendering]
        Audio[Audio Server<br/>PipeWire]
        Input[Input Devices]
    end
    
    Comp <--> GPU
    Comp <--> Audio
    Input --> Comp
```

## Component Stack

### Layers

| Layer | Component | Purpose |
|-------|-------------|---------|
| **1** | Kernel (Linux) | System calls, hardware access |
| **2** | Wayland | Display protocol |
| **3** | Hyprland | Compositor, window management |
| **4** | Caelestia | Shell customizations |
| **5** | Applications | User software |

## Key Files

```bash
~/.config/
├── hypr/                    # Hyprland config
│   └── hyprland.conf       # Main compositor config
├── caelestia/               # Caelestia-specific
│   ├── config.conf         # Shell settings
│   ├── autostart          # Auto-launch apps
│   └── scripts/           # Custom scripts
├── waybar/                # Status bar config
└── foot/                  # Terminal config
```

## Data Flow

```mermaid
sequenceDiagram
    App->>Hyprland: Wayland Protocol
    Hyprland->>GPU: Render Buffer
    GPU-->>Monitor: Framebuffer
    Note over Hyprland,Monitor: Compositor Composites
```

## Window Management

```mermaid
flowchart LR
    Win[Window Rules] --> Act[Actions]
    Act -->|floating| Float[Float Window]
    Act -->|workspace| WS[Workspace<br/>Workspace 1-10]
    Act -->|fullscreen| Full[Fullscreen]
```

## Tags
#caelestia #architecture #hyprland #wayland #desktop