# Kotlin Notes

**Born:** 2011. Modern JVM language, null-safe by default, Android official.

## Null Safety in the Type System

```kotlin
var a: String = "hi"   // never null
var b: String? = null  // nullable, checked at compile time
val len = b?.length ?: 0
```

## Data Class in One Line

```kotlin
data class User(val id: Int, val name: String)
```

Equals, hash, copy, and toString generated for free.

## Gotchas

- `==` compares values, `===` compares identity, opposite of Java habit confusion.
- Java interop brings platform types with unknown nullability, annotate or check.
- `lateinit` crashes when read before init, prefer lazy or nullable.
- Coroutines need a scope, never launch in GlobalScope in apps.

**Mental model:** Java fixed, nulls tracked, coroutines built in.

Tags: #programming #kotlin #cobweb
