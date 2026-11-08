# Netzwerk & Firewall
{ ... }:

{
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Firewall ist standardmäßig aktiv. Ports bei Bedarf öffnen:
  # networking.firewall.allowedTCPPorts = [ ];
  # networking.firewall.allowedUDPPorts = [ ];
}
