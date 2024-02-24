{ config, pkgs, lib, ... }:
with lib;
let
  ulauncherPackage = pkgs.ulauncher;
  cfg = config.wayland.runner;
in
{
  config = mkIf cfg.ulauncher.enable {
    home.packages = with pkgs; [ 
      ulauncherPackage
    ];

    wayland.windowManager.runner = pkgs.writeShellScriptBin "ulancher-show"
      "${getBin ulauncherPackage}/bin/ulauncher-toggle";

    systemd.user.services.ulauncher = {
      Unit = {
        Description = "Ulauncher Daemon";
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = pkgs.writeShellScript "ulauncher-env-wrapper" ''
          export PATH="${makeBinPath [
            "$HOME/.nix-profile"
            "/run/current-system/sw"
            pkgs.bitwarden-cli
            pkgs.libqalculate
          ]}"
          ${pkgs.libqalculate}/bin/qalc -e
          exec ${getBin ulauncherPackage}/bin/ulauncher --hide-window
        '';
        Restart = "on-failure";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };

    xdg.configFile."ulauncher/settings.json".source = ./settings.json;
    xdg.configFile."ulauncher/extensions.json".source = ./extensions.json;

  };
}
