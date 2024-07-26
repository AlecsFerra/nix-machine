{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.wayland.multimedia;
in
{
  config = mkIf cfg.swapgrim.enable {
    wayland.windowManager.screenshot = pkgs.writeShellScriptBin 
      "screenshoot-default"
      ''
        ${getExe pkgs.grim} -g "$(${getExe pkgs.slurp})" - \
          | ${getExe pkgs.swappy} -f -
      '';

    xdg.configFile."swappy/config".text = ''
      [Default]
      save_dir=$HOME/Pictures/Screenshots
      save_filename_format=screenshot-%Y%m%d-%H%M%S.png
      early_exit=true
      show_panel=false
      line_size=5
      text_size=20
      text_font=sans-serif
      paint_mode=brush
      fill_shape=false
    '';
  };
}
