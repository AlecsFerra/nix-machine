{ pkgs, ... }:
let
  nixvim = import (builtins.fetchGit {
    url = "https://github.com/nix-community/nixvim";
    rev = "060a05138ca1a46fc0a0f79ef27f080cac57a59e"; 
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
      tabstop = 2;
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

    keymaps = [
      {
        mode = "n";
        key = "gt";
        action = ":bnext<CR>";
        options = {
          desc = "[G]oto nex[T] buffer";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "gT";
        action = ":bprevious<CR>";
        options = {
          desc = "[G]oto previus buffer";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "M";
        action = "<Esc>:m .+1<CR>";
        options = {
          desc = "[M]ove current line down";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "m";
        action = "<Esc>:m .-2<CR>";
        options = {
          desc = "[M]ove current line up";
          silent = true;
        };
      }
      {
        mode = "t";
        key = "<Esc>";
        action = "<C-\\><C-N>";
        options = {
          silent = true;
        };
      }
    ];
    
  };
}
