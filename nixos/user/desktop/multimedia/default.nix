{ lib, ... }:
with lib;
{
  options.wayland.multimedia = {
    avizo.enable = mkEnableOption "Use avizo as the multimedia manager";
  };

  imports = [ 
    ./avizo.nix
  ];
}
