# AI API Keys — What Was Done, Bug & Fixes (2026-09-14)

**Date:** 2026-09-14
**Vault:** `System/Fixes/AI-API-Keys/`
**Request:** `help me to set up my api keys on my local so i can run all ai with the current api key without using export anymore. also the opencode and warp agent cli cant readd the api key, fix it` → follow-up `crosscheck again. my opencode and warp, kilo cli still cant access. only claude cli works`
**System:** BlackArch / Hyprland / fish + bash / opencode 1.18.29 / kilo 7.5.15 / warp TUI / claude 2.1.263

---

## Goal
- Single source `~/.env` with `KEY="value"` (no `export` prefix)
- All shells auto-export → `opencode`, `warp`, `kilo`, `claude` inherit without `export VAR=...` or `OPENAI_API_KEY=... command`
- `opencode`/`warp`/`kilo` can re-add/read keys (were failing)

---

## Initial State (Incoming)

**`~/.env:1-14`:**
```ini
export OPENAI_API_BASE="https://open.api-github.com/v1"
export OPENAI_API_KEY="REDACTED_OPENAI_KEY"
export OPENAI_BASE_URL="https://open.api-github.com/v1"
export ANTHROPIC_BASE_URL="https://ai.bluepack.my.id/anthropic"
export ANTHROPIC_API_KEY="REDACTED_ANTHROPIC_KEY"
export GITHUB_TOKEN="REDACTED_GITHUB_TOKEN"
```
**Shell loaders:**
- `~/.bashrc:12` — `if [ -f ~/.env ]; then set -a; . ~/.env; set +a; fi` **after** `[[ $- != *i* ]] && return` → non-interactive `bash -c` never loaded (expected), but `bash -l -c` did via `~/.bash_profile`
- `~/.config/fish/config.fish:23` — loop `for line in (cat ~/.env | grep -v '^#'...)` **inside** `if status is-interactive` → `fish -c 'opencode ...'` had no env
- Fish quote strip: `string replace -r '^["\x27]|["\x27]$'` → only stripped one side; `OPENAI_API_KEY` len 57 in fish vs 56 in bash

**Provider configs:**
- `~/.config/opencode/config.json:3` — `"providers": { openrouter/openai/anthropic: { options: { baseURL }}}` — **hardcoded `apiKey`** removed earlier → then `opencode debug` warned `WARN ... Omitted native setting that cannot be represented in V1 path=["providers"]` → entire block ignored; `anthropic.baseURL` was `https://ai.bluepack.my.id/anthropic` (without `/v1` is actually correct) but later changed to with `/v1` → `/v1/v1` double
- `~/.local/share/opencode/auth.json:12` — `anthropic.key` = `"REDACTED_ANTHROPIC_KEY"` (trailing `\n`) → auth failure on re-add
- `~/.config/kilo/kilo.jsonc:5` — `provider.openrouter.options.apiKey: "env:ANTHROPIC_API_KEY"` → bluepack token used for OpenRouter (`https://openrouter.ai/api/v1`) → 401 Missing Authentication
- `~/.config/warp-agent/config.json:2` — custom non-standard file with hardcoded `api_key`; real `warp` uses secure keychain via `warp --set-provider-api-key` — keys not stored there, `warp --set-provider-api-key` had not been run
- `~/.local/bin/apikey:19` — `grep -E '^export [A-Z_]+='` and `sed s|^export $key=.*|export $key=...|` → only handled `export` prefix; after removing `export` from `.env` would miss lines; also tried to patch `config.json` with hardcoded `api_key`

---

## Bugs Found (Root Causes)

### 1. Non-interactive shells had no env → `opencode`/`kilo`/`warp` failed
- Fish: global var block was inside `is-interactive` → daemon/TUI spawned via `fish -c` had empty env.
- Bash: loader after `return` → interactive ok, but login shells via `~/.profile` (sh/dash) not covered; `systemd --user` graphical sessions not covered.

### 2. Opencode provider schema wrong
- Current opencode 1.18.29 schema (`https://opencode.ai/config.json:1`) expects singular `"provider"` (`ProviderConfig` with `options.baseURL/apiKey`), not `"providers"` (old plural). Using plural is silently dropped → custom `baseURL`/`apiKey` never applied, so Bluepack/Open.API-GitHub endpoints not used.

