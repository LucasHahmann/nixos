# Alltagsprogramme
{ pkgs, ... }:

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
  ];
}
