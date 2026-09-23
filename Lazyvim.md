
| Category                         | Shortcut / Key        | Description                                                     |
| -------------------------------- | --------------------- | --------------------------------------------------------------- |
| **Navigasi Dasar (Normal Mode)** | `h` / `j` / `k` / `l` | Pindah kursor: Kiri (`h`), Bawah (`j`), Atas (`k`), Kanan (`l`) |
|                                  | `w`                   | Loncat ke awal kata berikutnya (*word*)                         |
|                                  | `b`                   | Loncat mundur ke awal kata sebelumnya                           |
|                                  | `0` (nol) / `$`       | Pindah ke awal baris / akhir baris                              |
|                                  | `gg` / `G`            | Pindah ke baris paling atas / baris paling bawah file           |
| **Editing & Menghapus**          | `x`                   | Menghapus huruf di posisi kursor (*delete*)                     |
|                                  | `dw`                  | Menghapus satu kata ke depan                                    |
|                                  | `dd`                  | Menghapus satu baris penuh                                      |
|                                  | `u` / `Ctrl + r`      | Undo / Redo perubahan                                           |
| **Simpan & Keluar**              | `:w`                  | Menyimpan file (*save*)                                         |
|                                  | `:wq` atau `ZZ`       | Menyimpan file lalu keluar Neovim                               |
|                                  | `:q!`                 | Keluar tanpa menyimpan (*force quit*)                           |

| **Category**                | **Keybinding / Shortcut** | **Description**                                                   |
| --------------------------- | ------------------------- | ----------------------------------------------------------------- |
| **Leader Key**              | `Space`                   | The main prefix key for most LazyVim shortcuts.                   |
| **File Navigation**         | `<leader>e`               | Open or close the file explorer sidebar (Neo-tree).               |
|                             | `<leader>ff`              | Search for files across the project (Telescope).                  |
|                             | `<leader>fg`              | Search for specific text or words across the project (Live Grep). |
|                             | `<leader>fr`              | Open recently accessed files.                                     |
|                             | `<leader>fb`              | Open a list of active buffers/tabs.                               |
| **Buffer & Tab Management** | `S-h` or `[b`             | Switch to the previous buffer on the left.                        |
|                             | `S-l` or `]b`             | Switch to the next buffer on the right.                           |
|                             | `<leader>bd`              | Close/delete the current buffer.                                  |
| **Windows & Splits**        | `Ctrl + h`                | Move focus to the left window.                                    |
|                             | `Ctrl + j`                | Move focus to the bottom window.                                  |
|                             | `Ctrl + k`                | Move focus to the top window.                                     |
|                             | `Ctrl + l`                | Move focus to the right window.                                   |
|                             | `<leader>wv`              | Split the window vertically.                                      |
|                             | `<leader>ws`              | Split the window horizontally.                                    |
|                             | `<leader>wd`              | Close the currently active window.                                |
| **Git Integration**         | `<leader>gg`              | Open the interactive Git terminal interface (LazyGit).            |
| **Code Navigation (LSP)**   | `gd`                      | Go to the definition of a function or variable.                   |
|                             | `gr`                      | Show all references of the selected code.                         |
|                             | `K`                       | Show documentation / hover info for the code.                     |
|                             | `<leader>ca`              | Open code actions menu.                                           |
|                             | `<leader>cr`              | Globally rename a variable or function.                           |
| **Plugin Management**       | `:Lazy`                   | Open the main plugin manager control panel.                       |

| **Category**          | **Keybinding / Shortcut** | **Description**                                                      |
| --------------------- | ------------------------- | -------------------------------------------------------------------- |
| **Plugin Management** | `:Lazy update`            | Update all installed plugins to their latest versions.               |
|                       | `:Lazy sync`              | Synchronize plugins (install missing ones and clean up unused ones). |
|                       | `:Lazy clean`             | Remove unused plugins.                                               |
|                       | `:Lazy log`               | View the plugin update log.                                          |