{ config, pkgs, lib, ... }:
{
  imports = [ 
    ./espanso
    ./hyprland
    ./albert
    ./lock
  ];
  
  home.packages = with pkgs; [
    # Brightness keybindings
    brightnessctl
    # Show
    swayosd
    # Background
    swaybg
  ];

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
