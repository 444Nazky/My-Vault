# AI CLI Agents

**Date:** 2026-09-06
**System:** BlackArch Linux

---

## Available AI CLI Tools

| Tool | Version | Location | Type |
|------|---------|----------|------|
| Claude Code | 2.1.263 | `/usr/local/bin/claude` | Anthropic |
| OpenCode | 1.18.29 | `/usr/bin/opencode` | Open Source |
| Grok | 1.0.13 | `/usr/bin/grok` | xAI |
| Gemini CLI | 0.57.0 | `~/.local/npm/bin/gemini` | Google |
| Ollama | 0.33.3 | `/usr/bin/ollama` | Local Models |
| FreeBuff | 0.0.154 | `/usr/bin/freebuff` | Codebuff |
| Kilo | 7.5.15 | `/usr/bin/kilo` | Coding Agent |
| Hermes | 0.21.0 | `~/.local/bin/hermes` | Agent |

---

## Claude Code

**Version:** 2.1.263
**Location:** `/usr/local/bin/claude`
**Type:** Anthropic CLI Agent

### Description
Official Anthropic CLI for Claude. Full-featured agent with code editing, file management, and tool use.

### Usage
```bash
claude
claude -p "prompt"
claude --help
```

### Status
Currently running this session.

---

## OpenCode

**Version:** 1.18.29
**Location:** `/usr/bin/opencode`
**Type:** Open Source CLI Agent

### Description
Open source CLI agent for code tasks, search, and automation.

### Usage
```bash
opencode
opencode --help
```

### Status
Installed

---

## Grok

**Version:** 1.0.13 (5e9a58528b76)
**Location:** `/usr/bin/grok`
**Type:** xAI

### Description
xAI's Grok CLI agent with real-time knowledge and web search capabilities.

### Usage
```bash
grok
grok --help
grok "your question"
```

### Status
Installed

---

## Gemini CLI

**Version:** 0.57.0
**Location:** `/home/nazky/.local/npm/bin/gemini`
**Package:** gemini-cli (AUR)
**Type:** Google

### Description
Open-source AI agent that brings the power of Gemini directly into the terminal.

### Usage
```bash
gemini
gemini --help
gemini "your prompt"
```

### Status
Installed

---

## Ollama

**Version:** 0.33.3 (client)
**Location:** `/usr/bin/ollama`
**Package:** ollama (pacman)
**Type:** Local Models

### Description
Create, run and share LLMs locally. No GPU currently active for Ollama.

### Usage
```bash
ollama list          # List installed models
ollama run <model>   # Run a model
ollama pull <model>  # Pull a model
ollama serve         # Start server
```

### Status
Installed, but no running instance (GPU not configured for Ollama)

### Note
Ollama requires GPU for efficient inference. Currently using NVIDIA RTX 5050 but not configured for Ollama.

---

## FreeBuff

**Version:** 0.0.154
**Location:** `/usr/bin/freebuff`
**Package:** freebuff-bin (AUR)
**Type:** Codebuff

### Description
Free AI coding agent for the terminal by Codebuff.

### Usage
```bash
freebuff
freebuff --help
```

### Status
Installed

---

## Kilo

**Version:** 7.5.15
**Location:** `/usr/bin/kilo`
**Package:** kilo-bin (AUR)
**Type:** Coding Agent

### Description
The AI coding agent built for the terminal.

### Usage
```bash
kilo
kilo --help
```

### Status
Installed

---

## Hermes

**Version:** 0.21.0
**Location:** `~/.local/bin/hermes`
**Install:** git
**Type:** Agent Framework

### Description
Hermes Agent with ACP support, OpenAI SDK integration.

### Binaries
- `hermes` - Main CLI
- `hermes-acp` - ACP (Agent Communication Protocol)
- `hermes-agent` - Agent daemon

### Usage
```bash
hermes --help
hermes update
```

### Status
Installed

### Config
```
Install directory: ~/.hermes/hermes-agent
Python: 3.11.16
OpenAI SDK: 2.24.0
```

---

## Quick Reference

| Task | Recommended Tool |
|------|-----------------|
| General coding | Claude Code |
| Web search | Grok |
| Local models | Ollama |
| Google AI | Gemini CLI |
| Open source | OpenCode |
| Free coding agent | FreeBuff |
| Terminal coding | Kilo |
| Agent framework | Hermes |

---

## Configuration Files

| Tool | Config Location |
|------|----------------|
| Claude | `~/.claude/` |
| OpenCode | `~/.config/opencode/` |
| Grok | `~/.config/grok/` |
| Gemini | `~/.config/gemini/` |
| Ollama | `~/.ollama/` |
| FreeBuff | `~/.config/freebuff/` |
| Kilo | `~/.config/kilo/` |
| Hermes | `~/.hermes/` |

## Tags
#note-ai-cli-agents
