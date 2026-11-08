# Zusätzliche Laufwerke (Windows-/NTFS-Partitionen).
# Root, /home, /nix, /boot und Swap stehen in hardware-configuration.nix.
#
# WICHTIG: In Windows "Schnellstart" deaktivieren, sonst sind die
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
  fileSystems."/mnt/games" = ntfsMount "3EF0982EF097EA83"; # SanDisk 240GB
  fileSystems."/mnt/data" = ntfsMount "626E82406E820CCB"; # Samsung 840 EVO 250GB
}
