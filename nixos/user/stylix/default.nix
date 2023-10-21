{ pkgs, ... }:
{
  stylix = {
    image = ./wallpapers/akira.jpg;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/onedark.yaml";

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
	package = pkgs.nerdfonts;
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
  };
}
