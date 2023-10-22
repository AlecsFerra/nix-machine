{ lib, ... }:
with lib;
{
  options.wayland.lock = {
    swaylockidle.enable = mkEnableOption "Enable the swaylock swayidle combo";

    lockTime = mkOption {
      type = types.int;
      description = 
        "After how many seconds of inactivity the desktop will be locked";
    };
    
    dpmsTime = mkOption {
      type = types.int;
      description = 
        "After how many seconds of inactivity the screen will be turned off";
    };

    runDpmsOn = mkOption {
      type = types.str;
      description = "Command to turn on the screen";
    };

    runDpmsOff = mkOption {
      type = types.str;
      description = "Command to turn off the screen";
    };
  };

  imports = [ ./swaylockidle.nix ];
}
