# Zusätzliche Laufwerke.
# Root, /home, /nix, /boot und Swap stehen in hardware-configuration.nix.
#
# Immer über UUID einbinden, nie über /dev/sdX – die Buchstaben können sich ändern.
# UUIDs anzeigen: `lsblk -o NAME,FSTYPE,LABEL,UUID`
#
# NTFS: In Windows "Schnellstart" deaktivieren, sonst sind die
# Partitionen beim Booten in Linux "dirty" und können beschädigt werden.
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
in
{
  fileSystems."/mnt/windows-11" = ntfsMount "34CA9881CA984152"; # Lexar NM710 1TB (NVMe)
  fileSystems."/mnt/data" = ntfsMount "626E82406E820CCB"; # Samsung 840 EVO 250GB

  # SanDisk 240GB – btrfs (Label "Games"), Steam-Bibliothek
  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/bf00a49f-b57c-4479-a41e-982b65d26bde";
    fsType = "btrfs";
    options = [
      "nofail"
      "x-systemd.device-timeout=5s"
      "noatime"
      "compress=zstd" # spart Platz; bereits komprimierte Spieldateien werden automatisch übersprungen
    ];
  };
  # btrfs kennt kein uid=/gid= wie NTFS. Der Besitzer wird im Dateisystem gespeichert,
  # daher einmalig nach dem Formatieren: sudo chown lhahmann:users /mnt/games
}
