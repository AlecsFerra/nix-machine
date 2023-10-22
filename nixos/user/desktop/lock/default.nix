{ lib, ... }:
with lib;
{
  options.wayland.lock = {
    swaylockidle.enable = mkEnableOption "Enable the swaylock swayidle combo";

    lock.timeout = mkOption {
      type = types.int;
      description = 
        "After how many seconds of inactivity the desktop will be locked";
    };
   
    dpms = {
     timeout = mkOption {
        type = types.int;
        description = 
          "After how many seconds of inactivity the DPMS will be set to off";
      }; 

      on = mkOption {
        type = types.package;
        description = "Ecexutable package that sets the DPMS on";
      };

      off = mkOption {
        type = types.package;
        description = "Ecexutable package that sets the DPMS off";
      };
    };
  };

  imports = [ ./swaylockidle.nix ];
}
