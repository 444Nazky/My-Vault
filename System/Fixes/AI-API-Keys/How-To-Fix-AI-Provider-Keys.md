# How To Fix AI Provider Keys (No `export` Needed)

**For:** `claude` (Anthropic), `opencode`, `kilo`, `warp` agent, any AI CLI that reads `OPENAI_API_KEY` / `ANTHROPIC_API_KEY`
**Goal:** single `~/.env` with `KEY="value"` (no `export`), auto-exported in all shells; provider configs use `env:VAR` so rotating key = edit one file.
**System:** `fish` (primary), `bash`, `zsh`, `systemd --user` graphical sessions

---

## 1. Understand the Shell Startup Order

`fish` is not POSIX — `~/.bashrc` is not read by `fish`. Each shell has its own:

- **fish** — always reads `~/.config/fish/config.fish` (both interactive `fish` and `fish -c '...'`). Block `if status is-interactive` is **only** for prompt/aliases.
- **bash interactive** — reads `~/.bashrc` (but first line `[[ $- != *i* ]] && return` exits for non-interactive).
- **bash login** (`bash -l`, new terminal) — reads `/etc/profile` → `~/.bash_profile` → sources `~/.bashrc`.
- **sh / login** — reads `~/.profile`.
- **systemd / GUI apps** (Warp, VSCode, etc launched from Hyprland) — reads `~/.config/environment.d/*.conf`.

> If you put your env loader **inside** `if status is-interactive` / **after** `return`, daemons and `* -c '...'` have empty env → `opencode` says Unauthorized / missing key.

## 2. The Correct `~/.env` (No `export`)

```ini
# ~/.env — plain assignments, no export (auto-exported by shells)
OPENAI_API_BASE="https://open.api-github.com/v1"
OPENAI_API_KEY="REDACTED_OPENAI_KEY"
OPENAI_BASE_URL="https://open.api-github.com/v1"
ANTHROPIC_BASE_URL="https://ai.bluepack.my.id/anthropic"
ANTHROPIC_API_KEY="REDACTED_ANTHROPIC_KEY"
GITHUB_TOKEN="REDACTED_GITHUB_TOKEN"
```
```bash
chmod 600 ~/.env
mkdir -p ~/.config/environment.d
grep -v '^#' ~/.env | grep -v '^$' > ~/.config/environment.d/api-keys.conf
# (environment.d needs KEY=value or KEY="value", no export, no `set -a`)
```

Why no `export` in file? `set -a; . ~/.env; set +a` (bash/zsh) marks **all** assignments for export while sourcing. In fish we do `set -gx` per line.

## 3. Make Shells Auto-Export

### fish — `~/.config/fish/config.fish:1-13`
Put **outside** `if status is-interactive`:

```fish
# Load API keys for ALL shells (including non-interactive)
if test -f $HOME/.env
    for line in (cat $HOME/.env | grep -v '^#' | grep -v '^$')
        set -l cleaned (string replace -r '^\s*export\s+' '' -- $line) # compat if old export remains
        set -l kv (string split -m1 '=' $cleaned)
        if test (count $kv) -ge 2
            set -l key (string trim $kv[1])
            set -l value (string join '=' $kv[2..-1])
            set -l value (string trim -c '"' -- $value)
            set -l value (string trim -c "'" -- $value)
            set -gx $key $value
        end
    end
end

if status is-interactive
    # prompt, aliases, starship... (do NOT put env loader here)
end
```
Pitfall: `string replace -r '^["\x27]|["\x27]$'` only strips **one** side → trailing `"` stays → token = `REDACTED_OPENAI_KEY` → 401. Use two `string trim -c` calls.

### bash — `~/.bashrc:1-17`
Loader **before** the `return` guard:

```bash
# Load API keys — must be before interactive check
if [ -f "$HOME/.env" ]; then
    set -a
    . "$HOME/.env"
    set +a
fi

[[ $- != *i* ]] && return
alias ls='ls --color=auto'
...
```
`~/.bash_profile` must source it: `[[ -f ~/.bashrc ]] && . ~/.bashrc` (default).
`~/.profile:3` for `sh` logins:
```bash
if [ -f "$HOME/.env" ]; then set -a; . "$HOME/.env"; set +a; fi
```

### zsh — `~/.zshrc:1`
```bash
if [ -f "$HOME/.env" ]; then set -a; . "$HOME/.env"; set +a; fi
```

## 4. Provider Configs — Use `env:VAR` (No Hardcoded Secrets)

### Opencode — `~/.config/opencode/config.json:1`
Current opencode (1.18.29) schema is `https://opencode.ai/config.json` with **singular** `"provider"` (not `"providers"`). Plural is silently `Omitted` (check `opencode run --print-logs | grep Omitted`).

```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "openrouter": { "npm": "@ai-sdk/openai", "name": "OpenRouter", "options": { "baseURL": "https://openrouter.ai/api/v1", "apiKey": "env:OPENAI_API_KEY" }},
    "openai":     { "npm": "@ai-sdk/openai", "name": "OpenAI Compatible", "options": { "baseURL": "https://open.api-github.com/v1", "apiKey": "env:OPENAI_API_KEY" }},
    "anthropic":  { "npm": "@ai-sdk/anthropic", "name": "Bluepack Anthropic", "options": { "baseURL": "https://ai.bluepack.my.id/anthropic", "apiKey": "env:ANTHROPIC_API_KEY" }}
  }
}
```
- `anthropic.baseURL` **without** trailing `/v1` — SDK appends `/v1/messages`; with `/v1` → `/v1/v1` → `rate_limit_error`.
- `auth.json` (`~/.local/share/opencode/auth.json:12`) must not have `\n`: `python3 -c "import json,pathlib; p=pathlib.Path('~/.local/share/opencode/auth.json').expanduser(); d=json.loads(p.read_text()); d['anthropic']['key']=d['anthropic']['key'].strip(); p.write_text(json.dumps(d,indent=2))"`

