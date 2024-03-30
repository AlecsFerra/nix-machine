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
  
  home.packages = [
    # Extract a file easily
    (pkgs.writeShellScriptBin "ex"
      # bash
      ''
        if [ -f "$1" ] ; then
          case $1 in
            *.tar.bz2)   tar xjf $1                               ;;
            *.tar.gz)    tar xzf $1                               ;;
            *.bz2)       bunzip2 $1                               ;;
            *.rar)       unrar x $1                               ;;
            *.gz)        gunzip $1                                ;;
            *.tar)       tar xf $1                                ;;
            *.tbz2)      tar xjf $1                               ;;
            *.tgz)       tar xzf $1                               ;;
            *.zip)       unzip "$1"                               ;;
            *.Z)         uncompress $1                            ;;
            *.7z)        7z x $1                                  ;;
            *.deb)       ar x $1                                  ;;
            *.tar.xz)    tar xf $1                                ;;
            *.tar.zst)   unzstd $1                                ;;
            *)           echo "'$1' cannot be extracted via ex()" ;;
          esac
        else
          echo "'$1' is not a valid file"
        fi
      '')
  ];

}
