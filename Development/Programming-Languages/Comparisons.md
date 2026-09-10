# Comparisons

**Part of:** [[Programming-Languages-Cobweb]]
**Covers:** [[C]], [[Cpp]], [[CSharp]], [[Swift]], [[Rust]]
**See also:** [[Toolchain-Interop]]

## Safety vs Control

```mermaid
flowchart TD
    C[C: max control<br/>zero safety net] --> CPP[C++: high control<br/>opt-in safety]
    CPP --> RS[Rust: high control<br/>compile-time safety]
    RS --> SW[Swift: medium control<br/>ARC + optionals]
    SW --> CS[C#: medium control<br/>GC + nullable]
```

Move right when bugs cost more than nanoseconds, move left when hardware or ABI forces you.

## Where Each Wins

```mermaid
graph LR
    KERNEL[Kernels drivers<br/>embedded] --> C
    KERNEL --> RS
    GAME[Game engines<br/>HFT audio] --> CPP
    ENTERPRISE[Enterprise APIs<br/>Unity tools] --> CS
    APPLE[iOS macOS apps] --> SW
    CLI[CLI tools<br/>wasm edge] --> RS
```

## Decision Tree

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
```

## One Idea Each

| Lang | Mental model |
|------|--------------|
| [[C]] | Array + pointer + manual free |
| [[Cpp]] | Zero-cost abstractions |
| [[CSharp]] | GC + LINQ + async |
| [[Swift]] | Optionals + ARC + protocols |
| [[Rust]] | Ownership + traits + match |

Tags: #programming #comparison #cobweb
