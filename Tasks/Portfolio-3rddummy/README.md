# Portfolio 3rddummy

## Overview
Rebuild of the developer portfolio site at `~/RPL/Dummies/3rddummy/`. Single-page, ultra-dark cyber/tech aesthetic, built with Next.js + Tailwind.

## Sessions
### Session 1: Complete Build
- Scaffolded Next.js 16.3.5 (App Router, Turbopack) + Tailwind v4 + TypeScript
- Designed theme system (acid green on near-black)
- Built all 8 page sections
- Verified: production build, lint, typecheck all pass

## Stack
| Tool | Version |
|------|---------|
| Next.js | 16.3.5 (App Router, Turbopack) |
| React | 19.2.8 |
| Tailwind CSS | v4 (`@tailwindcss/postcss`) |
| TypeScript | 5.x |
| Node.js | 26.8.1 |

## Design System
- Background: `#0D0D0D` (ultra-dark cyber)
- Neon accent: `#C6FF00` / secondary `#A3E635`
- Text: light gray `#E9E9E9`, muted `#8B9099`
- Fonts: Archivo (geometric display) + Inter (body) via `next/font/google`
- Effects: glowing radial gradients, dark cards with faint borders, grid patterns, smooth hover transitions

## Sections Built
1. Navbar — sticky blur, scrollspy, neon Contact Me CTA, mobile hamburger
2. Hero — "PORT / FOLIO" outlined display, CSS-only globe orb, floating chips
3. About — "Passion for Cyber Security", stats grid, infinite marquee
4. Tech Stacks — animated accordion, 4 categories, 6 brand-tinted badges
5. Certificates — responsive 8-card grid, "See More" CTA
6. Experience — vertical timeline with glowing markers
7. Awards — grouped by year (2026 / 2025)
8. Footer/CTA — "LET'S TALK", contact, quick links, newsletter

## Components
- `Navbar.tsx`, `Hero.tsx`, `About.tsx`, `TechStacks.tsx`
- `Certificates.tsx`, `Experience.tsx`, `Awards.tsx`, `Footer.tsx`
- `NewsletterForm.tsx`, `SectionHeading.tsx`

## Related Notes
- [[Session-1-Build]]

## Tags
 #frontend #nextjs #portfolio #rpl