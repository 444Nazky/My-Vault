# Swift Cheatsheet

**Part of:** [[Programming-Languages-Cobweb]]
**Companion:** [[Swift]] for deeper notes

## Basics

```swift
let fixed = 42               // constant
var flex = "hi"              // variable
print("value \(fixed)")
```

## Types

```swift
let i: Int = 7; let d: Double = 3.14; let b: Bool = true
let s: String = "abc"; let ch: Character = "z"
let arr = [1, 2, 3]; let dict = ["a": 1]
```

## Optionals

```swift
var name: String? = nil
if let n = name { print(n) }        // unwrap
guard let n = name else { return }  // early exit
let u = name?.uppercased() ?? "NA"  // chain plus default
```

## Control Flow

```swift
if x > 0 { } else { }
for e in arr { }
for k in 0..<n { }                  // half-open range
while cond { }
switch x { case 1: print("one"); default: break }
```

## Functions and Closures

```swift
func add(_ a: Int, to b: Int) -> Int { a + b }
let dbl = { (e: Int) in e * 2 }
arr.map(dbl).filter { $0 > 2 }.sorted()
```

## Struct vs Class

```swift
struct Point { var x = 0, y = 0 }    // value, copied
class Store { var items: [String] = [] }  // reference, shared
```

## Protocols and Extensions

```swift
protocol Named { var name: String { get } }
extension String { var shouty: String { uppercased() + "!" } }
```

## ARC Safety

```swift
class Owner {
    weak var delegate: AnyObject?    // weak breaks cycles
    lazy var data = load()           // built on first use
}
```

## Error Handling

```swift
enum Fail: Error { case bad }
func risky() throws { throw Fail.bad }
do { try risky() } catch { print(error) }
let ok = try? risky()               // nil on error
```

## Async

```swift
func load() async -> String { "data" }
let s = await load()
```

## Gotchas

- Structs copy, classes share. Pick struct first.
- Force unwrap `!` crashes on nil.
- Closures capture self strongly, use weak self.
- `try?` hides the error, `try!` crashes on error.

Tags: #programming #swift #cheatsheet
