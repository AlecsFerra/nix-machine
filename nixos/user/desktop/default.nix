{ config, pkgs, lib, ... }:
with lib;
let
  stylix = config.stylix;
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

  gtk = {
    enable = true;
    iconTheme.name = "Papirus-Dark";
    iconTheme.package = pkgs.papirus-icon-theme;
  };

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
    notifications.swaync.enable = true;
    runner.ulauncher.enable = true;
    multimedia.syshud.enable = true;
    multimedia.swapgrim.enable = true;
  };
}
