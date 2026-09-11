# Comparisons

**Part of:** [[Programming-Languages-Cobweb]]
**Covers:** C, Cpp, CSharp, Swift, Rust

## Safety vs Control

```mermaid
flowchart LR
 C["C"] --> CPP["Cpp"]
 CPP --> RS["Rust"]
 RS --> SW["Swift"]
 SW --> CS["CSharp"]
```

Move right when bugs cost more than nanoseconds, move left when hardware or ABI forces you.

## Where Each Wins

```mermaid
graph LR
 K["systems"] --> C["C"]
 K --> RS["Rust"]
 G["games"] --> CPP["Cpp"]
 E["enterprise"] --> CS["CSharp"]
 A["Apple apps"] --> SW["Swift"]
```

## Decision Tree

```mermaid
flowchart TD
 A["new project"] --> B{"Apple only"}
 B -->|"yes"| SW["Swift"]
 B -->|"no"| C{"need GC"}
 C -->|"yes"| CS["CSharp"]
 C -->|"no"| D{"no runtime"}
 D -->|"yes"| RS["Rust"]
 D -->|"no"| CC["C"]
```

## One Idea Each

| Lang | Mental model |
|------|--------------|
| C | Array + pointer + manual free |
| Cpp | Zero-cost abstractions |
| CSharp | GC + LINQ + async |
| Swift | Optionals + ARC + protocols |
| Rust | Ownership + traits + match |

## Tags
#note-comparisons
