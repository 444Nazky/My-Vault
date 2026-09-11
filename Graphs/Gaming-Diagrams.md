# Gaming Diagrams

**Part of:** [[00-Graph-Index]]

## NFS Heat Gaming Fix

```mermaid
flowchart TD
    A["game laggy on Intel"] --> B["install Proton GE"]
    B --> C["force Proton in Steam"]
    C --> D["set PRIME flags"]
    D --> E["offload render"]
    D --> F["use nvidia GL"]
    E --> H["Nvidia renders"]
    F --> H
    H --> I["smooth game"]
```

Flags used: PRIME offload plus nvidia GL vendor, verified with smi.

## Roblox Sober Install

```mermaid
flowchart LR
    A["want Roblox on Hyprland"] --> B["install Sober flatpak"]
    B --> C["runtime plus Wine bundled"]
    C --> D["desktop entry"]
    C --> E["cli wrapper"]
    E --> F["launch GUI"]
    E --> G["launch game URI"]
    F --> H["Wayland plus GPU OK"]
```

Sober 1 point 7 point 1, 18 point 5 MB, RTX passthrough confirmed.

## Gaming GPU Decision Tree

```mermaid
flowchart TD
    A["game slow"] --> B{"gpu busy"}
    B -->|"no"| C["add PRIME flags"]
    B -->|"yes"| D{"fps still low"}
    D -->|"yes"| E["switch Proton version"]
    D -->|"no"| F["fixed"]
    C --> F
    E --> F
```

Roblox path is covered in the Sober diagram above.

Tags: #graph #gaming
