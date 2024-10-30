{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./user
  ];
  
  # +500M boot efi partition
  # +100% luks-root partition
  #       +         root partition
  fileSystems = {
    "/" = { 
      device = "/dev/disk/by-label/root"; 
      fsType = "ext4";
    };
    "/boot" = { 
      device = "/dev/disk/by-label/boot"; 
      fsType = "vfat";
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "uinput" ];

    # Systemd boot
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
    };

    # LUKS
    initrd.luks.devices.luksroot = {
      name = "luksroot";
      device = "/dev/disk/by-label/luks-root";
      preLVM = true;
      allowDiscards = true;
    };
  };

  networking = {
    hostName = "fuck-nixos";
    # Network Manager: 
    networkmanager.enable = true;
    # WPA supplicant
    # wireless.enable = true;

    nameservers = [ "1.1.1.1" ];
  };

  time.timeZone = "Europe/Amsterdam";

  # Localization stuff
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "it_IT.UTF-8";
      LC_MONETARY = "it_IT.UTF-8";
      LC_MEASUREMENT = "it_IT.UTF-8";
      LC_PAPER = "it_IT.UTF-8";
    };
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [
      "FiraCode"
    ]; })
  ];

  console = {
    keyMap = "it";
  };

  # Zsh is the system shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  users.users.alecs.initialPassword = "";
  environment.shells = [ pkgs.zsh ];
  
  services = { 
    # CUPS
    printing.enable = true;

    # Audio settings
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    #power-profiles-daemon.enable = true;
    thermald.enable = true;
    tlp = {
      enable = true;
      settings = {
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      };
    };

    # OpenSSH
    openssh.enable = true;

    # Fingerprint reader
    fprintd.enable = true;
    fprintd.package = pkgs.fprintd.overrideAttrs (_: { 
      mesonCheckFlags = [ 
        "--suite" "nonexistent_suite"
      ]; 
    });

    fwupd.enable = true;
  };

  security.pam.services.swaylock = {};

  xdg.portal = {
    enable = true;

    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ]; 

    configPackages = with pkgs; [ 
      xdg-desktop-portal-gtk 
      xdg-desktop-portal-wlr 
    ];
  };
  programs.hyprland.enable = true;


  hardware = {
    # Disable pulseaudio explicitly
    pulseaudio.enable = false;

    bluetooth.enable = true;

    cpu.intel.updateMicrocode = true;

    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    wget
    killall
    file
    patchelf
    steam-fhsenv-without-steam.run
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # Auto upgrade
  system.autoUpgrade = {
    enable = false;
    channel = "https://nixos.org/channels/nixos-unstable";
    dates = "04:00";
  };

  nix = {
    optimise.automatic = true;
    settings.experimental-features = [ "nix-command" "flakes" ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };
  };

  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball 
      "https://github.com/nix-community/NUR/archive/master.tar.gz") {
        inherit pkgs;
      };
  };

  # build-vm conf
  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 4096; #Mb
      cores = 3;         
    };

    virtualisation.qemu.options = [
      "-device virtio-vga-gl"
      "-display sdl,gl=on,show-cursor=off"
      "-audio pa,model=hda"
    ];

    environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
    };
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}

