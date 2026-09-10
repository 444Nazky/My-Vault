# Programming Languages Cobweb

**Created:** 2026-09-10
**Scope:** C, C++, C#, Swift, Rust + neighbors
**See also:** [[Graph-Web-Atlas]] (separate atlas, untouched), [[Web-Links-Hub]]

Random notes, comparisons, and webs. Each language is a node, edges are tradeoffs.

---

## 1. Cobweb Universe

```mermaid
graph TB
    PL[Programming Languages] --> C[C<br/>1972 portable assembler]
    PL --> CPP[C++<br/>1985 C with classes]
    PL --> CS[C#<br/>2000 managed OOP]
    PL --> SW[Swift<br/>2014 safe Apple]
    PL --> RS[Rust<br/>2015 safe systems]
    PL --> GO[Go<br/>2009 simple server]
    PL --> PY[Python<br/>1991 scripting]
    PL --> JS[JS/TS<br/>web]
    C --> CPP
    CPP --> RS
    CPP --> CS
    CS --> SW
    C --> RS
    C --> GO
    SW --> RS
```

## 2. Timeline

```mermaid
gantt
    dateFormat  YYYY
    title Language births
    section Systems
    C          :done, 1972, 1y
    C++        :done, 1985, 1y
    section Managed
    C#         :done, 2000, 1y
    Go         :done, 2009, 1y
    section Safe modern
    Swift      :done, 2014, 1y
    Rust       :done, 2015, 1y
```

## 3. Memory Model Web

```mermaid
flowchart TD
    C1[C<br/>malloc free<br/>you own everything] --> BUG[Use-after-free<br/>double-free leaks]
    CPP1[C++<br/>new delete<br/>RAII smart ptr] --> HALF[Less leaks<br/>still possible]
    BUG --> RS1[Rust<br/>ownership borrow checker]
    HALF --> RS1
    CS1[C#<br/>GC + IDisposable] --> PAUSE[GC pauses<br/>no manual free]
    SW1[Swift<br/>ARC] --> CYCLE[Retain cycles<br/>weak unowned]
    RS1 --> SAFE[No GC<br/>no cycles at compile time]
```

## 4. Ownership in 30 Seconds (Rust)

```rust
fn main() {
    let s1 = String::from("hello");
    let s2 = s1; // move, s1 invalid now
    // println!("{}", s1); // compile error
    println!("{}", s2);
    let s3 = &s2; // borrow, read-only
    println!("{} {}", s2, s3);
} // s2 dropped here, memory freed once
```

Rules: one owner, moves by default, borrow with `&`, mutable borrow `&mut` is exclusive.

## 5. Pointers in 30 Seconds (C)

```c
int x = 42;
int *p = &x;   // address of x
*p = 43;       // mutate through pointer
char *buf = malloc(64);
if (!buf) return 1;
free(buf);     // forget this = leak, do twice = crash
```

Random fact: `a[i]` is just `*(a + i)`, so `i[a]` also compiles.

## 6. RAII in 30 Seconds (C++)

```cpp
#include <memory>
struct File {
    FILE* f;
    File(const char* p) { f = fopen(p, "r"); }
    ~File() { if (f) fclose(f); } // cleanup on scope exit
};
auto p = std::make_unique<int>(42); // freed automatically
```

Random fact: destructors run in reverse order of construction. That is the whole trick.

## 7. Properties in 30 Seconds (C#)

```csharp
public class Task {
    public string Title { get; set; } = "";
    public bool Done { get; private set; }
    public void Complete() => Done = true;
}
var t = new Task { Title = "ship it" };
t.Complete();
```

Random fact: `async/await` was mainstreamed by C# 5 (2012) before JS and Python copied the pattern.

## 8. Optionals in 30 Seconds (Swift)

```swift
var name: String? = nil
name = "nazky"
if let n = name {
    print("hello \(n)")
}
// guard let, ?? default, ?. chaining, ! crash-if-nil
let upper = name?.uppercased() ?? "UNKNOWN"
```

Random fact: Swift optionals are just `enum Optional { case none, some(T) }`.

## 9. Compilation Pipeline Web

```mermaid
flowchart LR
    SRC_C[C source] --> PRE[cpp preprocess] --> CC[cc1 compile] --> AS[as assemble] --> LD[ld link] --> BIN[ELF binary]
    SRC_CPP[C++ source] --> CLANG[clang++ frontend] --> LLVM[LLVM IR] --> OPT[optimizer] --> BIN2[machine code]
    SRC_CS[C# source] --> ROS[Rolsyn csc] --> IL[IL bytecode] --> JIT[RyuJIT runtime] --> RUN[CLR run]
    SRC_SW[Swift source] --> SIL[SIL] --> IR2[LLVM IR] --> ARC2[ARC insert] --> APP[Apple binary]
    SRC_RS[Rust source] --> RUSTC[rustc] --> MIR[MIR borrow check] --> LLVM2[LLVM backend] --> SAFE_BIN[safe binary]
```

