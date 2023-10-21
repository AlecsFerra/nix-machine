{ pkgs, lib, ... }:
{
  imports = [ 
    ./espanso
    ./alacritty
    ./hyprland
    ./albert.nix
  ];
  
  # Notifications
  services.mako = {
    enable = true;
    anchor = "top-right";
    defaultTimeout = 3000;
  };
}
