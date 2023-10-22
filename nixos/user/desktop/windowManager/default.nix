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
  };

  imports = [ ./hyprland.nix ];
}
