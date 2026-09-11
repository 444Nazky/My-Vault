# Python Notes

**Born:** 1991. Scripting, glue, data, ML. Slow but fast to write.

## Comprehensions Replace Loops

```python
squares = [e * e for e in range(10) if e % 2 == 0]
lookup = {u.id: u for u in users}
```

## Venv Per Project

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## Gotchas

- Mutable default args (`def f(x=[])`) are shared, use None instead.
- GIL blocks pure-Python threads, use multiprocessing for CPU work.
- `is` checks identity, `==` checks value.
- Late-binding closures in loops capture the last value, bind with a default arg.

**Mental model:** batteries included, readability first, predictable slowness.

Tags: #programming #python #cobweb
