{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.wayland.statusbar;
in
{
  config = mkIf cfg.eww.enable {
    xdg.configFile = {
      "eww/eww.yuck".text = ''
        (include "workspaces.yuck")
        (include "system.yuck")

        (defwidget left []
          (box
            :space-evenly false
            :halign "start"
            (label :class "distro" :text "")
            (workspaces)))

        (defwidget right []
          (box
            :class "right"
            :space-evenly false
            :halign "end"
            (battery)))
        
        (defpoll time
          :interval "10s"
          "${getBin pkgs.coreutils}/bin/date +'%a %d %b %H:%M'")
        (defwidget clock []
          (box :class "clock"
            time))
        (defwidget center []
          (box
            :space-evenly false
            :halign "center"
            (clock)))

        (defwidget bar-box []
          (centerbox
            (left)
            (center)
            (right)))

        (defwindow bar
          :monitor 0
          :geometry
            (geometry
              :x "0%"
              :y "0%"
              :width "100%"
              :height "32px"
              :anchor "top center")
          :stacking "fg"
          :exclusive true
          :namespace "bar"
          (bar-box))
      '';

      "eww/eww.scss".text = with config.lib.stylix.colors; ''
        @import "workspaces"
        @import "system"

        * {
          font-family: "Fira Code";
          border-radius: 0;
        }

        .distro {
          background-color: #${base0D};
          color: white;
          padding: 0 18px 0 10px;
          font-size: 22px;
        }

        .right {
          padding-right: 12px;
        }
      '';
    };
  };

  imports = [
    ./workspaces.nix
    ./system.nix
  ];
}
