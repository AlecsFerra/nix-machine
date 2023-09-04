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
  environment.shells = [ pkgs.zsh ];

  # X11 + Gnome
  services.xserver = {
    enable = true;

    layout = "it";
    xkbOptions = "ctrl:swapcaps";

    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
  
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

    power-profiles-daemon.enable = true;
    # tlp.enable = true;

    # OpenSSH
    openssh.enable = true;

    # Fingerprint reader
    fprintd.enable = true;

    fwupd.enable = true;
  };


  hardware = {
    # Disable pulseaudio explicitly
    pulseaudio.enable = false;

    bluetooth.enable = true;

    cpu.intel.updateMicrocode = true;

    opengl.enable = true;
  };

  environment.systemPackages = with pkgs; [
    wget
    killall
    file
    patchelf
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # Auto upgrade
  system.autoUpgrade = {
    enable = false;
    channel = "https://nixos.org/channels/nixos-unstable";
    dates = "04:00";
  };

  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball 
      "https://github.com/nix-community/NUR/archive/master.tar.gz") {
        inherit pkgs;
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

