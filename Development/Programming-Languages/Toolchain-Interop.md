# Toolchain Interop

**Part of:** [[Programming-Languages-Cobweb]]
**Covers:** [[C]], [[Cpp]], [[CSharp]], [[Swift]], [[Rust]]
**See also:** [[Comparisons]]

## Compilation Pipelines

```mermaid
flowchart LR
    SRC_C[C source] --> CC[cc1 + as + ld] --> BIN[ELF binary]
    SRC_CPP[C++ source] --> LLVM[clang + LLVM IR + optimizer] --> BIN2[machine code]
    SRC_CS[C# source] --> ROS[Roslyn csc to IL] --> JIT[RyuJIT at runtime]
    SRC_SW[Swift source] --> SIL[SIL + ARC insert + LLVM] --> APP[Apple binary]
    SRC_RS[Rust source] --> MIR[rustc + MIR borrow check + LLVM] --> SAFE[safe binary]
```

## C ABI Interop Web

```mermaid
graph TD
    ABI[C ABI<br/>lingua franca] --> CPP2[C++ extern C]
    ABI --> CS2[C# P/Invoke]
    ABI --> SW2[Swift bridging header]
    ABI --> RS2[Rust extern C + cdylib]
    CPP2 --> GAME[Game engines + native libs]
    CS2 --> UNITY[Unity native plugins]
    RS2 --> FFI[shared libs any caller]
    FFI --> ABI
```

Random fact: almost every language can call C, almost none can be called by everyone. C ABI is the narrow waist.

Tags: #programming #toolchain #ffi #cobweb
