{ pkgs, ... }:
{
  imports = [ ./zsh.nix ];

  home.shellAliases = {
    ":q" = "exit";

    v = "$EDITOR";
    s = "sudo ";
    sv = "sudoedit";

    lt = "tree";

    znix-shell = "nix-shell --run zsh";
    pkg-repl = "nix repl --file '<nixpkgs/nixos>'";
    rebuild-switch = "sudo nixos-rebuild switch";

    tmp = "cd $(mktemp -d)";
    inhibit = "gnome-session-inhibit --inhibit idle";
    open = "xdg-open";

    tb = "nc termbin.com 9999";
  };

}
