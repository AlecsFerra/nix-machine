{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "AlecsFerra";
    userEmail = "alecsferra@protonmail.com";

    extraConfig = {
      init.defaultBranch = "master";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };

    delta.enable = true;
  };
}
