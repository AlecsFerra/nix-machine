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

    initExtra = ''
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
