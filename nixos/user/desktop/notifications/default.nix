{ lib, ... }:
with lib;
{
  options.wayland.notifications = {
    mako.enable = mkEnableOption "Enable the mako notification service";
    swaync.enable = mkEnableOption "Enable the swaync notification service";
  };

  imports = [ 
    ./mako.nix
    ./swaync.nix
  ];
}
