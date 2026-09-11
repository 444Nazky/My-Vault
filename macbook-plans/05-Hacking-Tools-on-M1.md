# Tools Hacking di M1 ARM

**Status:** sebagian besar bisa, dengan catatan arsitektur ARM64 aarch64.

## Lancar

- Web app testing: Burp, Zap, SQLmap.
- Network scanning: Nmap, Masscan, enumerasi standar.
- OSINT, scripting Python Bash Go, forensics, social engineering.

## Bermasalah dan Workaround

- Binary x86 lama atau proprietary: tidak jalan native, butuh FEX-Emu atau Box64, kadang lambat.
- Wireless hacking: WiFi internal M1 belum support monitor mode dan packet injection stabil. Wajib USB WiFi eksternal chipset Alfa, Ralink, atau Realtek untuk aircrack-ng dan wifite.
- AUR dan repo security: sebagian package gagal build jika source hardcoded assembly x86.
- Exploit dev x86 seperti buffer overflow butuh VM x86 via emulasi QEMU, bukan native.

Jika alur kerja dominan web, network standar, atau CTF non x86 pwn, M1 Asahi sudah sangat mumpuni.

Tags: #hacking #arm
