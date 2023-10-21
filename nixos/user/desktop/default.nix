{ pkgs, lib, ... }:
{
  imports = [ 
    ./espanso
    ./alacritty
    ./hyprland
    ./albert
  ];
  
  # Notifications
  services.mako = {
    enable = true;
    anchor = "top-right";
    defaultTimeout = 3000;
  };
}
