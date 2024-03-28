{ pkgs, lib, ... }:
let
  fromStore = pkgs.vscode-utils.extensionFromVscodeMarketplace;
in
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;

    mutableExtensionsDir = false;
    haskell = {
      enable = true;
      hie = {
        enable = true;
	executablePath = pkgs.haskell-language-server.outPath 
	  + "/bin/haskell-language-server-wrapper";
      };
    };
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      # nvarner.typst-lsp
      eamodio.gitlens
      arrterian.nix-env-selector
      zhuangtongfa.material-theme
      jnoortheen.nix-ide
      (fromStore {
	name = "agda-mode";
	publisher = "banacorn";
	version = "0.4.0";
	sha256 = "sha256-H/FgaNlC0HGaIalS17h7xmgKDwAtRE1JgYHuOIW4wbA=";
      })
    ];

    userSettings = {
      "workbench.colorTheme" = lib.mkForce "One Dark Pro";
      "workbench.startupEditor" = "none";
      "keyboard.dispatch" = "keyCode";
      "vim.useSystemClipboard" = true;
      "explorer.excludeGitIgnore" = true;
      "editor.unicodeHighlight.ambiguousCharacters" = false;
    };
  };
}
