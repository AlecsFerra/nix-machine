{ pkgs, ... }:
let
  nixvim = import (builtins.fetchGit {
    url = "https://github.com/nix-community/nixvim";
  });
in
{
  imports = [
    nixvim.homeManagerModules.nixvim
    ./utils.nix
    ./rice.nix
    ./git.nix
    ./lsp.nix
  ];

  home.packages = with pkgs; [
    xclip
    wl-clipboard
  ];

  programs.nixvim = {
    enable = true;

    globals = {
      mapleader = " ";
      maploacalleader = " ";
    };

    options = {
      mouse = "a";
      clipboard = "unnamedplus";
      
      breakindent = true;
      tabstop = 4;
      shiftwidth = 2;
      expandtab = true;
      colorcolumn = "80";

      undofile = true;
      swapfile = false;

      hlsearch = false;
      ignorecase = true;
      smartcase = true;

      number = true;
      signcolumn = "yes";

      updatetime = 250;
      timeoutlen = 300;

      termguicolors = true;
    };

    maps.normal = {
      "gt" = {
        action = ":bnext<CR>";
        desc = "[G]oto nex[T] buffer";
      };
      "gT" = {
        action = ":bprevious<CR>";
        desc = "[G]oto previus buffer";
      };
      "M" = {
        action = "<Esc>:m .+1<CR>";
        desc = "[M]ove current line down";
      };
      "m" = {
        action = "<Esc>:m .-2<CR>";
        desc = "[M]ove current line up";
      };
    };
  };
}
