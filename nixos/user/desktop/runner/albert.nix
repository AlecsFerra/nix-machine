{ config, pkgs, lib, ... }:
with lib;
let
  albertPackage = pkgs.albert;
  cfg = config.wayland.runner;
in
{
  config = mkIf cfg.albert.enable {
    home.packages = [ albertPackage ];
    wayland.windowManager.runRunner = "${getBin albertPackage}/bin/albert show";
  };
}
