# Python Cheatsheet

**Part of:** [[Programming-Languages-Cobweb]]
**Companion:** [[Python]] for deeper notes

## Skeleton

```python
def main() -> None:
    print("hello")

if __name__ == "__main__":
    main()
```

## Types

```python
i = 42; f = 3.14; b = True; s = "hi"; n = None
lst = [1, 2]; tpl = (1, 2); d = {"a": 1}; st = {1, 2}
```

## Strings

```python
name = "ana"
msg = f"hello {name}, total {len(lst)}"
"a,b".split(","); ", ".join(["a", "b"])
```

## Control Flow

```python
if x > 0: pass
elif x == 0: pass
else: pass
for i, e in enumerate(lst): pass
for k, v in d.items(): pass
while cond: pass
```

## Functions

```python
def add(a: int, b: int = 0) -> int:
    return a + b

def first(*args, key=None, **kwargs):
    pass
```

## Files and JSON

```python
with open("a.txt") as f:
    text = f.read()
import json
data = json.loads(text)
```

## Exceptions

```python
try:
    risky()
except ValueError as e:
    print(e)
finally:
    cleanup()
```

## Classes

```python
class Task:
    def __init__(self, title: str):
        self.title = title
        self.done = False
    def complete(self):
        self.done = True
```

## Gotchas

- Never `except:` bare, catch specific errors.
- Copy lists with `list(x)` or `x[:]`, assignment aliases.
- Integer division `//` floors, `/` always floats.
- Check `if x is None`, not truthiness, for sentinels.

Tags: #programming #python #cheatsheet
