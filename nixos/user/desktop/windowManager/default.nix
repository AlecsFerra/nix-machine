{ lib, ... }:
with lib;
{
  options.wayland.windowManager = {
    terminal = mkOption {
      type = types.package;
      description = 
        "Executable package to be launched with the SUPER+Enter combination";
    };

    runner = mkOption {
      type = types.package;
      description =
        "Executable package to be launched with the SUPER+D combination";
    };
    
    lock = mkOption {
      type = types.package;
      description =
        "Executable package to be launched with the SUPER+L combination";
    };

    audio = {
      increase = mkOption {
        type = types.package;
        description = 
          "Executable package to be launched to increase the audio volume";
      };
      decrease = mkOption {
        type = types.package;
        description = 
          "Executable package to be launched to decrease the audio volume";
      };
      mute = mkOption {
        type = types.package;
        description = 
          "Executable package to be launched to mute the audio volume";
      };
      muteMic = mkOption {
        type = types.package;
        description = 
          "Executable package to be launched to mute the microphone";
      };
    };


    brightness = {
      increase = mkOption {
        type = types.package;
        description = 
          "Executable package to be launched to increase the brightness";
      };
      decrease = mkOption {
        type = types.package;
        description = 
          "Executable package to be launched to decrease the brightness";
      };
    };
  };

  imports = [ ./hyprland.nix ];
}
