# LLM Setup with Ollama

**Machine:** Lenovo 83LY, 15GB DDR5, RTX 5050 8GB VRAM
**Ollama:** 0.33.3 at /usr/bin/ollama, zero models pulled yet
**Measured 2026-09-10:** 4.7GB RAM free, GPU idle at 2 MiB used

## How to Set Up

```bash
ollama serve                        # start the server (background it or enable the service)
ollama pull qwen2.5-coder:7b        # download a model
ollama run qwen2.5-coder:7b         # chat in terminal, /bye to quit
ollama list                         # what you have
ollama ps                           # what is loaded in VRAM right now
ollama rm old-model                 # free disk space
```

Talk to it from scripts via the built-in API, no key needed:

```bash
curl localhost:11434/api/generate -d '{"model":"llama3.1:8b","prompt":"hi","stream":false}'
```

Useful knobs:

```bash
OLLAMA_NUM_PARALLEL=1 ollama serve   # one job at a time, saves VRAM
ollama run llama3.1:8b               # then: /set parameter num_ctx 8192
```

Watch VRAM while a model loads with `nvidia-smi` or `ollama ps`.

## How Much RAM Models Eat

Rule of thumb for Q4 quants: about 0.6 GB per 1B params on disk and in VRAM, plus 0.5 to 2 GB context overhead. Your ceilings:

- 8 GB VRAM fits up to about 13B fully on GPU. 14B spills a little into RAM, still fine.
- 15 GB RAM fits up to about 24B with partial GPU offload (slower). 32B and up do not fit.
- Right now only 4.7 GB RAM is free, so stay at 8B or below fully on GPU, or close the browser before loading 14B.

| Model | Size on disk | VRAM loaded | Fits how |
|-------|--------------|-------------|----------|
| qwen3:0.6b, llama3.2:1b | under 1 GB | under 1 GB | instant, anywhere |
| qwen3:4b, llama3.2:3b | about 2.5 GB | about 3 GB | easy |
| mistral:7b, qwen2.5-coder:7b, gemma3:4b | 4 to 5 GB | 5 to 6 GB | comfortable daily |
| llama3.1:8b, qwen3:8b, deepseek-r1:8b | about 5.5 GB | about 6 GB | comfortable daily |
| qwen2.5-coder:14b, gemma3:12b, deepseek-r1:14b | 9 to 10 GB | spills past 8 GB VRAM | good, some layers on RAM |
| nomic-embed-text | 274 MB | tiny | embeddings |
| mxbai-embed-large | 670 MB | small | better embeddings |

## Which Model for What

- Daily chat: llama3.1:8b or qwen3:8b. Mistral:7b if you want drier answers.
- Coding: qwen2.5-coder:7b for speed, qwen2.5-coder:14b for best quality on this GPU.
- Thinking through hard bugs: deepseek-r1:8b, or qwen3:8b with thinking on.
- Instant answers and offline drafts: qwen3:1.7b or llama3.2:3b.
- Screenshots and diagrams: qwen2.5vl:7b or gemma3:4b.
- Search over your vault: nomic-embed-text for embeddings.
- Skip for now: 24B plus (needs RAM you do not have free), 70B (no chance).

## Suggested First Pulls

```bash
ollama pull qwen2.5-coder:7b
ollama pull llama3.1:8b
ollama pull nomic-embed-text
ollama pull qwen2.5vl:7b
```

About 15 GB disk total, all comfortable on this machine.

Tags: #llm #ollama #models
