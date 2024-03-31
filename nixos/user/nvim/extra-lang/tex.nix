{ pkgs, lib, ... }:
{
  programs.nixvim = {
    plugins.vimtex = {
      enable = true;
      texlivePackage = null;
    };
  };
}
