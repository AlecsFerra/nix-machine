{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.wayland.background.swaybg;
in
{
  config = mkIf cfg.enable {
    home.packages = [ pkgs.swaybg ];
    
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

  };
}
