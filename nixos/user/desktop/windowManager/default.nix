{ lib, ... }:
with lib;
{
  options.wayland.windowManager = {
    runTerminal = mkOption {
      type = types.str;
      description = "Command to be launched with the SUPER+Enter combination";
    };

    runRunner = mkOption {
      type = types.str;
      description = "Command to be launched with the SUPER+D key combinaton";
    };
    
    runLock = mkOption {
      type = types.str;
      description = "Command to be launched with the SUPER+L key combinaton";
    };
  };

  imports = [ ./hyprland.nix ];
}
