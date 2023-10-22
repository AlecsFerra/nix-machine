{ config, pkgs, lib, ... }:
with lib;
let
  albertPackage = pkgs.albert;
  cfg = config.wayland.runner;
in
{
  config = mkIf cfg.albert.enable {
    home.packages = [ albertPackage ];
    wayland.windowManager.runner = pkgs.writeShellScriptBin "albert-show"
      "${getBin albertPackage}/bin/albert show";
  };
}
