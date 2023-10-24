{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.wayland.statusbar;
in
{
  config = mkIf cfg.eww.enable {
    xdg.configFile = {
      "eww/system.yuck".text = ''
        (defvar battery_charging    `["󰢟", "󰢜", "󰂆", "󰂇", "󰂈", "󰢝", "󰂉", "󰢞", "󰂊", "󰂋", "󰂄"]`)
        (defvar battery_discharging `["󰂎", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]`)

        (defwidget battery []
          (box
            :class "battery"
            (label
              :angle 270
              :class "icon ''${EWW_BATTERY.total_avg > 20 ? ''' : 'low'}"
              :tooltip "battery on ''${round(EWW_BATTERY.total_avg,0)}% (''${EWW_BATTERY.BAT0.status})"
              :text {(EWW_BATTERY.BAT0.status =='Charging' ?
                battery_charging : 
                battery_discharging)
                  [round(EWW_BATTERY.total_avg / (100 / arraylength(battery_charging)) - 1,0)]})))
      '';

      "eww/system.scss".text = with config.lib.stylix.colors; ''
        .battery {
          padding-right: 0px;
          font-size: 28px;
        }

        .battery .low {
          color: #${base08};
        }
      '';
    };
  };
}
