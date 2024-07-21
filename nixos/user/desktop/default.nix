{ config, pkgs, lib, ... }:
with lib;
{
  imports = [ 
    ./runner
    ./lock
    ./background
    ./windowManager
    ./notifications
    ./statusbar
    ./multimedia
  ];

  wayland = {
    lock = {
      swaylockidle.enable = true;
      lock.timeout= 300;
      dpms.timeout = 600;
    };

    windowManager = {
      hyprland.enable = true;
      terminal = pkgs.writeShellScriptBin "alacritty-run"
        "${getBin pkgs.alacritty}/bin/alacritty";

      screenshot = pkgs.writeShellScriptBin "screenshoot-default"
        ''
          ${getExe pkgs.grim} -g "$(${getExe pkgs.slurp})" - \
          | ${getExe pkgs.swappy} -f -
        '';
    };
    
    background.swaybg.enable = true;
    statusbar.eww.enable = true;
    notifications.swaync.enable = true;
    runner.ulauncher.enable = true;
    multimedia.avizo.enable = true;
  };
}
