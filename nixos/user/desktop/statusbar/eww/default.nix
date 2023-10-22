{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.wayland.statusbar;
  ewwPackage = pkgs.eww-wayland;
in
{
  config = mkIf cfg.eww.enable {
    home.packages = [
      pkgs.eww-wayland
    ];

    systemd.user.services.eww = {
      Unit = {
        Description = "Eww Daemon";
        PartOf = ["graphical-session.target"];
      };
      Service = {
        ExecStart = "${getExe ewwPackage} daemon --no-daemonize";
        Restart = "on-failure";
      };
      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
