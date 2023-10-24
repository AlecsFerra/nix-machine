{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.wayland.statusbar;
in
{
  config = mkIf cfg.eww.enable {
    xdg.configFile = {
      "eww/system.yuck".text = ''
        (defvar battery_icons `["󰂎", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]`)

        (defwidget battery-icon []
          (label
            :angle 270
            :class "battery-icon ''${EWW_BATTERY.total_avg > 20 ? ''' : 'low'}"
            :tooltip "Battery on ''${round(EWW_BATTERY.total_avg,0)}% 
                      (''${EWW_BATTERY.BAT0.status})"
            :text {battery_icons[
                    round(EWW_BATTERY.total_avg / 
                          (100 / arraylength(battery_icons)) - 1,0)]}))

        (defwidget charging-icon []
          (label
            :class "battery-bolt"
            :tooltip "Battery on ''${round(EWW_BATTERY.total_avg,0)}% 
                      (''${EWW_BATTERY.BAT0.status})"
            :text {EWW_BATTERY.BAT0.status == "Charging" ? "󱐋" : ""}))
        
        (defwidget battery []
          (overlay
            :class "battery"
            (battery-icon)
            (charging-icon)))
      '';

      "eww/system.scss".text = with config.lib.stylix.colors; ''
        .battery-icon {
          padding-right: 0px;
          font-size: 28px;
        }

        .battery-bolt {
          padding-right: 0px;
          font-size: 16px;
          color: #${base04};
        }

        .battery .low {
          color: #${base08};
        }
      '';
    };
  };
}
