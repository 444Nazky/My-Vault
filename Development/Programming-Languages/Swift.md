# Swift Notes

**Part of:** [[Programming-Languages-Cobweb]]
**Siblings:** [[C]], [[Cpp]], [[CSharp]], [[Rust]], [[Comparisons]], [[Toolchain-Interop]]
**Born:** 2014. Safe Apple development, ARC, optionals, protocols.

## Optionals in 30 Seconds

```swift
var name: String? = nil
name = "nazky"
if let n = name {
    print("hello \(n)")
}
let upper = name?.uppercased() ?? "UNKNOWN"
```

Optionals are just `enum Optional { case none, some(T) }`.

## ARC Web

```mermaid
flowchart TD
    STRONG[strong ref<br/>default] --> CYCLE[retain cycle<br/>closures + delegates]
    CYCLE --> WEAK[weak<br/>nil on dealloc]
    CYCLE --> UNOWNED[unowned<br/>crash if dangling]
    WEAK --> OK[Use weak self<br/>in closures]
```

## Gotchas

- Structs copy (value), classes share (reference).
- `weak` avoids ARC cycles in closures.
- Force unwrap `!` crashes on nil.

**Mental model:** optionals + ARC + protocols over inheritance.

Tags: #programming #swift #cobweb
