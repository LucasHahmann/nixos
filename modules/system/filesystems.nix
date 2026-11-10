# Laufwerke nach dem Umzug auf die NVMe.
# Ersetzt /etc/nixos/modules/system/filesystems.nix auf dem neuen System.
#
# Root, /home, /nix, /var/log, /.snapshots und /boot stehen in hardware-configuration.nix
# (erzeugt von nixos-generate-config). Hier kommen nur die Zusatzoptionen dazu.
#
# Immer über UUID einbinden, nie über /dev/sdX – die Buchstaben können sich ändern.
# UUIDs anzeigen: `lsblk -o NAME,FSTYPE,LABEL,UUID`
{ ... }:

let
  ntfsMount = uuid: {
    device = "/dev/disk/by-uuid/${uuid}";
    fsType = "ntfs3";
    options = [
      "nofail" # Boot nicht blockieren, wenn die Platte fehlt
      "x-systemd.device-timeout=5s"
      "uid=1000" # gehört lhahmann
      "gid=100" # Gruppe users
      "umask=022"
      "windows_names" # verhindert Dateinamen, die Windows nicht kann
      "noatime"
    ];
  };

  # Zusatzoptionen für die NVMe (btrfs). Werden mit den Optionen aus
  # hardware-configuration.nix (subvol=@…) zusammengeführt.
  # zstd:1 statt zstd:3: doppelt so schnelles Schreiben, nur ~8 % weniger Platzersparnis.
  # Auf einer PCIe-4.0-NVMe wäre sonst die CPU der Engpass.
  nvme = [
    "compress=zstd:1"
    "noatime"
  ];
in
{
  fileSystems."/".options = nvme;
  fileSystems."/home".options = nvme;
  fileSystems."/nix".options = nvme;
  fileSystems."/.snapshots".options = nvme;
  fileSystems."/var/log" = {
    options = nvme;
    neededForBoot = true; # Logs schon ab dem frühen Boot sichern
  };

  # Samsung 840 EVO 250GB – NTFS
  fileSystems."/mnt/data" = ntfsMount "626E82406E820CCB";

  # SanDisk 240GB – btrfs (Label "Games"), Steam-Bibliothek
  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/bf00a49f-b57c-4479-a41e-982b65d26bde";
    fsType = "btrfs";
    options = [
      "nofail"
      "x-systemd.device-timeout=5s"
      "noatime"
      "compress=zstd" # SATA-SSD: hier ist die SSD der Engpass, zstd:3 passt
    ];
  };

  # Komprimierter Swap im RAM statt Swap-Partition
  zramSwap.enable = true;

  # Monatliche Prüfung aller btrfs-Daten auf Bitfehler
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [
      "/"
      "/mnt/games"
    ];
  };
}
