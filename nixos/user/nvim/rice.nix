{ pkgs, ... }:
{
  programs.nixvim = {
    colorschemes.onedark.enable = true;

    plugins.lualine.enable = true;
    plugins.indent-blankline = {
      enable = true;
      useTreesitter = true;
      showTrailingBlanklineIndent = false;
    };
  };
}
