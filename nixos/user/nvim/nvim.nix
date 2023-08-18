{ pkgs, ... }:
{
  home.packages = with pkgs; [
    git
    gnumake
    clang
    ripgrep
    fd
    unzip
    xclip
    wl-clipboard
    patchelf
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  home.file.".config/nvim" = {
    source = ./nvim;
    recursive = true;
  };
}
