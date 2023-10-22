{ config, pkgs, lib, ... }:
with lib;
let
  swaylockPackage = pkgs.swaylock-effects;
  cfg = config.wayland.lock;
in
{
  config = mkIf cfg.swaylockidle.enable {
    wayland.windowManager.runLock = "${getExe swaylockPackage}";

    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;

      settings = {
        "fade-in" = 1;
        grace = 5;
      };
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
          command = "${cfg.runDpmsOn}";
        }
        {
          event = "lock";
          command = "${swaylockPackage}/bin/swaylock";
        }
      ];
      timeouts = [
        {
          timeout = cfg.lockTime;
          command = "${swaylockPackage}/bin/swaylock";
        }
        {
          timeout = cfg.dpmsTime;
          command = "${cfg.runDpmsOff}";
        }
      ];
    };
  };
}
