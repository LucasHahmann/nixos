{ config, pkgs, ... }:

let
  unstable = import (fetchTarball "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz") {
    config.allowUnfree = true;
  };
in
{
  environment.systemPackages = [
    unstable.citrix_workspace
  ];
}
