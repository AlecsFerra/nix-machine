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
      lock.timeout= 300;
      dpms.timeout = 600;
    };

    windowManager = {
      hyprland.enable = true;
      terminal = pkgs.writeShellScriptBin "alacritty-run"
        "${getBin pkgs.alacritty}/bin/alacritty";
    };
    
    statusbar.eww.enable = true;
    background.swaybg.enable = true;
    notifications.mako.enable = true;
    runner.albert.enable = true;
  };
}
