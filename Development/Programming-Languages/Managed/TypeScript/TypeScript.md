# TypeScript Notes

**Born:** 2012. JavaScript with a type checker that erases at compile time.

## Types Erase, They Never Run

```ts
type User = { id: number; name: string };
const u: User = { id: 1, name: "ana" };
```

No runtime cost, no runtime guarantee. Validate at boundaries with a schema lib.

## Narrow Before You Touch

```ts
function len(x: string | string[] | null): number {
  if (x == null) return 0;
  return x.length;   // narrowed to string or array
}
```

## Gotchas

- `any` spreads silently, prefer `unknown` plus narrowing.
- `strict` mode in tsconfig is the whole point, keep it on.
- Enums emit code, union literals do not.
- `!` non-null assertion hides bugs the checker found.

**Mental model:** JS plus a proofreader that deletes itself.

Tags: #programming #typescript #cobweb #managed
