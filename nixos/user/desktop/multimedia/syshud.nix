{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.wayland.multimedia;
  syshud = pkgs.syshud;

  pamixer = pkgs.pamixer;
  stepAudio = "5";

  brightnessctl = pkgs.brightnessctl;
  stepBrightness = "5";

  colors = config.lib.stylix.colors;
in
{
  config = mkIf cfg.syshud.enable {
    
    systemd.user.services.syshud = {
      Unit = {
        Description = "syshud";
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = pkgs.writeShellScript "syshud" ''
          exec ${getExe syshud}
        '';
        Restart = "on-failure";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };

    xdg.configFile = {
      "sys64/hud/config.conf".text = ''
        [main]
        position=bottom
        orientation=h
        width=300
        height=50
        icon_size=26
        percentage=false
        margins=0 0 50 0
        timeout=3
        transition=250
        backlight=
        monitors=audio_in,audio_out,brightness
      '';

      "sys64/hud/style.css".text = ''
        window {
          background-color: transparent;
        }

        .box_layout {
          background-color: #${colors.base00};
          border-radius: 10px;
          border: 1px solid #${colors.base01};
          margin: 16px;
        }

        scale {
          padding: 0px;
          margin-right: 5px;
        }

        label {
          margin-right: 5px;
          margin-left: 5px;
          color: #${colors.base07};
        }

        scale trough {
          background-color: #${colors.base01};
          padding: 0px;
        }
        scale highlight {
          background-color: #${colors.base0D};
          margin: 0px;
        }
        scale slider {
          background-color: transparent;
          margin: 0px;
          padding: 0px;
          box-shadow: none;
        }

        /* Horizontal layout */
        scale.horizontal,
        scale.horizontal trough,
        scale.horizontal highlight,
        scale.horizontal slider {
          border-radius: 5px;
          min-height: 5px;
        }

        /* Vertical layout */
        scale.vertical,
        scale.vertical trough,
        scale.vertical highlight,
        scale.vertical slider {
          border-radius: 5px;
          min-width: 5px;
        }
      '';
    };

    wayland.windowManager = {
      audio = {
        increase = pkgs.writeShellScriptBin "increase-audio"
          "${getExe pamixer} -i ${stepAudio}";
        decrease = pkgs.writeShellScriptBin "decrease-audio"
          "${getExe pamixer} -d ${stepAudio}";
        mute = pkgs.writeShellScriptBin "mute-audio"
          "${getExe pamixer} -t";
        muteMic = pkgs.writeShellScriptBin "mute-mic"
          "${getExe pamixer} --default-source -t";
      };
      brightness = {
        increase = pkgs.writeShellScriptBin "increase-brightness"
          "${getExe brightnessctl} s ${stepBrightness}%+";
        decrease = pkgs.writeShellScriptBin "decrease-brightness"
          "${getExe brightnessctl} s ${stepBrightness}%-";
      };
    };
  };
}
