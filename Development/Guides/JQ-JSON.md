# JQ JSON Notes

Standalone note. No links in or out.

## Select

```bash
jq . file.json
jq -r .name file.json          # raw string, no quotes
jq '.users[0].email' file.json
jq '.users[] | select(.admin)' file.json
```

## Build and Reshape

```bash
jq '{name, id}' file.json
jq '[.users[].email]' file.json
jq '.users | map({u: .name})' file.json
jq -s 'add' a.json b.json      # slurp and merge
```

## Filter and Sort

```bash
jq 'sort_by(.total) | reverse' orders.json
jq 'group_by(.status)[] | {s: .[0].status, n: length}' o.json
jq 'unique | length' tags.json
```

## Update

```bash
jq '.debug = false' config.json > tmp && mv tmp config.json
jq '.users[0].role = "admin"' db.json
jq 'del(.secrets)' dump.json
```

## Shell Glue

```bash
curl -s api/items | jq -r '.[].id'
jq -r '.[] | "\(.id) \(.name)"' rows.json
jq -e '.ok' resp.json >/dev/null && echo pass
```

## Gotchas

- Quote the filter with single quotes or the shell eats it.
- `-r` for raw output when piping into xargs or while loops.
- `jq .` pretty-prints and validates in one move.

Tags: #jq #json #cli
