{ config, pkgs, lib, ... }:
with lib;
{
  imports = [ 
    ./runner
    ./lock
    ./background
    ./windowManager
    ./notifications
    ./statusbar
  ];

  wayland = {
    lock = {
      swaylockidle.enable = true;
      lockTime = 300;
      dpmsTime = 600;
    };

    windowManager = {
      hyprland.enable = true;
      runTerminal = "${getBin pkgs.alacritty}/bin/alacritty";
    };
    
    statusbar.eww.enable = true;
    background.swaybg.enable = true;
    notifications.mako.enable = true;
    runner.albert.enable = true;
  };
}
