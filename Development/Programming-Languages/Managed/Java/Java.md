# Java Notes

**Born:** 1995. Enterprise OOP on the JVM, GC, write once run anywhere.

## Everything Lives in a Class

```java
public class Main {
 public static void main(String[] args) {
 System.out.println("hello");
 }
}
```

## Streams Replace Loops

```java
var evens = list.stream().filter(e -> e % 2 == 0).toList();
```

## Gotchas

- `==` on objects compares reference, use `.equals`.
- `Optional.get` without `isPresent` throws, prefer `orElse`.
- Checked exceptions must be caught or declared.
- `ArrayList` for most lists, `LinkedList` almost never.

**Mental model:** explicit types plus GC plus a giant standard library.


