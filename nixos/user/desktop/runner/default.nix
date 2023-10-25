{ lib, ... }:
with lib;
{
  options.wayland.runner = {
    ulauncher.enable = mkEnableOption "Use ulancher as the system runner";
  };

  imports = [ 
    ./ulauncher
  ];
}
