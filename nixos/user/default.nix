{ pkgs, ... }: 
let 
  user = "alecs";
  stylix = import (pkgs.fetchFromGitHub {
    owner = "danth";
    repo = "stylix";
    rev = "e309d64fe7f203274a7913e1d2b74307d15ba122";
    hash = "sha256-RH/8yIuo+fNLCjQ6e1mnXwmmxymjvfWC9JcbDuIA8TM=";
  });
  nixvim = import (pkgs.fetchFromGitHub {
    owner = "nix-community";
    repo = "nixvim";
    rev = "08be20270d62e31f215f4592867d53576af15001";
    hash = "sha256-8Meoqfk61EsMB3x/HQcttkgJqUm45kjtOyQGrtHP/H4=";
  });
in
{
  imports = [ 
    <home-manager/nixos> 
    ./keyboardremaps.nix
  ];

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
  	stylix.homeManagerModules.stylix
	nixvim.homeManagerModules.nixvim
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
	qbittorrent
	scrcpy
	tree
	acpi
	mpv
	dolphin-emu
	imv
	wl-mirror
	zotero
	localsend
	(aspellWithDicts (ds: with ds; [ en en-computers it ]))
      ];

      services.syncthing.enable = true;

      xdg.mimeApps = {
	enable = true;
	defaultApplications = {
	  "application/pdf" = "org.pwmt.zathura-pdf-mupdf.desktop;";
	  "x-scheme-handler/http"  = "firefox.desktop";
	  "x-scheme-handler/https" = "firefox.desktop";
	  "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
	};
      };

      # The same as the nix-os state version
      home.stateVersion = "23.05";
    };
  };

}
