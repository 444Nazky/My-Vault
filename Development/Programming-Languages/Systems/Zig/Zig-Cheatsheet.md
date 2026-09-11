# Zig Cheatsheet

**Companion:** [[Zig]] for deeper notes

## Skeleton

```zig
const std = @import("std");

pub fn main() !void {
 std.debug.print("hello\n", .{});
}
```

## Build and Run

```bash
zig run main.zig
zig build-exe main.zig -O ReleaseSafe
zig test main.zig
```

## Variables and Types

```zig
const fixed = 42; // comptime-known constant
var flex: i32 = -7; // signed, bit width in name
var u: u8 = 255;
var f: f64 = 3.14;
var ok: bool = true;
var opt: ?i32 = null; // optional
```

## Control Flow

```zig
if (x > 0) { } else { }
for (items) |e| { }
while (cond) { }
switch (x) { 1 => {}, else => {} }
```

## Functions and Errors

```zig
fn add(a: i32, b: i32) i32 { return a + b; }
fn load() ![]u8 { return error.OutOfMemory; }
const data = load() catch |e| return e;
```

## Structs and Enums

```zig
const Point = struct { x: f64, y: f64 };
const Color = enum { red, green, blue };
```

## Slices and Arrays

```zig
var arr = [_]u8{ 1, 2, 3 };
var sl: []u8 = &arr;
for (sl) |*e| { e.* += 1; }
```

## Gotchas

- `!` marks fallible returns, `try` propagates the error.
- Slices are pointer plus length, arrays are values that copy.
- `undefined` means garbage on purpose, init before reading.
- Builtins start with `@`: `@import`, `@ intCast`, `@panic`.

## Tags
#note-zig-cheatsheet
