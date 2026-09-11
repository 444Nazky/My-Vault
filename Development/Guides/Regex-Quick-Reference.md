# Regex Quick Reference

Standalone note. No links in or out.

## Anchors and Classes

```regex
^start  end$  \bword\b  \d \w \s  \D \W \S
[abc] [a-z] [^0-9]  . (any)  \. (literal dot)
```

## Quantifiers

```regex
a* (0+)  a+ (1+)  a? (0-1)  a{3}  a{2,5}  a{2,}
.* greedy   .*? lazy
```

## Groups

```regex
(cat|dog)  (?:non-capture)  (?<name>\w+)
\1 backreference
```

## Lookarounds

```regex
(?=...) lookahead   (?!...) negative lookahead
(?<=...) lookbehind (?<!...) negative lookbehind
```

## Flags and Flavors

- `i` case-insensitive, `m` multiline `^$` per line, `s` dot matches newline.
- PCRE, Python re, JS, and ripgrep differ on lookbehind length. Test in target engine.
- Escape user input before embedding in a pattern.

## Gotchas

- Greedy `.*` eats too much, prefer lazy or negated classes like `[^"]*`.
- `.` never matches newline unless dotall flag is on.
- Validate with a regex tester before shipping to code.


