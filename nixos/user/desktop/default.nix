{ pkgs, lib, ... }:
{
  imports = [ 
    ./espanso
    ./alacritty
    ./hyprland
    ./albert
  ];
  
  home.packages = with pkgs; [
    # Brightness keybindings
    brightnessctl
    # Show
    swayosd
  ];

  # Notifications
  services.mako = {
    enable = true;
    anchor = "top-right";
    defaultTimeout = 3000;
  };
}
