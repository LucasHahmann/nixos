# Nix selbst und Nixpkgs
{ ... }:

{
  nixpkgs.config.allowUnfree = true;

  # Automatische Aufräumung: alte Generationen wöchentlich löschen
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Identische Dateien im Store per Hardlink zusammenfassen (spart Platz)
  nix.settings.auto-optimise-store = true;

  # Erlaubt das Ausführen von nicht-Nix-Binaries (z.B. vorkompilierte Tools, VSCode-Extensions)
  programs.nix-ld.enable = true;

  # Schlägt Pakete vor, wenn ein Befehl nicht gefunden wird
  programs.command-not-found.enable = true;
}
