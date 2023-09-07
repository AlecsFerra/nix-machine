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

    # Julia 
    julia
    # IJulia
    jupyter
    python311Packages.jupyterlab
    python311Packages.jupyter-core

    # Agda
    (agda.withPackages [
      agdaPackages.standard-library
      agdaPackages.cubical
    ])
  ];
}
