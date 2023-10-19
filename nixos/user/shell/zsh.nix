{ pkgs, ... }:
{
  home.packages = with pkgs; [
    git # For zplug
    fzy # For zsh-fsy
  ];

  programs.zsh = {
    enable = true;

    history.extended = true;

    historySubstringSearch.enable = true;

    shellAliases = {
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

    initExtra = ''
      function ex() {
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
            *.zip)       unzip $1                                 ;;
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
      }

      TRAPWINCH() {
        zle && { zle reset-prompt; zle -R }
      }

      bindkey -v
      autoload -z edit-command-line
      zle -N edit-command-line
      bindkey '^r' edit-command-line
      bindkey '^f' fzy-history-widget
    '';

    zplug = {
      enable = true;
      plugins = [
	{ name = "MichaelAquilina/zsh-you-should-use"; }
	{ name = "aperezdc/zsh-fzy"; }
	{ name = "zsh-users/zsh-completions"; }
	{ name = "zsh-users/zsh-autosuggestions"; }
	{ name = "zsh-users/zsh-syntax-highlighting"; }
      ];
    };

    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = [
        "git"
      ];
    };
  };
}
