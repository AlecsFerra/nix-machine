{ pkgs, ... }:
{
  services.espanso = {
    enable = true;
    package = pkgs.espanso-wayland;
    configs = {
      default."seach_shortcut" = "off";
    };
  };

  home.file.".config/espanso/match" = {
    source = ./match;
    recursive = true;
  };
}
