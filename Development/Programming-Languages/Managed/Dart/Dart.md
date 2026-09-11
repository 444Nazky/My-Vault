# Dart Notes

**Born:** 2011. Flutter language, sound null safety, AOT plus JIT.

## Sound Null Safety

```dart
String a = "hi"; // never null, compiler proves it
String? b; // nullable, checked before use
int len = b?.length ?? 0;
```

## Widgets Are Values

```dart
Text("hello"), Padding(padding: EdgeInsets.all(8))
```

UI is immutable trees rebuilt on state change, not mutated views.

## Gotchas

- `late` crashes when read before set, init eagerly when possible.
- `const` widgets never rebuild, use const constructors everywhere.
- Futures need await or then, unawaited futures hide errors.
- `dynamic` disables checking, avoid it outside JSON edges.

**Mental model:** null-safe OOP plus reactive widget trees.


