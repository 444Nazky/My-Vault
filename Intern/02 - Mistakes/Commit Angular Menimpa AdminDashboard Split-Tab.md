# Mistake — Commit `angular` Menimpa Design Admin Dashboard (Split-Tab → Monolit)

> **Tanggal:** 1 Oktober 2026 · **Dampak:** design admin dashboard "kembali seperti dulu" —
> Spreadsheet Live, Rekap Wilayah, galeri foto, dan 7 tab hilang dari tampilan.
> **Gejala:** user melihat progress design rollback dan meminta *"pull yang lama dari GitHub"*
> — padahal versi rollback-nya sendiri **sudah ter-push** ke GitHub.

## Kejadian

Commit **`76b03c4 "angular"`** (30 Sep 16:26) menimpa satu file inti:

| | Sebelum (`3f8f9ec`, 30 Sep 14:06) | Sesudah (`76b03c4`) |
|---|---|---|
| `src/pages/admin/AdminDashboard.tsx` | **233 baris** — shell tipis yang me-render `tabs/*` + `ReportSheet` | **1326 baris monolit** — UI milik sendiri, **tidak mengimpor `tabs/` sama sekali** |

Karena seluruh isi dashboard pindah ke `src/pages/admin/tabs/*` sejak
*"code split biar ndak pusing"*, file tabs berubah jadi **kode mati** dan semua
fitur di dalamnya hilang dari layar:

- ❌ **Spreadsheet Live** (`ReportSheet`, `#/sheet`) — `grep ReportSheet|sheetMode` = **0**
- ❌ **Rekap Wilayah** — padahal isinya benar di `ReportsTab.tsx`
- ❌ **Galeri foto dokumentasi** di Laporan
- ❌ `CurrencyProvider` / toggle reveal nominal
- ❌ Nav 7 tab (Overview, Master Plat/Rute, Petugas, Laporan, Pengaturan)

## Jebakan 1 — "Pokoknya pull dari GitHub deh"

```bash
git rev-list --left-right --count origin/main...HEAD   # → 0  0
```

`origin/main` **sudah sama persis** dengan `HEAD` — artinya file yang tertimpa
**ikut ter-commit dan ter-push**. `git pull` = no-op; versi bagus hanya ada di
**history** (`origin/main~1` = `3f8f9ec`), bukan di ujung remote.

**Pelajaran:** sebelum menyebut "rollback/pull", selalu cek dulu:
`git status -sb` · `git reflog` · `git log --oneline --follow -- <file>` —
kalau reflog isinya `commit:` saja (tanpa `reset`/`checkout`), rollback-nya
terjadi **lewat commit**, bukan lewat kerjaan Git.

## Jebakan 2 — Satu commit bawa dua perubahan lawan arah

Commit yang sama juga memuat **perbaikan yang benar**:

```
src/pages/admin/tabs/OfficersTab.tsx   +8    (@username)
src/pages/admin/tabs/ReportsTab.tsx   +65    (Rekap Wilayah)
src/pages/store.tsx                   +26    (prefetch petugas)
...
```

Jadi **`git revert`/`reset` commit-nya justru ikut membuang fitur baru**.
Satu-satunya cara aman: pulihkan **per-file** dari commit sebelumnya.

**Pelajaran:** jangan `git checkout <commit> -- .` (atau revert total) untuk
commit campuran — kenali dulu file mana yang regression dan mana yang feature.

## Jebakan 3 — `admin-ci/index.php` kehilangan header anti-cache

Barengan dengan itu, `admin-ci/index.php` **kehilangan 5 baris**
`Cache-Control: no-store, no-cache…` (tertimpa salinan dari `archive/` lewat
script restart lawas). Akibatnya browser bebas menyimpan `index.html` →
dashboard bisa menampilkan **bundle basi** bahkan setelah build benar.

**Pelajaran:** file entry-point `admin-ci/index.php` harus dijaga; kini
`scripts/admin-watch.mjs` mengecek & memasangnya ulang tiap sinkron, dan
`git checkout -- admin-ci/index.php` mengembalikan versi ber-header.

## Cara mendeteksi dini

```bash
# 1. Apakah file inti pernah "berubah ukuran drastis"?
for c in $(git log --format=%h -8 -- src/pages/admin/AdminDashboard.tsx); do
  echo "$c $(git log -1 --format='%s' $c) -> $(git show $c:src/pages/admin/AdminDashboard.tsx | wc -l) baris"
done

# 2. Apakah fitur masih ada di source & bundle?
grep -c "Rekap Wilayah" src/pages/admin/tabs/ReportsTab.tsx
grep -c "Rekap Wilayah" admin-ci/main-*.js        # 0 → build memakai versi lama
```

Terkait: [[../01 - Fixes/Restore Design Admin Dashboard dari Git History]] · [[tr]]
