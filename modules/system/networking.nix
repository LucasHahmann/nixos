# Netzwerk & Firewall
{ pkgs, ... }:

{
  networking.hostName = "LUCAS";
  networking.networkmanager.enable = true;

  services.resolved.enable = true;

  networking.nameservers = [
    "192.168.178.2"
    "8.8.8.8"
  ];

  environment.systemPackages = with pkgs; [
    dnsutils
  ];

  # Firewall ist standardmäßig aktiv. Ports bei Bedarf öffnen:
  # networking.firewall.allowedTCPPorts = [ ];
  # networking.firewall.allowedUDPPorts = [ ];
}
