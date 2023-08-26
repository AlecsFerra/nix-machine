{ pkgs, ... }:
{
  programs.nixvim = {
    extraPackages = with pkgs.vimPlugins; [
      # catppuccin-nvim
    ];

    #colorschemes.one.enable = true;
    colorschemes.onedark.enable = true;

    plugins.lualine.enable = true;
    plugins.indent-blankline = {
      enable = true;
      useTreesitter = true;
      showTrailingBlanklineIndent = false;
    };
  };
}
