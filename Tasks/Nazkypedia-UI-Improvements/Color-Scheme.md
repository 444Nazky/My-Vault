# Color Scheme

Nazkypedia UI color scheme documentation.

## Brand Colors

### Primary Colors

| Name | Hex | RGB | Usage |
|------|-----|-----|-------|
| Primary | #2563EB | 37, 99, 235 | Main brand color, buttons |
| Primary Dark | #1D4ED8 | 29, 78, 216 | Hover states |
| Primary Light | #3B82F6 | 59, 130, 246 | Links, accents |

### Secondary Colors

| Name | Hex | RGB | Usage |
|------|-----|-----|-------|
| Secondary | #64748B | 100, 116, 139 | Text, icons |
| Secondary Dark | #475569 | 71, 85, 105 | Emphasis |
| Secondary Light | #94A3B8 | 148, 163, 184 | Muted text |

## Semantic Colors

### Success

| Name | Hex | Usage |
|------|-----|-------|
| Success | #10B981 | Success messages, checkmarks |
| Success Light | #34D399 | Success backgrounds |

### Warning

| Name | Hex | Usage |
|------|-----|-------|
| Warning | #F59E0B | Warning messages |
| Warning Light | #FBBF24 | Warning backgrounds |

### Error

| Name | Hex | Usage |
|------|-----|-------|
| Error | #EF4444 | Error messages |
| Error Light | #F87171 | Error backgrounds |

### Info

| Name | Hex | Usage |
|------|-----|-------|
| Info | #3B82F6 | Info messages |
| Info Light | #60A5FA | Info backgrounds |

## Neutral Colors

### Grays

| Name | Hex | Usage |
|------|-----|-------|
| White | #FFFFFF | Backgrounds |
| Gray 50 | #F8FAFC | Page background |
| Gray 100 | #F1F5F9 | Card backgrounds |
| Gray 200 | #E2E8F0 | Borders |
| Gray 300 | #CBD5E1 | Disabled states |
| Gray 400 | #94A3B8 | Placeholder text |
| Gray 500 | #64748B | Secondary text |
| Gray 600 | #475569 | Body text |
| Gray 700 | #334155 | Headings |
| Gray 800 | #1E293B | Dark text |
| Gray 900 | #0F172A | Darkest text |
| Black | #000000 | High contrast |

## Component Colors

### Buttons

| Type | Background | Text | Border |
|------|------------|------|--------|
| Primary | #2563EB | #FFFFFF | none |
| Secondary | transparent | #2563EB | #2563EB |
| Ghost | transparent | #64748B | none |
| Danger | #EF4444 | #FFFFFF | none |

### Inputs

| State | Background | Border | Text |
|-------|-----------|--------|------|
| Default | #FFFFFF | #E2E8F0 | #1E293B |
| Focus | #FFFFFF | #2563EB | #1E293B |
| Error | #FEF2F2 | #EF4444 | #DC2626 |
| Disabled | #F1F5F9 | #E2E8F0 | #94A3B8 |

## Dark Mode Colors

When dark mode is enabled:

| Light | Dark |
|-------|------|
| #FFFFFF | #0F172A |
| #F8FAFC | #1E293B |
| #F1F5F9 | #334155 |
| #1E293B | #F1F5F9 |

## CSS Variables

```css
:root {
    /* Primary */
    --color-primary: #2563EB;
    --color-primary-dark: #1D4ED8;
    --color-primary-light: #3B82F6;

    /* Semantic */
    --color-success: #10B981;
    --color-warning: #F59E0B;
    --color-error: #EF4444;
    --color-info: #3B82F6;

    /* Neutrals */
    --color-white: #FFFFFF;
    --color-gray-50: #F8FAFC;
    --color-gray-100: #F1F5F9;
    --color-gray-200: #E2E8F0;
    --color-gray-300: #CBD5E1;
    --color-gray-400: #94A3B8;
    --color-gray-500: #64748B;
    --color-gray-600: #475569;
    --color-gray-700: #334155;
    --color-gray-800: #1E293B;
    --color-gray-900: #0F172A;
    --color-black: #000000;
}
```

## Accessibility

### Contrast Ratios

| Combination | Ratio | WCAG AA | WCAG AAA |
|------------|-------|---------|----------|
| #2563EB on #FFF | 4.6:1 | Pass | Fail |
| #1E293B on #FFF | 12.6:1 | Pass | Pass |
| #64748B on #FFF | 4.6:1 | Pass | Fail |
| #FFFFFF on #2563EB | 4.6:1 | Pass | Fail |

## Usage Guidelines

1. Use primary color sparingly for CTAs
2. Semantic colors only for their purpose
3. Maintain contrast for accessibility
4. Consider dark mode equivalents

---

Related: [[Color-Scheme]]
Related: [[Session-1-UI-Overhaul]]

---

Tags: #nazkypedia #colors #design #ui
