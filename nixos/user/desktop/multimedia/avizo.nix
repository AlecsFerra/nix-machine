{ config, pkgs, lib, ... }:
with lib;
let
  avizo = pkgs.avizo;
  cfg = config.wayland.multimedia;
  colors = config.lib.stylix.colors;
in
{
  config = mkIf cfg.avizo.enable {
    
    services.avizo = {
      enable = true;
      settings.default = {
        image-opacity = lib.mkForce 1;
        border-width = lib.mkForce 0;
      };
    };

    wayland.windowManager = {
      audio = {
        increase = pkgs.writeShellScriptBin "increase-audio"
          "${getBin avizo}/bin/volumectl -u up";
        decrease = pkgs.writeShellScriptBin "decrease-audio"
          "${getBin avizo}/bin/volumectl -u down";
        mute = pkgs.writeShellScriptBin "mute-audio"
          "${getBin avizo}/bin/volumectl toggle-mute";
        muteMic = pkgs.writeShellScriptBin "mute-mic"
          "${avizo}/bin/volumectl -m toggle-mute";
      };
      brightness = {
        increase = pkgs.writeShellScriptBin "increase-brightness"
          "${getBin avizo}/bin/lightctl up";
        decrease = pkgs.writeShellScriptBin "decrease-brightness"
          "${getBin avizo}/bin/lightctl down";
      };
    };
  };
}
