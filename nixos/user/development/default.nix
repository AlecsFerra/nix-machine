{ pkgs, ... }:
{
  imports = [
    ./git.nix
    ./vscode.nix
  ];

  # General
  home.packages = with pkgs; [
    # Typst
    typst

    # Haskell
    (haskell-language-server.override { 
      supportedGhcVersions = [ 
        "928"
      ]; 
    })
    ghc
    stack

    # Agda
    (agda.withPackages [
      agdaPackages.standard-library
      agdaPackages.cubical
    ])

    # LaTeX
    texlive.combined.scheme-full
  ];
}
