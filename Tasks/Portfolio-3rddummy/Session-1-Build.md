# Session 1: Complete Build

## Overview
Full rebuild of the developer portfolio at `~/RPL/Dummies/3rddummy/`. Started empty, ended with a production-ready single-page portfolio.

## Setup
```bash
npx create-next-app@latest . --ts --tailwind --eslint --app \
  --no-src-dir --import-alias "@/*" --use-npm --turbopack
```
- Next.js 16.3.5, React 19.2.8, Tailwind v4, TypeScript 5.x
- Fonts loaded via `next/font/google`: **Archivo** (geometric display) + **Inter** (body)

## Theme (globals.css)
- Tailwind v4 `@theme inline` tokens
- Colors: `--background #0d0d0d`, `--neon #c6ff00`, `--neon-soft #a3e635`, `--muted #8b9099`, `--card #161616`, `--line rgba(255,255,255,0.08)`
- Custom utilities: `bg-grid`, `text-outline-neon`
- Keyframes: `marquee`, `spin-rev`, `float`, `pulse-dot`
- Custom scrollbar, neon `::selection`, `prefers-reduced-motion` guard

## Sections

### Navbar (client)
- Fixed, translucent with `backdrop-blur` + bottom border after 24px scroll
- Scrollspy via `IntersectionObserver` (`rootMargin: -45% 0px -50% 0px`)
- Neon "Contact Me" pill CTA + mobile hamburger with animated panel, body scroll lock

### Hero
- Eyebrow pill: "Hey There! Nazky's here!"
- Display: **PORT** solid white / **FOLIO** outlined (`-webkit-text-stroke` neon)
- Grid background with radial mask + ambient neon/cyan glows
- CSS-only globe: 3 spinning orbit rings, latitude/longitude arcs, pulsing core, floating BASH / LINUX / PENTEST / API chips (`animate-float`)

### About
- Bio with build-to-break framing
- Headshot placeholder card (avatar SVG silhouette + "NZ" monogram + Open to Work badge)
- Stats grid: **42+** months, **16+** certificates, **10,459 ML** caffeine
- Marquee: `Designer • Engineer • Cybsec` — duplicated rows, `translateX(-50%)` loop, pauses on hover

### Tech Stacks (client)
- Accordion using `grid-template-rows` transition trick (0fr → 1fr) — no JS height measurement
- 4 categories: Flutter & Dart / Linux & Bash / Backend (Python, Laravel) / Cybersecurity & Tools
- Badge cards with brand tints (Python, Laravel, Flutter, Linux, Figma, Burp Suite) via inline `--tint` var

### Certificates
- 8-card responsive grid (sm:2 / lg:4 cols), medal icon, number index, year + tag chips
- Outlined "See More" button

### Experience
- Sticky left heading + right timeline (vertical gradient line + glowing node dots)
- 4 entries: RevoU (SOC Analyst), Surosowan Academy, Nusacodes Academy, Coursera

### Awards
- Two cards grouped by year: **2026** (Certified Trainer, Certified Web Trainer) / **2025** (Certified IoT Trainer, Basic Game Trainer)

### Footer / CTA
- Giant "LET'S TALK", `naruzky.naz@gmail.com` mailto link, social pills
- Quick links, newsletter form (client, preventDefault + success state)
- NAZKY copyright bar

## Issues Fixed During Build
| Issue | Fix |
|-------|-----|
| TS: custom `--tint` style property | Cast to `React.CSSProperties` |
| TS: `badge.tag` possibly null | Typed `BADGES` array; replaced `null` with dedicated `ux()` icon |
| ESLint `react-hooks/static-components` | Moved `MarqueeRow` component outside render |
| ESLint unused var | Removed index param in stats map |

## Verification
- `npm run build` — compiled, typecheck passed, static prerender `○ /`
- `npm run lint` — clean
- Dev smoke test `localhost:3000` — 200 OK, all sections rendered (Folio, Passion for Cyber, Tech Stacks, CERTIFICATE, Professional Experiences, Awards, LET'S TALK)

## Run
```bash
cd ~/RPL/Dummies/3rddummy && npm run dev
```

## Notes
- Headshot is a designed placeholder (silhouette + "NZ"). Swap in a real photo under `public/` and point the `About` card at it.
- Next.js warned: package-lock ignored because parent dir isn't a git repo. Set `turbopack.root` in `next.config.ts` to silence.

## Tags
 #nextjs #tailwind #frontend #portfolio #rpl