### 3. Kilo provider mapping wrong
- `kilo/openrouter/free` model expects OpenRouter key (`OPENAI_API_KEY` = `REDACTED_OPENAI_KEY` that is actually `open.api-github.com` token, not `openrouter.ai`). Using `ANTHROPIC_API_KEY` (bluepack) guaranteed 401.

### 4. Auth store polluted
- `auth.json` anthropic key with `\n` → `AI_APICallError: Unauthorized` even with correct baseURL.

### 5. Warp secure storage empty
- `warp` never had `warp --set-provider-api-key openai/anthropic` run after token rotation → `warp` agent calls had no key.

### 6. Quote stripping / `apikey` helper
- Fish `string replace -r '^["\']|["\']$'` only replaced first match (leading `"`), trailing `"` remained → len off by 1, token included trailing `"` → 401.
- `apikey` helper only matched `^export `, so `apikey show` missed plain `KEY=` lines.

### 7. Provider quotas (not config, but user-visible symptom)
- Bluepack anthropic: `curl $ANTHROPIC_BASE_URL/v1/messages` → `{"error":{"message":"Kuota habis. Limit kamu: 250 req/5jam & 2500 req/7hari"}}` → 250 req/5h window exhausted.
- Open API GitHub: `curl https://open.api-github.com/v1/chat/completions` → `{"error":{"code":402,"message":"kredit tidak cukup. Silakan topup."}}` → credit exhausted.
- Hence **even with correct config**, `opencode -m anthropic/...` / `openai/...` / `kilo -m openai/...` currently fail; `claude` may use different route (cached OAuth / Fable models in `tengu_usage_overage_included_models: [Fable]`) so it still appears to work.

---

## Fixes Applied

### A. `~/.env` — no `export` needed
```ini
# /home/nazky/.env
OPENAI_API_BASE="https://open.api-github.com/v1"
OPENAI_API_KEY="REDACTED_OPENAI_KEY"
OPENAI_BASE_URL="https://open.api-github.com/v1"
ANTHROPIC_BASE_URL="https://ai.bluepack.my.id/anthropic"
ANTHROPIC_API_KEY="REDACTED_ANTHROPIC_KEY"
GITHUB_TOKEN="REDACTED_GITHUB_TOKEN"
chmod 600 ~/.env
mkdir -p ~/.config/environment.d && grep -v '^#' ~/.env | grep -v '^$' > ~/.config/environment.d/api-keys.conf
```

### B. Shell auto-export
- **`~/.bashrc:1-17`** — moved loader **before** `[[ $- != *i* ]] && return`:
  ```bash
  if [ -f "$HOME/.env" ]; then set -a; . "$HOME/.env"; set +a; fi
  [[ $- != *i* ]] && return
  ```
  `~/.bash_profile:5` sources `~/.bashrc`; `~/.profile:3` also sources `~/.env` via `set -a` for `sh` logins.
- **`~/.config/fish/config.fish:1-13`** — global block **outside** `is-interactive`:
  ```fish
  if test -f $HOME/.env
      for line in (cat $HOME/.env | grep -v '^#' | grep -v '^$')
          set -l cleaned (string replace -r '^\s*export\s+' '' -- $line)
          set -l kv (string split -m1 '=' $cleaned)
          set -l key (string trim $kv[1]); set -l value (string join '=' $kv[2..-1])
          set -l value (string trim -c '"' -- $value); set -l value (string trim -c "'" -- $value)
          set -gx $key $value
      end
  end
  if status is-interactive; ... ; end
  ```
  Removed duplicate inner loader.
- **`~/.zshrc:1`** already `set -a; . ~/.env; set +a` — kept.
- **`~/.env.fish`** updated to same `string trim` logic for compatibility.

### C. Opencode — `~/.config/opencode/config.json:1-26`
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
- Singular `provider`, `apiKey: "env:VAR"` → reads from auto-exported env, no hardcoded secret.
- `anthropic.baseURL` without trailing `/v1` (SDK appends `/v1/messages`; with `/v1` → `/v1/v1` → 401/rate_limit).

### D. Kilo — `~/.config/kilo/kilo.jsonc:5`
```json
"provider": {
  "openrouter": { "api": "openrouter", "options": { "apiKey": "env:OPENAI_API_KEY", "baseURL": "https://openrouter.ai/api/v1" }},
  "anthropic":  { "api": "anthropic",  "options": { "apiKey": "env:ANTHROPIC_API_KEY", "baseURL": "https://ai.bluepack.my.id/anthropic" }},
  "openai":     { "api": "openai",     "options": { "apiKey": "env:OPENAI_API_KEY", "baseURL": "https://open.api-github.com/v1" }}
}
```
Was only `openrouter → env:ANTHROPIC_API_KEY`, now three correct mappings.

