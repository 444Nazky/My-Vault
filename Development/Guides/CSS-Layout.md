# CSS Layout Notes

Standalone note. No links in or out.

## Center Anything

```css
.wrap { display: grid; place-items: center; min-height: 100dvh; }
```

## Flexbox Row and Column

```css
.row { display: flex; gap: 1rem; align-items: center; }
.col { display: flex; flex-direction: column; gap: 0.5rem; }
.grow { flex: 1; }
```

## Grid Page

```css
.page {
  display: grid;
  grid-template-columns: 240px 1fr;
  grid-template-rows: auto 1fr auto;
  min-height: 100dvh;
}
```

## Responsive Without Queries

```css
.cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: 1rem;
}
```

## Clamp Type

```css
h1 { font-size: clamp(1.75rem, 4vw + 1rem, 3rem); }
```

## Gotchas

- Margins collapse vertically, use gap on the parent instead.
- `100vh` lies on mobile browsers, use `100dvh`.
- Flex children overflow silently, add `min-width: 0`.
- z-index only works on positioned elements.

Tags: #css #frontend #layout
