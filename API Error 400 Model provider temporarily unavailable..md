# API Error: 400 Model provider temporarily unavailable

Claude Code mati di tengah sesi dengan:

```
● API Error: 400 Model provider temporarily unavailable. Please try again.
```

## Gejala

- Muncul sebagai pesan synthetic (`model: "<synthetic>"`), sesi langsung berhenti.
- Sering di awal sesi tapi bisa kapan saja; makin sering belakangan ini.
- Frekuensi dari log `~/.claude/projects/-home-nazky/*.jsonl`:

| Tanggal | Jumlah |
|---|---|
| 2026-09-29 | 25 |
| 2026-09-30 | 12 |
| 2026-10-01 | 39 |

Total ±104 kejadian di 40+ sesi.

## Diagnosis

**Bukan Claude CLI.** String errornya tidak ada di binary Claude Code — yang membalas
adalah relay pihak ketiga `https://ai.bluepack.my.id/anthropic`.

Kronologi:

1. Relay BluePack balas `400 Model provider temporarily unavailable` saat channel
   upstream-nya gagal. Dokumen BluePack sendiri bilang error upstream harusnya
   `502/504` — jadi ini salah kode status di sisi mereka.
2. Claude Code punya daftar status yang di-retry: `IMo = {401, 407, 429, 404, 403, 413}`.
   **400 tidak termasuk** → dianggap fatal, tidak di-retry, sesi mati.
3. Tanpa `fallbackModel`, jalur error jatuh ke `api_request_non_retryable`
   (`tengu_api_fallback_last_resort` tidak pernah kepakai).

Bukti pendukung:

- Request ke relay dengan payload valid, streaming, tools, thinking, beta-header → semua `200`.
- Auth rusak → relay balas `401`, bukan `400`. Bukan masalah API key.
- Relay juga memaksa limit **5 req/s** → `429`. Itu sudah di-retry Claude Code, bukan sumber error ini.

## Fix

`~/.claude/settings.json` — pakai fallback model bawaan Claude Code:

```json
"model": "claude-fable-5-1",
"fallbackModel": [
  "claude-sonnet-5",
  "claude-opus-5-5"
],
```

Saat primary kena 400 non-retryable, Claude Code otomatis kirim ulang request yang
sama ke model cadangan (trigger `last_resort`) dan sesi lanjut.

Kalau mau sekali jalan tanpa edit file:

```bash
claude --fallback-model claude-sonnet-5
```

## Verifikasi

Diuji dengan stub lokal `127.0.0.1:8899` yang sengaja membalas 400 dengan pesan
persis seperti itu:

| Konfigurasi | Hasil |
|---|---|
| tanpa `fallbackModel` | `API Error: 400 Model provider temporarily unavailable. Please try again.` |
| dengan `fallbackModel` | request ulang → `claude-sonnet-5` → `OK` |

End-to-end ke relay asli juga `OK`.

## Catatan

- Kalau fallback ikut terpicu, sesi pindah model permanen sampai `/model` dibalikkan.
- Dokumen BluePack melarang set `ANTHROPIC_AUTH_TOKEN` + `ANTHROPIC_API_KEY`
  sekaligus. Sekarang tidak menyebabkan error (sudah dites), tapi config-nya tidak sesuai docs.
- Akar masalah tetap di relay BluePack — lapor admin kalau errornya makin sering.
- Kalau `fallbackModel` juga ikut gagal, opsi berikutnya adalah proxy lokal yang
  retry 400 transient sebelum diteruskan ke Claude Code.

## Referensi

- `~/.claude/settings.json`
- BluePack docs: `https://ai.bluepack.my.id/docs` (bagian Error Handling & Troubleshooting)
