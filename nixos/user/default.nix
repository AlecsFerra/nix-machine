{ pkgs, ... }: 
let 
  user = "alecs";
  stylix = import (pkgs.fetchFromGitHub {
    owner = "danth";
    repo = "stylix";
    rev = "c974c17cd089dcbfb16fbde028dd00bcc05e3f73";
    hash = "sha256-HpRE7W000QQmII9Tt/BBEEL6Io1mzUL6rl82QoRQP3A=";
  });
  nixvim = import (pkgs.fetchFromGitHub {
    owner = "nix-community";
    repo = "nixvim";
    rev = "216d64c158da5523d5b3db0895e1345175c21502"; 
    hash = "sha256-iWTGRfYoq0ppT3P4D2bRDVkLuTZAzuud/gsxVzPTHDg=";
  });
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
