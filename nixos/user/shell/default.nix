{ pkgs, ... }:
{
  imports = [ ./zsh.nix ];

  home.shellAliases = {
    tb = "nc termbin.com 9999";
    ":q" = "exit";
    v = "$EDITOR";
    s = "sudo ";
    sv = "sudoedit";
    znix-shell = "nix-shell --run zsh";
    pkg-repl = "nix repl --file '<nixpkgs/nixos>'";
    rebuild-switch = "sudo nixos-rebuild switch";
    tmp = "cd $(mktemp -d)";
    inhibit = "gnome-session-inhibit --inhibit idle";
    open = "xdg-open";
    patch = 
      "patchelf --set-interpreter \"$(cat $NIX_CC/nix-support/dynamic-linker)\"";
  };

}
