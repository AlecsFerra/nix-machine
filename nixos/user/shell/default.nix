{ pkgs, ... }:
{
  imports = [ ./zsh.nix ];

  home.shellAliases = {
    ":q" = "exit";

    v = "$EDITOR";
    s = "sudo ";
    sv = "sudoedit";

    rm = "rm -r";
    cp = "cp -r";

    wifi = "nmcli dev wifi show-password";

    lt = "tree";

    znix-shell = "nix-shell --run zsh";
    pkg-repl = "nix repl --file '<nixpkgs/nixos>'";
    rebuild-switch = "sudo nixos-rebuild switch";

    tmp = "cd $(mktemp -d)";
    open = "xdg-open";

    tb = "nc termbin.com 9999";
  };

}