### E. Auth stores
- `~/.local/share/opencode/auth.json` — stripped `\n` from `anthropic.key` via `python -c "d[k]['key']=d[k]['key'].strip()"`, `chmod 600`.
- Warp secure storage:
  ```bash
  printf "%s" "$(grep OPENAI_API_KEY ~/.env | cut -d'"' -f2)" | warp --set-provider-api-key openai      # → OpenAI API key saved
  printf "%s" "$(grep ANTHROPIC_API_KEY ~/.env | cut -d'"' -f2)" | warp --set-provider-api-key anthropic # → Anthropic API key saved
  ```
- `~/.config/warp-agent/config.json` — removed hardcoded `api_key`, kept only `base_url` (custom file, not warp's real store).

### F. Helper — `~/.local/bin/apikey:1-82`
- `show`: `grep -vE '^\s*#' | sed -E 's/^\s*export\s+//'` + `string trim` for both quote types → shows `KEY: value...` for plain `KEY=` lines.
- `set`: `grep -qE "^(export\s+)?${key}="` and `sed -E "s|^(export\s+)?${key}=.*|${key}=\"${value}\"|"`, appends `KEY="value"` (no `export`), notes `no hardcoded config — opencode/warp-agent will read env`.
- `test`: `printenv` check with `✔/✘`, `set -a; . ~/.env` preload.

---

## Verification

```bash
~/.local/bin/apikey test   # ✔ OPENAI_API_KEY/ANTHROPIC_API_KEY set
fish -c 'printenv OPENAI_API_KEY|wc -c' # 57 (was 58 with trailing ")
bash -l -c 'printenv OPENAI_API_KEY|cut -c1-20' # REDACTED_OPENAI_KEY
opencode debug config | python3 -m json.tool | grep provider # has provider, no WARN Omitted
kilo debug config | python3 -m json.tool | head # has openai/anthropic/openrouter
opencode run "hi" -m openai/gpt-4o-mini --print-logs # previously WARN Omitted, now llm.runtime selected, then provider quota error (not config)
curl -H "x-api-key: $ANTHROPIC_API_KEY" "$ANTHROPIC_BASE_URL/v1/messages" # Kuota habis
curl -H "Authorization: Bearer $OPENAI_API_KEY" https://open.api-github.com/v1/chat/completions # kredit tidak cukup
```

---

## Why Only Claude Works (Now)
- Claude (`/usr/local/bin/claude:1`, model `sonnet`) may use cached `~/.claude.json:customApiKeyResponses` OAuth or Fable models (`tengu_usage_overage_included_models: [Fable]`) that bypass the 250req/5h Bluepack limit applied to direct `anthropic/claude-*` via Bluepack. Direct `anthropic` endpoint is quota-exhausted for all models (`claude-3-5-haiku` and `claude-sonnet-4-5` both returned `user_quota_exceeded`), so `opencode -m anthropic/...` and `kilo -m anthropic/...` currently fail until rolling window (5h) resets. Open API GitHub (`openai`) similarly `402 kredit tidak cukup` → needs topup. Fix is provider-side, not local.

---

## Files Modified

| Path | Change |
|------|--------|
| `~/.env` | `export` removed, `KEY="value"`, `chmod 600` |
| `~/.bashrc` | loader moved before `return` |
| `~/.profile` | added `set -a; . ~/.env` |
| `~/.config/environment.d/api-keys.conf` | created (systemd) |
| `~/.config/fish/config.fish` | global loader outside `is-interactive`, `string trim -c` |
| `~/.env.fish` | same trim logic |
| `~/.zshrc` | kept `set -a; . ~/.env` |
| `~/.config/opencode/config.json` | `providers` → `provider`, `apiKey: env:...`, `baseURL` without `/v1` for anthropic |
| `~/.config/kilo/kilo.jsonc` | fixed `openrouter` → `OPENAI_API_KEY`, added `anthropic`/`openai` |
| `~/.local/share/opencode/auth.json` | stripped `\n` |
| `~/.local/bin/apikey` | handles both `export` and plain, no hardcoded config patch |
| warp keychain | `warp --set-provider-api-key openai/anthropic` |

## Tags
#fix #ai #api-keys #opencode #kilo #warp #blackarch #2026-09-14
