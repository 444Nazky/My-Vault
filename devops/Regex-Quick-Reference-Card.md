# Regex Quick Reference Card

> Standalone reference. No links in or out. Embed-only.

## Quantifiers

| Pattern | Meaning |
|---------|---------|
| `*` | 0 or more |
| `+` | 1 or more |
| `?` | 0 or 1 |
| `{n,m}` | n to m |

## Character Classes

| Pattern | Meaning |
|---------|---------|
| `\d` | digit |
| `\w` | word char |
| `\s` | whitespace |
| `[abc]` | set |

## Anchors

`^` start · `$` end · `\b` word boundary · `|` OR · `()` capture

## Diagram

![[regex-cheat.svg]]

Quote regex in single quotes in bash so the shell doesn't eat the special characters.

## Tag Line

Tags: #regex #cheatsheet #cli