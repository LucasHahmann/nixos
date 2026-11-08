# AMD Radeon RX 6700 XT (Navi 22)
{ ... }:

{
  # GUI für Lüfterkurven, Taktraten, Power-Limits
  # (Benutzer muss in der Gruppe "corectrl" sein – siehe users/lhahmann.nix)
  programs.corectrl.enable = true;

  # Schaltet Overclocking/Undervolting frei (amdgpu.ppfeaturemask)
  hardware.amdgpu.overdrive.enable = true;
}
