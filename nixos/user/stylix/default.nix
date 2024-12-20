{ pkgs, ... }:
{
  stylix = {
    enable = true;

    image = ./wallpapers/jnasa.png;

    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/onedark.yaml";

    cursor = {
      size = 24;
    };

    fonts = {
      serif = {
        name = "Cantarell";
        package = pkgs.cantarell-fonts;
      };

      sansSerif = {
        name = "Cantarell";
        package = pkgs.cantarell-fonts;
      };

      monospace = {
	package = pkgs.nerd-fonts.fira-code;
	name = "FiraCode Nerd Font Mono";
      };

      emoji = {
	package = pkgs.noto-fonts-emoji;
	name = "Noto Color Emoji";
      };

      sizes = {
	desktop = 12;
	applications = 12;
	terminal = 12;
	popups = 12;
      };
    };

    opacity = {
      terminal = 0.8;
      popups = 0.6;
    };
  };
}
