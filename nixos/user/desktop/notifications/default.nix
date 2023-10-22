{ lib, ... }:
with lib;
{
  options.wayland.notifications = {
    mako.enable = mkEnableOption "Enable the mako notification service";
  };

  imports = [ ./mako.nix ];
}
