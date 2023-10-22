{ pkgs, ... }:
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
      nvarner.typst-lsp
      eamodio.gitlens
      arrterian.nix-env-selector
      zhuangtongfa.material-theme
      (fromStore {
	name = "agda-mode";
	publisher = "banacorn";
	version = "0.4.0";
	sha256 = "sha256-H/FgaNlC0HGaIalS17h7xmgKDwAtRE1JgYHuOIW4wbA=";
      })
    ];

    userSettings = {
      "workbench.colorTheme" = "Stylix";
      "workbench.startupEditor" = "none";
    };
  };
}
