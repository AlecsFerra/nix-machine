{ config, pkgs, lib, ... }:
with lib;
{
  imports = [ 
    ./espanso
    ./albert
    ./lock
    ./background
    ./windowManager
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
  };

  # Notifications
  services.mako = {
    enable = true;
    anchor = "top-right";
    defaultTimeout = 3000;
  };
}
