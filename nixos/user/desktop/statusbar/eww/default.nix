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

    programs.eww.package = ewwPackage;

    systemd.user.services.eww = {
      Unit = {
        Description = "Eww Daemon";
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Environment = "PATH=/run/current-system/sw/bin";
        ExecStart = ''
          ${getExe ewwPackage} daemon --no-daemonize
        '';
        ExecStartPost = ''
          ${getExe ewwPackage} open bar
        '';
        Restart = "on-failure";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };

  imports = [ ./eww.nix ];
}
