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

      column.ui = "auto";
      branch.sort = "-committerdate";

      gpg.format = "ssh";
      commit.gpgsign = true;
      user.signingkey = "~/.ssh/id_rsa.pub";
    };

    delta.enable = true;
  };
}
