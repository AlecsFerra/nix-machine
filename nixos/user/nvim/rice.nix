{ pkgs, ... }:
{
  programs.nixvim = {
    colorschemes.onedark.enable = true;
    plugins.rainbow-delimiters.enable = true;
    
    plugins.lualine.enable = true;
    plugins.bufferline.enable = true;
  };
}