### Kilo — `~/.config/kilo/kilo.jsonc:5`
```json
"provider": {
  "openrouter": { "api": "openrouter", "options": { "apiKey": "env:OPENAI_API_KEY", "baseURL": "https://openrouter.ai/api/v1" }},
  "anthropic":  { "api": "anthropic",  "options": { "apiKey": "env:ANTHROPIC_API_KEY", "baseURL": "https://ai.bluepack.my.id/anthropic" }},
  "openai":     { "api": "openai",     "options": { "apiKey": "env:OPENAI_API_KEY", "baseURL": "https://open.api-github.com/v1" }}
}
```
Was `openrouter → env:ANTHROPIC_API_KEY` (bluepack token for OpenRouter) → `401 Missing Authentication`.

### Warp
Warp does **not** use `~/.config/warp-agent/config.json` (that file is a leftover helper). Real store is keychain:

```bash
printf "%s" "$(grep OPENAI_API_KEY ~/.env | cut -d'"' -f2)" | warp --set-provider-api-key openai
printf "%s" "$(grep ANTHROPIC_API_KEY ~/.env | cut -d'"' -f2)" | warp --set-provider-api-key anthropic
# verify: warp --help | grep provider
```
Warp `base_url` for Bluepack is in `~/.config/warp-terminal/settings.toml` → `base_url = "https://ai.bluepack.my.id/anthropic"` (without `/v1`).

### Claude
Claude (`/usr/local/bin/claude`) reads `ANTHROPIC_API_KEY` + `ANTHROPIC_BASE_URL` from env (auto-exported). No extra config needed beyond `~/.env`. `GITHUB_TOKEN` is separate.

## 5. Helper — `~/.local/bin/apikey`
```bash
~/.local/bin/apikey show   # shows all KEY: value... (handles both export and plain)
~/.local/bin/apikey set OPENAI_API_KEY REDACTED_OPENAI_KEY
~/.local/bin/apikey test   # ✔/✘
```
It writes `KEY="value"` (no `export`) and does **not** patch `config.json` anymore — configs use `env:` so one-file rotation.

## 6. Verify Without `export`

```bash
# No export command needed
fish -c 'printenv OPENAI_API_KEY | cut -c1-20' # REDACTED_OPENAI_KEY
bash -l -c 'printenv ANTHROPIC_API_KEY | cut -c1-20' # REDACTED_ANTHROPIC_KEY
# App checks
fish -c 'opencode debug config | grep -q "\"provider\"" && echo ok' # no Omitted warning
fish -c 'kilo debug config | python3 -m json.tool | grep -A1 openai'
warp --help | grep set-provider-api-key
# Quota checks (provider-side, not config):
curl -H "x-api-key: $ANTHROPIC_API_KEY" "$ANTHROPIC_BASE_URL/v1/messages" -d '{"model":"claude-haiku-4-5-20251001","max_tokens":10,"messages":[{"role":"user","content":"hi"}]}'
# → if {"error":{"message":"Kuota habis..."}} → wait 5h rolling window or contact Bluepack admin
curl -H "Authorization: Bearer $OPENAI_API_KEY" https://open.api-github.com/v1/models | head
# → if {"code":402,"message":"kredit tidak cukup"} → topup at open.api-github.com
```

## 7. If Still `Unauthorized` / `Missing Authentication`

- `cat ~/.env` has no `export` and `chmod 600`? `grep -E '^export'` should be empty.
- `fish -c 'set --show OPENAI_API_KEY'` shows `exported`? If not, loader is still inside `is-interactive`.
- `opencode run --print-logs | grep -i Omitted` — if present, `config.json` still has `"providers"` plural → rename to `"provider"`.
- `cat ~/.local/share/opencode/auth.json | python3 -c "import json;print(repr(json.load(open('/home/nazky/.local/share/opencode/auth.json'))['anthropic']['key'][-5:]))"` — should not end with `\n`.
- `warp --set-provider-api-key` re-run after rotating `~/.env`.

## 8. Rotate Key

```bash
~/.local/bin/apikey set ANTHROPIC_API_KEY REDACTED_ANTHROPIC_KEY
~/.local/bin/apikey set OPENAI_API_KEY REDACTED_OPENAI_KEY
printf "%s" "$ANTHROPIC_API_KEY" | warp --set-provider-api-key anthropic
printf "%s" "$OPENAI_API_KEY" | warp --set-provider-api-key openai
# opencode/kilo/claude pick up new key on next launch (no config edit)
```

---

## Files to Edit

| File | Purpose |
|------|---------|
| `~/.env` | single source, `KEY="value"`, `chmod 600` |
| `~/.config/environment.d/api-keys.conf` | systemd GUI sessions |
| `~/.config/fish/config.fish` | global loader |
| `~/.bashrc`, `~/.profile`, `~/.zshrc` | `set -a; . ~/.env` |
| `~/.config/opencode/config.json` | `"provider"` singular, `env:` |
| `~/.config/kilo/kilo.jsonc` | same |
| `~/.local/share/opencode/auth.json` | no `\n` |
| warp keychain | `warp --set-provider-api-key` |

## Tags
#guide #how-to #api-keys #opencode #kilo #warp #claude #fish #bash #blackarch
