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
    ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };
}
