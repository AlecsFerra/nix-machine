{ config, pkgs, lib, ... }:
with lib;
let
  swaylockPackage = pkgs.swaylock-effects;
  cfg = config.wayland.lock;
in
{
  config = mkIf cfg.swaylockidle.enable {
    wayland.windowManager.lock = swaylockPackage;

    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;

      settings = {
        "fade-in" = 1;
        grace = 5;
      };
    };

    systemd.user.services.inhibitIdle = {
      Unit = {
        Description = "sway-audio-idle-inhibit-wrapper";
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = pkgs.writeShellScript "sway-audio-idle-inhibit-wrapper" ''
          exec ${getExe pkgs.sway-audio-idle-inhibit}
        '';
        Restart = "on-failure";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };

    services.swayidle = {
      enable = true;
      systemdTarget = "graphical-session.target";
      events = [
        {
          event = "before-sleep";
          command = "${swaylockPackage}/bin/swaylock";
        }
        {
          event = "after-resume";
          command = "${getExe cfg.dpms.on}";
        }
        {
          event = "lock";
          command = "${swaylockPackage}/bin/swaylock";
        }
      ];
      timeouts = [
        {
          timeout = cfg.lock.timeout;
          command = "${swaylockPackage}/bin/swaylock";
        }
        {
          timeout = cfg.dpms.timeout;
          command = "${getExe cfg.dpms.off}";
        }
      ];
    };
  };
}
