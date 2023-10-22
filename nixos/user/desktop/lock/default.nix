{ lib, ... }:
with lib;
{
  options.wayland.lock = {
    swaylockidle.enable = mkEnableOption "Enable the swaylock swayidle combo";

    lockTime = mkOption {
      type = types.int;
    };
    
    dpmsTime = mkOption {
      type = types.int;
    };

    runDpmsOn = mkOption {
      type = types.str;
    };

    runDpmsOff = mkOption {
      type = types.str;
    };
  };

  imports = [ ./swaylockidle.nix ];
}
