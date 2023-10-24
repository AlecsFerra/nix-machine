{ config, pkgs, lib, ... }:
with lib;
let
  swayosd = "${getBin pkgs.swayosd}/bin/swayosd";
  brightnessctl = "${getExe pkgs.brightnessctl}";
in
{
  imports = [ 
    ./runner
    ./lock
    ./background
    ./windowManager
    ./notifications
    ./statusbar
  ];

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
      audio = {
        increase = pkgs.writeShellScriptBin "increase-audio"
          "${swayosd} --output-volume raise";
        decrease = pkgs.writeShellScriptBin "decrease-audio"
          "${swayosd} --output-volume lower";
        mute = pkgs.writeShellScriptBin "mute-audio"
          "${swayosd} --output-volume mute-toggle";
        muteMic = pkgs.writeShellScriptBin "mute-mic"
          "${swayosd} --input-volume mute-toggle";
      };
      brightness = {
        increase = pkgs.writeShellScriptBin "increase-audio"
          "${brightnessctl} set 5%+";
        decrease = pkgs.writeShellScriptBin "decrease-audio"
          "${brightnessctl} set 5%-";
      };
    };
    
    background.swaybg.enable = true;
    statusbar.eww.enable = true;
    notifications.mako.enable = true;
    runner.albert.enable = true;
  };
}
