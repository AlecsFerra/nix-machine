{ lib, ... }:
with lib;
{
  options.wayland.multimedia = {
    avizo.enable = mkEnableOption "Use avizo as the hud manager";
    syshud.enable = mkEnableOption "Use syshud as the hud manager";
    swapgrim.enable = mkEnableOption
      "Use swappy and grim as the screenshot tool";
  };

  imports = [ 
    ./avizo.nix
    ./syshud.nix
    ./swapgrim.nix
  ];
}
