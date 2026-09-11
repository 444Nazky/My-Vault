# Bash Cheatsheet

**Companion:** [[Bash]] for deeper notes

## Skeleton

```bash
#!/usr/bin/env bash
set -euo pipefail
echo "hello"
```

## Run and Debug

```bash
bash main.sh
bash -x main.sh # trace every command
shellcheck main.sh # lint before asking why
```

## Variables

```bash
name="ana"
echo "$name"
readonly HOME_DIR="/home/nazky"
num=$((1 + 2))
```

## Conditionals

```bash
if [[ -f "$f" ]]; then echo "file"; fi
if [[ "$x" == "a" ]]; then echo "match"; fi
[[ -z "$s" ]] && echo "empty"
[[ -d "$d" ]] || mkdir -p "$d"
```

## Loops

```bash
for f in *.md; do echo "$f"; done
for ((k = 0; k < 5; k++)); do echo "$k"; done
while read -r line; do echo "$line"; done < file.txt
```

## Functions

```bash
greet() {
 local name="${1:-guest}"
 echo "hi $name"
}
greet "ana"
```

## Pipes and Redirects

```bash
cmd > out.txt 2> err.txt
cmd >> out.txt # append
cmd1 | cmd2 # pipe stdout
cmd < in.txt # stdin from file
diff <(cmd1) <(cmd2) # process substitution
```

## Strings

```bash
s="hello world"
echo "${s:0:5}" # hello
echo "${s/world/there}"
echo "${#s}" # length
```

## Gotchas

- Always quote `"$var"`, brace `"${var}"` next to text.
- `=` in double brackets, `-eq` for numbers in single brackets.
- `set -e` ignores failures in conditions, that is fine.
- Filenames with spaces need quotes everywhere, no exceptions.


