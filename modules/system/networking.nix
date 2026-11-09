# Netzwerk & Firewall
{ pkgs, ... }:

{
  networking.hostName = "LUCAS";
  networking.networkmanager.enable = true;

  services.resolved.enable = true;

  # Namen auf ".local" schickt systemd-resolved sonst NUR per mDNS ins lokale Netz,
  # nie an den DNS-Server. Mit "~domain" gehen diese Domains an den DNS (AdGuard),
  # der sie weiterleitet (z.B. [/hahmann-trier.local/]172.16.10.1).
  services.resolved.settings.Resolve.Domains = [
    "~deimelberg.local"
  ];

  # hahmann-trier.local direkt beim DNS-Server dort fragen – unabhängig von AdGuard
  services.resolved.dnsDelegates.hahmann-trier.Delegate = {
    DNS = "172.16.10.1";
    Domains = "~hahmann-trier.local";
  };

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
