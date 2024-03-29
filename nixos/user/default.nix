{ pkgs, ... }: 
let 
  user = "alecs";
  stylix = pkgs.fetchFromGitHub {
      owner = "danth";
      repo = "stylix";
      rev = "6c447e8761018fa75dfdc20df6232d67a8cc93f2";
      hash = "sha256-HpRE7W000QQmII9Tt/BBEEL6Io1mzUL6rl82QoRQP3A=";
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
	imv
	wl-mirror
	(aspellWithDicts (ds: with ds; [ en en-computers en-science it ]))
      ];

      # The same as the nix-os state version
      home.stateVersion = "23.05";
    };
  };

}
