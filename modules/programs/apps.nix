# Alltagsprogramme
{ pkgs, config, ... }:

let
  # Einzelne Pakete, die es nur in nixos-unstable gibt (z.B. PhotoCraft).
  # Wird beim Rebuild höchstens stündlich neu geladen.
  unstable = import (fetchTarball "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz") {
    inherit (config.nixpkgs) config;
    system = pkgs.stdenv.hostPlatform.system;
  };
in
{
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    keepassxc
    discord
    vlc
    filezilla
    btop
    pavucontrol
    kdePackages.kdenlive
    kdePackages.filelight
    kdePackages.elisa
    kdePackages.partitionmanager
    fastfetch
    trash-cli
    btrfs-progs
    thunderbird
    pika-backup
    unstable.photocraft # Bildbearbeitung (PSD), github.com/storytold/photocraft
  ];
}
