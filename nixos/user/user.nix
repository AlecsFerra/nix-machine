{ pkgs, ... }: 
let 
  user = "alecs";
in
{
  imports = [ <home-manager/nixos> ];
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ 
      "wheel"
      "video"
      "audio"
      "input"
      "lp"
      "scanner"
    ];
  };


  home-manager = {
    useGlobalPkgs = true;
    users.${user} = { pkgs, ... }: {
      
      imports = [
        ./shell.nix
        ./espanso/espanso.nix
	./development/development.nix
	./nvim/nvim.nix
	./alacritty.nix
	./firefox.nix
      ];

      # Installed packages at the user level
      home.packages = with pkgs; [
        telegram-desktop
        bitwarden
	htop
	neofetch
	zathura
      ];

      # The same as the nix-os state version
      home.stateVersion = "23.05";
    };
  };

}
