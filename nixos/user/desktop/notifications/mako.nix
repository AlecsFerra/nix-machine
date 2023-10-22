{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.wayland.notifications;
in
{
  config = mkIf cfg.mako.enable {
    services.mako = {
      enable = true;
      anchor = "top-right";
      defaultTimeout = 3000;
    };
  };
}
