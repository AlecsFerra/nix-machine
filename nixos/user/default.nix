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
        ./shell
	./development
	./nvim
	./desktop
	./firefox
      ];

      # Installed packages at the user level
      home.packages = with pkgs; [
        telegram-desktop
        bitwarden
	htop
	neofetch
	zathura
	python3
	unzip
	chromium
	qbittorrent
	scrcpy
	gnome.gnome-session
      ];

      # The same as the nix-os state version
      home.stateVersion = "23.05";
    };
  };

}
