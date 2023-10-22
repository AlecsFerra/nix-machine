{ lib, ... }:
with lib;
{
  options.wayland.background = {
    swaybg.enable = mkEnableOption "Use swaybg to set the walpaper automatically";
  };

  imports = [ ./swaybg.nix ];
}
