{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.wayland.statusbar;
  generateWorkspaces = pkgs.writeShellScriptBin "eww-generate-workspaces"
    ''
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
            print '"active icon-shift"'
          elif [[ ''${occupied[@]} =~ $i ]]; then
            print '"occupied icon-shift"'
          else
            print '"empty icon-shift"'
          fi
          print '"")'
        done
        print ')'
        echo ""
      }

      print_ws
      ${getExe cfg.workspaces.listen} | while read -r; do
        print_ws
      done
    '';
in
{
  config = mkIf cfg.eww.enable {

    xdg.configFile = {
      "eww/workspaces.yuck".text = ''
        (deflisten workspaces-data "${getExe generateWorkspaces}")
        (defwidget workspaces []
          (literal :content workspaces-data))
      '';

      "eww/workspaces.scss".text = with config.lib.stylix.colors; ''
        .workspace-module > * {
          background-color: rgba(0, 0, 0, 0);

          margin: 0px;
          font-size: 17px;
        }

        .workspace-module > .active {
          color: #${base0A};
        }

        .workspace-module > .occupied {
          color: #${base0D};
        }

        .workspace-module > .empty {
          color: #${base03};
        }
      '';
    };
  };
}
