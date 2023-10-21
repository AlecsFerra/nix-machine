{ config, pkgs, lib, ... }:
let
  wmPackage = config.wayland.windowManager.hyprland.package;
  swaylockPackage = pkgs.swaylock-effects;
in
{
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;

    settings = {
      "fade-in" = 1;
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
        command = "${wmPackage}/bin/hyprctl dispatch dpms on";
      }
      {
        event = "lock";
        command = "${swaylockPackage}/bin/swaylock";
      }
    ];
    timeouts = [
      {
        timeout = 300;
        command = "${swaylockPackage}/bin/swaylock";
      }
      {
        timeout = 600;
        command = "${wmPackage}/bin/hyprctl dispatch dpms off";
      }
    ];
  };
}
