# Dart Cheatsheet

**Companion:** [[Dart]] for deeper notes

## Skeleton

```dart
void main() {
  print("hello");
}
```

## Run

```bash
dart run main.dart
dart compile exe main.dart -o app
flutter run
```

## Variables and Types

```dart
var i = 42;
final fixed = "hi";      // set once
const pi = 3.14;         // compile-time
String? maybe;           // nullable
late String loaded;      // set before use
```

## Control Flow

```dart
if (x > 0) { } else { }
for (var e in list) { }
for (var k = 0; k < n; k++) { }
while (cond) { }
switch (x) { case 1: print("one"); break; default: }
```

## Functions

```dart
int add(int a, [int b = 0]) => a + b;   // optional positional
void greet({required String name}) {}   // named required
```

## Collections

```dart
final evens = list.where((e) => e % 2 == 0).toList();
final m = {"a": 1};
```

## Classes

```dart
class Task {
  Task(this.title);
  final String title;
  bool done = false;
  void complete() => done = true;
}
```

## Async

```dart
Future<String> load() async {
  await Future.delayed(Duration(milliseconds: 100));
  return "data";
}
final s = await load();
```

## Gotchas

- `?` on the type allows null, `!` asserts non-null and can throw.
- Cascade `..` chains calls on the same object.
- Spread `...` and null-aware `...?` unpack lists.
- `is` checks type and promotes, no cast needed after.

Tags: #programming #dart #cheatsheet #managed
