# Memory and Swap Reference

> Standalone reference. No links in or out. Embed-only.

```mermaid
graph LR
    A[RAM Used] --> B[ZRAM Compress]
    B --> C[Swap In/Out]
    C --> D[Processes]
```

## Numbers at a Glance

- RAM: 15GB DDR5, ~8.2GB used in desktop session
- ZRAM: swap-on-zram, compresses inactive pages
- Swappiness was the big fix in the Caelestia lag investigation

## Diagram

![[memory-management.svg]]

Reduce swappiness to avoid churn, keep ZRAM for bursty load, watch cache pressure.

## Tag Line

Tags: #memory #performance #zram