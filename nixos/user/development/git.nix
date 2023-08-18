{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "AlecsFerra";
    userEmail = "alecsferra@protonmail.com";

    extraConfig = {
      init.defaultBranch = "master";
      pull.rebase = true;
    };

    delta.enable = true;
  };
}
