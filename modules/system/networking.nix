# Netzwerk & Firewall
{ ... }:

{
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  networking.nameservers = [
    "192.168.178.2"
    "8.8.8.8"
  ];

  # Firewall ist standardmäßig aktiv. Ports bei Bedarf öffnen:
  # networking.firewall.allowedTCPPorts = [ ];
  # networking.firewall.allowedUDPPorts = [ ];
}
