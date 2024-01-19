{ pkgs, ... }: 
let 
  user = "alecs";
  stylix = pkgs.fetchFromGitHub {
      owner = "danth";
      repo = "stylix";
      rev = "2d59480b4531ce8d062d20a42560a266cb42b9d0";
      hash = "sha256-oRVxuJ6sCljsgfoWb+SsIK2MvUjsxrXQHRoVTUDVC40=";
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
	dolphin-emu
      ];

      # The same as the nix-os state version
      home.stateVersion = "23.05";
    };
  };

}
