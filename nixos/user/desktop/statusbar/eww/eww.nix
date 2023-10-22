{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.wayland.statusbar;
in
{
  config = mkIf cfg.eww.enable {
    
    xdg.configFile = {
      "eww/workspaces.sh" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash
          print() {
            echo -n " $1 "
          }

          print_ws() {
            active=(`${getExe cfg.workspaces.active}`)
            occupied=(`${getExe cfg.workspaces.occupied}`)
            
            print '(box :class "workspace-module" :orientation "h"'
            print ':spacing 1 :space-evenly "true"'
            for i in {1..${toString cfg.workspaces.number}}; do
              print '(button :class'
              if [[ ''${active[@]} =~ $i ]]; then
                print '"active"'
              elif [[ ''${occupied[@]} =~ $i ]]; then
                print '"occupied"'
              else
                print '"empty"'
              fi
              print '"")'
            done
            print ')'
            echo ""
          }

          print_ws
          ${getExe cfg.workspaces.listen} | while read -r; do
            print_ws
          done
        '';
      };
      
      "eww/eww.yuck".text = ''
        (deflisten workspaces-data "~/.config/eww/workspaces.sh")
        (defwidget workspaces []
          (literal :content workspaces-data))

        (defwidget left []
          (box
            :space-evenly false
            :halign "start"
            (button "pippo")
            (workspaces)))
        
        (defwidget right []
          (box
            :space-evenly false
            :halign "end"
            ))
        
        (defwidget center []
          (box
            :space-evenly false
            :halign "center"
            ))

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

      "eww/eww.scss".text = ''
        * {
          color: white;
        }

        .workspace-module {
          background-color: pink;
        }
      '';
    };
  };
}
