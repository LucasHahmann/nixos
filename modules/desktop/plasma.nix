# KDE Plasma 6 Desktop
{ ... }:

{
  # X11 – nur nötig, wenn du auch die X11-Session nutzen willst
  services.xserver.enable = true;

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
}
