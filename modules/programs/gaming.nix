# Gaming
{ pkgs, ... }:

{
  programs.steam.enable = true;

  # CPU-Governor & Prioritäten während des Spielens (`gamemoderun %command%` in Steam)
  programs.gamemode.enable = true;

  # Java für Minecraft
  programs.java.enable = true;

  environment.systemPackages = with pkgs; [
    prismlauncher
  ];
}
