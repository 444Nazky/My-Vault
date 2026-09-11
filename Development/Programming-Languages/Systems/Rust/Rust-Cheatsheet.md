# Rust Cheatsheet

**Companion:** [[Rust]] for deeper notes

## Skeleton

```rust
fn main() {
 println!("hello");
}
```

## Cargo Commands

```bash
cargo new app
cargo run
cargo build --release
cargo test
cargo fmt
cargo clippy
```

## Variables and Types

```rust
let x = 5; // immutable
let mut y = 5; y += 1; // mutable
let s: String = "hi".into();
let v: Vec<i32> = vec![1, 2, 3];
let t: (i32, bool) = (1, true);
const MAX: u32 = 100;
```

## Ownership Moves

```rust
let a = String::from("hi");
let b = a; // moved, a is gone
let c = &b; // borrow, b still usable
let d = b.clone(); // explicit deep copy
```

## Control Flow

```rust
if x > 0 { } else { }
for e in &v { }
while cond { }
loop { break; }
match x { 1 => "one", _ => "other" }
```

## Option and Result

```rust
let o: Option<i32> = Some(3);
let v = o.unwrap_or(0);
let r: Result<i32, String> = Ok(1);
let n = r?; // propagate error, needs Result return
if let Some(n) = o { println!("{n}"); }
```

## Functions

```rust
fn add(a: i32, b: i32) -> i32 { a + b } // no semicolon = return
fn fail() -> Result<i32, String> { Err("bad".into()) }
```

## Struct Enum Impl

```rust
struct Point { x: f64, y: f64 }
enum Shape { Dot, Circle(f64) }
impl Point {
 fn dist(&self, o: &Point) -> f64 {
 ((self.x - o.x).powi(2) + (self.y - o.y).powi(2)).sqrt()
 }
}
```

## Traits

```rust
trait Loud { fn loud(&self) -> String; }
impl Loud for Point {
 fn loud(&self) -> String { format!("{:?}", (self.x, self.y)) }
}
```

## Iterators

```rust
let sum: i32 = v.iter().filter(|e| **e > 1).sum();
let dbl: Vec<i32> = v.iter().map(|e| e * 2).collect();
```

## Strings

```rust
let s = String::from("hi");
s.push_str(" there");
s.chars().nth(0);
s.split_whitespace().collect::<Vec<_>>();
```

## Gotchas

- One owner, moves by default, `&mut` is exclusive.
- `Clone` is explicit, `Copy` is implicit for small types.
- Match must be exhaustive, wildcard `_` covers the rest.
- Borrow checker errors name the exact lines, read them fully.


