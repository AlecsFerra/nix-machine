{ lib, ... }:
with lib;
{
  options.wayland.runner = {
    albert.enable = mkEnableOption "Use alber as the system runner";
  };

  imports = [ ./albert.nix ];
}
