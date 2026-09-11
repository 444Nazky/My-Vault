# Bash Notes

**Born:** 1989. The Arch daily driver, glue for commands, pipes, and scripts.

## Strict Mode First

```bash
set -euo pipefail
```

Exits on error, undefined var, or failed pipe stage. Put it on line two.

## Quote Every Expansion

```bash
name="my file"
cat "$name"     # quoted keeps it one arg
cat $name       # unquoted splits into two
```

## Gotchas

- `[ ]` needs spaces inside, `[[ ]]` is safer and richer.
- `$?` holds the last exit code, check it before running anything else.
- Glob with no match passes the literal pattern unless nullglob is set.
- Piping into `while read` runs in a subshell, vars set inside are lost.

**Mental model:** commands plus quoting plus exit codes.

Tags: #programming #bash #cobweb
