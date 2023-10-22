{ pkgs, ... }: 
let 
  user = "alecs";
  stylix = pkgs.fetchFromGitHub {
      owner = "danth";
      repo = "stylix";
      rev = "c3c9f4784b4f08f6676340126858d936edbce1fa";
      sha256 = "sha256-oJGESNjJ/6o6tfuUavBZ7go4Oun7g9YKv7OqaQaY/80=";
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
	htop
	neofetch
	zathura
	python3
	unzip
	chromium
	qbittorrent
	scrcpy
	tree
	acpi
      ];

      # The same as the nix-os state version
      home.stateVersion = "23.05";
    };
  };

}
