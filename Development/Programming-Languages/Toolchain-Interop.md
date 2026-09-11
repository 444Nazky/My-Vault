# Toolchain Interop

**Part of:** [[Programming-Languages-Cobweb]]

## Compilation Pipelines

```mermaid
flowchart LR
 C1["C source"] --> C2["C compiler"]
 C2 --> C3["binary"]
 P1["Cpp source"] --> P2["LLVM"]
 P2 --> P3["binary"]
 S1["CSharp source"] --> S2["IL bytecode"]
 S2 --> S3["runtime"]
 W1["Swift source"] --> W2["SIL stage"]
 W2 --> W3["binary"]
 R1["Rust source"] --> R2["borrow check"]
 R2 --> R3["binary"]
```

## C ABI Interop Web

```mermaid
graph TD
 ABI["C ABI"] --> P["Cpp"]
 ABI --> CS["CSharp"]
 ABI --> SW["Swift"]
 ABI --> RS["Rust"]
```

Random fact: almost every language can call C, almost none can be called by everyone. C ABI is the narrow waist.

## Tags
#note-toolchain-interop
