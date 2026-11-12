# Einstiegspunkt der Systemkonfiguration.
# Hier wird nur zusammengesteckt – die eigentlichen Einstellungen liegen in ./modules.
# Hilfe: `man configuration.nix`, https://search.nixos.org/options

{ ... }:

{
  imports = [
    ./hardware-configuration.nix # generiert von nixos-generate-config – nicht anfassen

    # System-Grundlagen
    ./modules/system/boot.nix
    ./modules/system/nix.nix
    ./modules/system/locale.nix
    ./modules/system/networking.nix
    ./modules/system/filesystems.nix
    ./modules/system/maintenance.nix
    ./modules/system/rebuild.nix

    # Hardware
    ./modules/hardware/amd-gpu.nix
    ./modules/hardware/bluetooth.nix

    # Desktop
    ./modules/desktop/plasma.nix
    ./modules/desktop/audio.nix
    ./modules/desktop/printing.nix

    # Programme
    ./modules/programs/apps.nix
    ./modules/programs/development.nix
    ./modules/programs/gaming.nix
    ./modules/programs/streaming.nix
    ./modules/programs/citrix-workspace.nix

    # Benutzer
    ./modules/users/lhahmann.nix
  ];

  # Erste installierte NixOS-Version. NIEMALS ändern, auch nicht nach Upgrades!
  # Das hat nichts mit der Paketversion zu tun.
  # https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion
  system.stateVersion = "26.05";
}
