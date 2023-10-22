{ config, pkgs, lib, ... }:
with lib;
{
  imports = [ 
    ./espanso
    ./albert

    # Modularized config
    ./lock
    ./background
    ./windowManager
    ./notifications
  ];

  wayland = {
    lock = {
      swaylockidle.enable = true;
      lockTime = 300;
      dpmsTime = 600;
    };

    windowManager = {
      hyprland.enable = true;
      runRunner = "";
      runTerminal = "${getBin pkgs.alacritty}/bin/alacritty";
    };

    background.swaybg.enable = true;

    notifications.mako.enable = true;
  };
}