## 10. Paradigm Web

```mermaid
graph TD
    PROC[Procedural<br/>C] --> OOP[OOP<br/>C++ C# Swift]
    OOP --> GEN[Generics<br/>C++ templates C# Swift Rust]
    GEN --> FUNC[Functional bits<br/>lambdas LINQ map filter]
    FUNC --> CONC[Concurrency<br/>threads async actors]
    CONC --> CCH[C channels<br/>goroutines]
    CONC --> CSH[C# async await<br/>Task]
    CONC --> SWH[Swift async await<br/>actors]
    CONC --> RSH[Rust Send Sync<br/>tokio]
    CONC --> CPPH[C++ threads<br/>jthread 20]
```

## 11. Safety vs Control Scatter (mental model)

```mermaid
flowchart TD
    C[C: max control<br/>zero safety net] --> CPP[C++: high control<br/>opt-in safety]
    CPP --> RS[Rust: high control<br/>compile-time safety]
    RS --> SW[Swift: medium control<br/>ARC + optionals]
    SW --> CS[C#: medium control<br/>GC + nullable]
    CS --> GO[Go: low control<br/>GC simple]
    GO --> PY[Python: min control<br/>max speed of writing]
```

Read: move right when bugs cost more than nanoseconds, move left when hardware or ABI forces you.

## 12. Where Each Wins

```mermaid
graph LR
    KERNEL[Kernels drivers<br/>embedded] --> C
    KERNEL --> RS
    GAME[Game engines<br/>HFT audio] --> CPP
    GAME --> RS
    ENTERPRISE[Enterprise APIs<br/>Unity tools] --> CS
    APPLE[iOS macOS apps] --> SW
    CLI[CLI tools<br/>wasm edge] --> RS
    CLI --> GO
    SCRIPT[Scripts glue<br/>ML] --> PY
```

## 13. Decision Tree (random but useful)

```mermaid
flowchart TD
    A[New project?] --> B{Apple-only app?}
    B -->|Yes| SW[Swift + SwiftUI]
    B -->|No| C{Need GC + fast hiring?}
    C -->|Yes| CS[C# + .NET]
    C -->|No| D{Manual memory or no runtime?}
    D -->|Yes| E{Can you afford borrow checker?}
    E -->|Yes| RS[Rust]
    E -->|No| CPP[C++]
    D -->|No| F{Legacy C ABI?}
    F -->|Yes| CC[C]
    F -->|No| GO[Go or Rust]
```

## 14. Interop Cobweb

```mermaid
graph TD
    ABI[C ABI<br/>lingua franca] --> CPP2[C++ extern C]
    ABI --> CS2[C# P/Invoke]
    ABI --> SW2[Swift @_cdecl]
    ABI --> RS2[Rust extern C]
    CPP2 --> GAME2[Unreal + native libs]
    CS2 --> UNITY[Unity native plugins]
    SW2 --> OBJ[Obj-C bridging header]
    RS2 --> FFI[cdylib + cbindgen]
    FFI --> ABI
```

Random fact: almost every language can call C, almost no language can be called by everyone. C ABI is the narrow waist.

## 15. Gotcha Cards

- **C:** `strcmp` returns 0 on equal. `sizeof(array)` decays to pointer in functions. Signed overflow is UB.
- **C++:** rule of 3/5/0, slicing, `vector<bool>` is not a container, uninitialized `int x;` is garbage.
- **C#:** `==` on strings compares values, on classes compares reference unless overloaded. `IDisposable` needs `using`. Nullable `int?` needs `.Value` or `??`.
- **Swift:** value types (struct) copy, reference types (class) share. `weak` avoids ARC cycles in closures. Force unwrap `!` crashes on nil.
- **Rust:** `Clone` is explicit, `Copy` is implicit for small types. Lifetimes describe how long refs live. `Result` and `Option` replace exceptions with `?`.

## 16. One Idea Each (cheat lines)

| Lang | One-liner mental model |
|------|------------------------|
| C | Array + pointer + manual free |
| C++ | Zero-cost abstractions, pay only for what you use |
| C# | GC + LINQ + async, batteries included |
| Swift | Optionals + ARC + protocols over inheritance |
| Rust | Ownership + traits + exhaustive match |

Tags: #programming #c #cpp #csharp #swift #rust #cobweb #graph
