{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.wayland.notifications;
in
{
  config = mkIf cfg.swaync.enable {
    home.packages = with pkgs; [ 
      swaynotificationcenter
    ];

    systemd.user.services.swaync = {
      Unit = {
        Description = "Swaync Daemon";
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = pkgs.writeShellScript "swaync-env-wrapper" ''
          exec ${getBin pkgs.swaynotificationcenter}/bin/swaync
        '';
        Restart = "on-failure";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
