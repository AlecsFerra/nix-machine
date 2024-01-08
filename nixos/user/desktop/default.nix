{ config, pkgs, lib, ... }:
with lib;
let
  avizo = "${getBin pkgs.avizo}/bin/";
in
{
  imports = [ 
    ./runner
    ./lock
    ./background
    ./windowManager
    ./notifications
    ./statusbar
    ./multimedia
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
    
    background.swaybg.enable = true;
    statusbar.eww.enable = true;
    notifications.mako.enable = true;
    runner.ulauncher.enable = true;
    multimedia.avizo.enable = true;
  };
}
