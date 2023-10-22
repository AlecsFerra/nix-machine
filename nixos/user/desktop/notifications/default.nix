{ lib, ... }:
with lib;
{
  options.wayland.notifications = {
    mako.enable = mkEnableOption "Enable the swaylock swayidle combo";
  };

  imports = [ ./mako.nix ];
}
