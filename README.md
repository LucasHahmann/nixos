# NixOS-Konfiguration (KDE Plasma)

Meine NixOS-Konfiguration für einen Gaming- und Streaming-Desktop mit KDE Plasma 6.
Sie läuft auf dem **stabilen Channel (26.05)** und ist in kleine Module aufgeteilt,
damit jedes Thema in seiner eigenen Datei liegt.

> [!NOTE]
> Die Konfiguration nutzt klassische Channels (keine Flakes).
> `configuration.nix` enthält nur die Imports, die eigentliche Konfiguration liegt in `./modules`.

## Hardware

| | |
|---|---|
| CPU | AMD Ryzen 5 5600X |
| GPU | AMD Radeon RX 6700 XT |
| RAM | 32 GB |
| Mainboard | MSI B550-A PRO |
| System | Intenso 112 GB SSD (btrfs: `/`, `/home`, `/nix`) |
| Weitere Laufwerke | NTFS: `/mnt/windows-11` (1 TB NVMe), `/mnt/games`, `/mnt/data` |
| Streaming | Elgato HD60 X, Razer Kiyo Pro, Stream Deck MK.2, Mackie ProFX |

## Benutzung

```bash
# Konfiguration testen (aktiv bis zum nächsten Neustart, kein Bootmenü-Eintrag)
sudo nixos-rebuild test

# Konfiguration übernehmen
sudo nixos-rebuild switch

# System aktualisieren (Channel updaten + neu bauen)
sudo nix-channel --update && sudo nixos-rebuild switch

# Speicher manuell freigeben (läuft sonst automatisch wöchentlich)
sudo nix-collect-garbage --delete-older-than 14d
```

Wenn etwas schiefgeht: Neustart und im Bootmenü eine ältere Generation auswählen.

## Struktur

```
.
├── configuration.nix           Einstiegspunkt: Imports + stateVersion
├── hardware-configuration.nix  generiert von nixos-generate-config (nicht bearbeiten)
└── modules
    ├── system/                 Grundlagen
    │   ├── boot.nix            Bootloader, Zen-Kernel
    │   ├── nix.nix             Nix-Einstellungen, Garbage Collection, nix-ld
    │   ├── locale.nix          Zeitzone, Sprache, Tastatur
    │   ├── networking.nix      NetworkManager, Firewall
    │   ├── filesystems.nix     NTFS-Laufwerke
    │   └── maintenance.nix     fwupd, smartd
    ├── hardware/               gerätespezifisch
    │   ├── amd-gpu.nix         CoreCtrl, Overclocking
    │   └── bluetooth.nix
    ├── desktop/                KDE Plasma, PipeWire, Drucken
    ├── programs/               Software nach Thema
    │   ├── apps.nix            Firefox, KeePassXC, Discord, VLC …
    │   ├── development.nix     Git, VSCodium, nixd, Claude Code + Plugin-Laufzeit
    │   ├── gaming.nix          Steam, Gamemode, Prism Launcher
    │   └── streaming.nix       OBS (+ virtuelle Kamera), StreamController, Kdenlive
    └── users/
        └── lhahmann.nix        Benutzerkonto und Gruppen
```

### Neues Programm hinzufügen

1. Das Paket auf [search.nixos.org](https://search.nixos.org/packages) suchen.
2. Gibt es ein `programs.<name>.enable`, dieses bevorzugen, weil es Rechte, udev-Regeln usw. gleich mit einrichtet.
3. In die passende Datei unter `modules/programs/` eintragen.
4. Für ein neues Thema eine neue Datei anlegen und sie in `configuration.nix` importieren.

## Hinweise

- **`system.stateVersion` niemals ändern.** Die Option hat nichts mit der installierten NixOS-Version zu tun.
- Die NTFS-Laufwerke werden mit `nofail` eingebunden, damit der Bootvorgang nicht hängt, wenn eine Platte fehlt.
  Beim Dual-Boot muss in Windows der Schnellstart deaktiviert sein.
- Die virtuelle OBS-Kamera liegt auf `/dev/video10`, weil `/dev/video1` von der Elgato belegt ist.
