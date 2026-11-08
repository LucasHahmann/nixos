# Gaming
{ pkgs, ... }:

{
  programs.steam.enable = true;

  # CPU-Governor & Prioritäten während des Spielens (`gamemoderun %command%` in Steam)
  programs.gamemode.enable = true;

  # Java für Minecraft
  programs.java = {
    enable = true;
    package = pkgs.jdk25; # systemweites Standard-Java
  };

  environment.systemPackages = with pkgs; [
    (prismlauncher.override {
      jdks = [
        jdk25 # Minecraft 26.x
        jdk21 # 1.20.5 – 1.21.x
        jdk17 # 1.18 – 1.20.4
        jdk8 # ältere Versionen
      ];
    })
  ];
}
