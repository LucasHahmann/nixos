# Bootloader und Kernel
{ pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  # Max. 10 Einträge im Bootmenü – hält /boot (1 GB) sauber
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 1;

  # Zen-Kernel: auf Desktop/Gaming-Latenz optimiert
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # ntfs-3g-Tools (z.B. ntfsfix); gemountet wird mit dem Kernel-Treiber ntfs3
  boot.supportedFilesystems = [ "ntfs" ];
}
