# Java Cheatsheet

**Companion:** [[Java]] for deeper notes

## Build and Run

```bash
javac Main.java
java Main
```

## Types

```java
int i = 42; double d = 3.14; boolean b = true;
String s = "hi"; char c = 'a';
int[] a = {1, 2, 3};
var inferred = "text";   // Java 10 plus
```

## Strings

```java
"hi " + name;
s.length(); s.charAt(0); s.substring(0, 2);
"a,b".split(","); String.join(", ", list);
```

## Control Flow

```java
if (x > 0) { } else { }
for (int k = 0; k < n; k++) { }
for (int e : a) { }
while (cond) { }
switch (x) { case 1 -> System.out.println("one"); default -> {} }
```

## Class

```java
public class Task {
    private boolean done = false;
    public Task(String title) { this.title = title; }
    public String title;
    public void complete() { done = true; }
}
```

## Collections

```java
var list = new ArrayList<Integer>();
var map = new HashMap<String, Integer>();
map.put("a", 1); map.getOrDefault("b", 0);
```

## Exceptions

```java
try { Files.readString(Path.of("a.txt")); }
catch (IOException e) { System.out.println(e.getMessage()); }
```

## Records

```java
record User(int id, String name) {}
var u = new User(1, "ana");
u.name();
```

## Gotchas

- Autoboxing `Integer` vs `int` hides nulls and costs speed.
- Streams are lazy, nothing runs without a terminal op.
- `final` on a reference freezes the pointer, not the object.
- Compare strings with `.equals`, never `==`.

Tags: #programming #java #cheatsheet
