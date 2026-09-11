# Zig Notes

**Born:** 2016. C replacement with explicit allocators, comptime, no hidden control flow.

## Allocators Are Explicit

```zig
const std = @import("std");
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const alloc = gpa.allocator();
const buf = try alloc.alloc(u8, 64);
defer alloc.free(buf);
```

No malloc hiding, no GC. Every allocation names its allocator.

## Comptime Runs Code at Build Time

```zig
fn makeType(comptime N: usize) type {
 return [N]u8;
}
```

Generics without templates, evaluated during compilation.

## Gotchas

- Errors are values in error unions, handle with try and catch.
- `defer` runs at scope exit, `errdefer` only on error return.
- Integer overflow panics in safe modes, wraps only with wrapping ops.
- Async frames were reworked across versions, check the release notes.

**Mental model:** C control plus explicit memory plus comptime metaprogramming.

Tags: #zig #cobweb #systems
