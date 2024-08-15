{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.wayland.statusbar;
  
  nmcli = "${getBin pkgs.networkmanager}/bin/nmcli";
  jaq = getExe pkgs.jaq;
  jc = getExe pkgs.jc;
  awk = getExe pkgs.jawk;
  networkInfo = pkgs.writeShellScriptBin "eww-networkinfo"
    ''
      nm="$(${nmcli} d \
          | ${jc} --nmcli  \
          | ${jaq} -r '.[] | select(.type | test("^(wifi|ethernet)$", "ix"))' \
          )"
      
      function make_wifi() {
        icon="󰤨"
        text=$(echo "$nm" | ${jaq} -r 'select(.type == "wifi") .connection')
      }
      
      function make_ethernet() {
        icon="󰈀"
        text=$(echo "$nm" | ${jaq} -r 'select(.type == "ethernet") .connection')
      }

      function make() {
        local ethernet wifi
        ethernet=$(echo "$nm" \
                 | ${jaq} -r 'select(.type == "ethernet") .state')
        wifi=$(echo "$nm" \
             | ${jaq} -r 'select(.type == "wifi") .state')

        if [[ $ethernet == "connected" ]]; then
          make_ethernet
          state="enabled"
        elif [[ $wifi == "connected" ]]; then
          make_wifi
          state="enabled"
        else
          icon=""
          text="Disconnected"
          state="disabled"
        fi
        echo '{"icon": "'"$icon"'", "text": "'"$text"'", "state": "'"$state"'"}'
      }

      make
      ${nmcli} monitor | while read -r _; do
        nm="$(${nmcli} d \
            | ${jc} --nmcli  \
            | ${jaq} -r '.[] | select(.type | test("^(wifi|ethernet)$", "ix"))' \
            )"
        make
      done
    '';
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
                          (100 / arraylength(battery_icons)) - 1,0)] ?: "󰂎"}))

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
        
        (deflisten net "${getExe networkInfo}")
        (defwidget network []
          (label
            :class "network ''${net.state}"
            :tooltip {net.text}
            :text {net.icon}))
      '';

      "eww/system.scss".text = with config.lib.stylix.colors; ''
        .battery-icon {
          padding-right: 0px;
          font-size: 28px;
        }

        .battery-bolt {
          padding-right: 0px;
          font-size: 23px;
          color: #${base0A};
        }

        .battery .low {
          color: #${base08};
        }

        .network {
          font-size: 20px;
          padding-right: 15px;
        }
      '';
    };
  };
}
