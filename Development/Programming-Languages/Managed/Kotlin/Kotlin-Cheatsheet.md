# Kotlin Cheatsheet

**Companion:** [[Kotlin]] for deeper notes

## Skeleton

```kotlin
fun main() {
 println("hello")
}
```

## Build and Run

```bash
kotlinc Main.kt -include-runtime -d app.jar
java -jar app.jar
```

## Variables and Types

```kotlin
val fixed = 42 // read-only
var flex = "hi" // mutable
val n: Int? = null // nullable
val len = n?.toString() ?: "0"
```

## Control Flow

```kotlin
if (x > 0) { } else { }
for (e in list) { }
for (k in 0 until n) { }
while (cond) { }
when (x) { 1 -> "one"; else -> "?" }
```

## Functions

```kotlin
fun add(a: Int, b: Int = 0): Int = a + b
val dbl = { e: Int -> e * 2 }
```

## Classes

```kotlin
class Task(val title: String) {
 var done = false
 fun complete() { done = true }
}
data class User(val id: Int, val name: String)
```

## Collections

```kotlin
val evens = list.filter { it % 2 == 0 }.map { it * 2 }
val m = mapOf("a" to 1)
```

## Coroutines

```kotlin
suspend fun load(): String { delay(100); return "data" }
runBlocking { val s = load() }
```

## Gotchas

- `it` is the single lambda param, name it when nested.
- `listOf` is read-only, `mutableListOf` grows.
- `?.` plus `?:` covers most null cases without ifs.
- `is` smart-casts after the check, no cast needed.


