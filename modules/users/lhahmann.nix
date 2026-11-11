# Benutzerkonto
{ pkgs, ... }:

{
  users.users.lhahmann = {
    isNormalUser = true;
    description = "Lucas Hahmann";
    extraGroups = [
      "networkmanager"
      "wheel" # sudo
      "corectrl" # GPU-Tuning ohne Passwortabfrage
      "docker"
    ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };
}
