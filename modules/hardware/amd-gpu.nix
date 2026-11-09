# AMD Radeon RX 6700 XT (Navi 22 / RDNA2, gfx1031)
# Treiber: amdgpu (Kernel) + Mesa (RADV für Vulkan, radeonsi für OpenGL/VA-API).
# Proprietäre Treiber sind nicht nötig.
{ ... }:

{
  # Mesa-Grafikstack, inkl. 32-Bit für Steam/Proton/Wine
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # amdgpu schon im initrd laden: korrekte Auflösung ab dem Bootvorgang, kein Flackern beim Umschalten
  hardware.amdgpu.initrd.enable = true;

  # GUI für Lüfterkurven, Taktraten, Power-Limits
  # (Benutzer muss in der Gruppe "corectrl" sein – siehe users/lhahmann.nix)
  programs.corectrl.enable = true;

  # Schaltet Overclocking/Undervolting frei (amdgpu.ppfeaturemask)
  hardware.amdgpu.overdrive.enable = true;
}
