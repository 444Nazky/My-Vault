# Estimasi Baterai Coding di Intel 2020

**Pemakaian wajar:** VS Code atau Neovim, beberapa tab browser, terminal di Arch Linux.
**Hasil:** sekitar 3 sampai 5 jam.

## Faktor

- Kernel Linux menahan clock Intel gen 10 lebih tinggi agar responsif, tidak seagresif macOS.
- Unit 2020 kemungkinan health baterai tinggal 80 sampai 90 persen, kecuali baru diganti.
- Tanpa optimasi: 2,5 sampai 3,5 jam. Dengan auto-cpufreq atau TLP: 4 sampai 5 jam.

## Tips Hemat

- auto-cpufreq: governor otomatis powersave saat baterai, performance saat charging.
- Brightness 40 sampai 50 persen, layar Retina rakus daya.
- Window manager ringan seperti Hyprland, Sway, atau i3 dibanding GNOME atau KDE.

Untuk kerja mobile seharian, charger Type-C minimal 61W atau 65W tetap wajib dibawa.


