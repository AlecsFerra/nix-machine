{ pkgs, ... }:
{
  imports = [ 
    ./agda.nix 
    ./nix.nix
    ./haskell.nix
  ];
}
