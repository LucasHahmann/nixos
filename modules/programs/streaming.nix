# Streaming & Aufnahme: OBS, Stream Deck, Kameras, Videoschnitt
# Hardware: Elgato HD60 X, Razer Kiyo Pro, Elgato Stream Deck MK.2
{ config, pkgs, ... }:

{
  programs.obs-studio = {
    enable = true;
    # Virtuelle Kamera wird unten selbst eingerichtet (eigene Gerätenummer)
    enableVirtualCamera = false;
    plugins = with pkgs.obs-studio-plugins; [
      obs-vkcapture # Spielaufnahme (Vulkan/OpenGL)
      obs-pipewire-audio-capture # z.B. Discord als eigene Tonspur
    ];
  };

  # Virtuelle OBS-Kamera via v4l2loopback auf /dev/video10
  # (statt /dev/video1 – das belegt schon die Elgato)
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=10 card_label="OBS Cam" exclusive_caps=1
  '';
  security.polkit.enable = true; # OBS lädt das Modul bei Bedarf über pkexec

  # Stream Deck: KDE-Variante + udev-Regeln für den Gerätezugriff ohne root
  programs.streamcontroller.enable = true;

  environment.systemPackages = with pkgs; [
    obs-studio-plugins.obs-vkcapture # zusätzlich systemweit: Vulkan-Layer + `obs-gamecapture %command%`
    cameractrls # Kamera-Einstellungen (Kiyo Pro)
    kdePackages.kdenlive
    ffmpeg-full
  ];
}
