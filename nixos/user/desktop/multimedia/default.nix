{ lib, ... }:
with lib;
{
  options.wayland.multimedia = {
    avizo.enable = mkEnableOption "Use avizo as the multimedia manager";
    syshud.enable = mkEnableOption "Use syshud as the multimedia manager";
  };

  imports = [ 
    ./avizo.nix
    ./syshud.nix
  ];
}
