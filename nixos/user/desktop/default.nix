{ config, pkgs, lib, ... }:
with lib;
{
  imports = [ 
    ./espanso
    ./albert
    ./lock
    ./windowManager
  ];
  
  home.packages = with pkgs; [
    # Background
    swaybg
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
  };

  systemd.user.services = {
    # Set background on startup
    wallpaper = {
      Service.ExecStart = 
        "${pkgs.swaybg}/bin/swaybg -m fill -i ${config.stylix.image}";
      Install = {
        WantedBy = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
    };
  };

  # Notifications
  services.mako = {
    enable = true;
    anchor = "top-right";
    defaultTimeout = 3000;
  };
}
