{ pkgs, ... }:
{
  programs.alacritty = {
    enable = true;

    settings = {
      env.TERM = "xterm-256color";

      window = {
        dynamic_padding = true;
        decorations = "full";
      };
      cursor.style = "Beam";

      general.live_config_reload = true;
    };
  };
}
