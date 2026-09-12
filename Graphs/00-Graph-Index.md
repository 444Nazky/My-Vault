# Graphs Index

**Type:** hub. One topic per page, nothing merged.

## Pages

| Page | Topic |
|------|-------|
| [[Vault-Overview]] | Vault maps, fix dashboard, timeline, tags |
| [[System-Diagrams]] | Boot, drivers, GRUB, desktop, device |
| [[Gaming-Diagrams]] | NFS Heat, Sober, GPU decisions |
| [[Security-IR-Diagrams]] | Kill chain, remediation, toolkit |
| [[Dev-Tasks-Diagrams]] | Laravel, UI sessions, apps, guides |

## Orange Nodes Visual

![Orange Nodes Overview](../attachments/orange-nodes-overview.png)

> See [[System/WiFi Troubleshooting/00-Overview\|WiFi Investigation]] for details on the Intel AX211 fix.

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'primaryColor': '#2D9CDB', 'lineColor': '#2D9CDB'}}}%%
graph TD
 IDX["Graphs Index"] -->|overview| OV["Vault Overview"]
 IDX -->|system| SYS["System Diagrams"]
 IDX -->|gaming| GAM["Gaming Diagrams"]
 IDX -->|security| SEC["Security IR Diagrams"]
 IDX -->|dev| DEV["Dev Tasks Diagrams"]
 style IDX fill:#2D9CDB,stroke:#2D9CDB,color:#fff
 style OV fill:#9B51E0,stroke:#9B51E0,color:#fff
 style SYS fill:#27AE60,stroke:#27AE60,color:#fff
 style GAM fill:#F2994A,stroke:#F2994A,color:#fff
 style SEC fill:#EB5757,stroke:#EB5757,color:#fff
 style DEV fill:#56CCF2,stroke:#56CCF2,color:#fff
```

## Tags
#note-graph-index
