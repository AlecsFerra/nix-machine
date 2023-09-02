{ pkgs, ... }:
let 
  fontName = "FiraCode Nerd Font";
in
{
  programs.alacritty = {
    enable = true;

    settings = {
      env.TERM = "xterm-256color";

      window = {
        dynamic_padding = true;
        decorations = "full";
      };

      font = {
        normal.family = fontName;
        normal.style = "Regular";
        bold.family = fontName;
        bold.style = "Bold";
        italic.family = fontName;
        italic.style = "Italic";
        bold_italic.family = fontName;
        bold_italic.style = "Bold Italic";
      };

      cursor.style = "Beam";

      live_config_reload = true;
    };
  };
}
