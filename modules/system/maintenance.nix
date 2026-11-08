# Wartung: Firmware-Updates, Festplatten-Überwachung
{ ... }:

{
  # Firmware-Updates via `fwupdmgr` / KDE Discover
  services.fwupd.enable = true;

  # SMART-Überwachung aller Laufwerke
  services.smartd.enable = true;
}
