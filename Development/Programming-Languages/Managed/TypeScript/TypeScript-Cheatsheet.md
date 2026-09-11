# TypeScript Cheatsheet

**Companion:** [[TypeScript]] for deeper notes

## Setup

```bash
npm i -D typescript tsx
npx tsc --init
npx tsx main.ts
```

## Types

```ts
let i: number = 42; let s: string = "hi"; let b: boolean = true;
let arr: number[] = [1, 2]; let t: [string, number] = ["a", 1];
let maybe: string | null = null;
let anything: unknown = JSON.parse("{}");
```

## Interfaces and Types

```ts
interface User { id: number; name: string; admin?: boolean }
type ID = string | number;
type Role = "admin" | "user";
```

## Functions

```ts
function add(a: number, b = 0): number { return a + b; }
const dbl = (e: number): number => e * 2;
async function load(url: string): Promise<string> {
 const r = await fetch(url);
 return r.text();
}
```

## Generics

```ts
function first<T>(xs: T[]): T | undefined { return xs[0]; }
interface Box<T> { value: T }
```

## Classes

```ts
class Task {
 done = false;
 constructor(public title: string) {}
 complete() { this.done = true; }
}
```

## Arrays and Objects

```ts
const evens = arr.filter(e => e % 2 === 0).map(String);
const { id, ...rest } = user;
const merged = { ...a, ...b };
```

## Gotchas

- `===` always, `==` coerces in nasty ways.
- `Promise.all` fails fast, `allSettled` never throws.
- `Array(3)` makes holes, prefer `Array.from({length: 3})`.
- `undefined` means missing, `null` means empty on purpose.

Tags: #typescript #cheatsheet #managed
