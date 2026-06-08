# tools/

Berisi installer dan binary untuk keperluan WiFi driver pada Hackintosh hype5x3.

## Struktur

```
tools/
├── Install Wifi Driver.tool   ← Double-click di Finder untuk install
└── bin/
    └── rtw88ctl               ← Binary CLI (Mach-O x86_64)
```

## Cara Install

### Metode 1 — Double-click (Termudah)
1. Buka folder `tools/` di **Finder**
2. Double-click **`Install Wifi Driver.tool`**
3. Terminal akan terbuka dan menjalankan installer secara otomatis
4. Masukkan password saat diminta (untuk menulis ke `/usr/local/bin`)

### Metode 2 — Manual via Terminal
```bash
cd /path/to/hype5x3/tools
sudo install -m 755 bin/rtw88ctl /usr/local/bin/rtw88ctl
```

## Setelah Install

Jalankan langsung dari Terminal:

```bash
rtw88ctl --help
```

## Uninstall

```bash
sudo rm /usr/local/bin/rtw88ctl
```

## Persyaratan

- macOS (x86_64)
- Akses sudo
- `/usr/local/bin` harus ada di PATH
