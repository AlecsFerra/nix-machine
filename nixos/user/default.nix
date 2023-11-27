{ pkgs, ... }: 
let 
  user = "alecs";
  stylix = pkgs.fetchFromGitHub {
      owner = "danth";
      repo = "stylix";
      rev = "8b3f61727f3b86c27096c3c014ae602aa40670ba";
      hash = "sha256-j1Isg4ln4bfgSGuETvYPzEdEIRc/tBPpLqXa+bfvBf0=";
  };
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

  programs.dconf.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    users.${user} = { pkgs, ... }: {
      
      imports = [
	 (import stylix).homeManagerModules.stylix
        ./shell
	./development
	./nvim
	./desktop
	./firefox
	./alacritty
	./stylix
      ];

      # Installed packages at the user level
      home.packages = with pkgs; [
        telegram-desktop
        bitwarden
	btop
	neofetch
	zathura
	python3
	unzip
	chromium
	qbittorrent
	scrcpy
	tree
	acpi
	mpv
      ];

      # The same as the nix-os state version
      home.stateVersion = "23.05";
    };
  };

}
