{ pkgs, ... }:
{
  programs.nixvim = {
    extraPackages = with pkgs.vimPlugins; [
      # catppuccin-nvim
    ];

    #colorschemes.one.enable = true;
    colorschemes.onedark.enable = true;
    plugins.rainbow-delimiters.enable = true;
    
    plugins.lualine.enable = true;
    plugins.bufferline.enable = true;
  };
}
