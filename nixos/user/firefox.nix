{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    profiles.alecs = {
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      ];
    };
  };
}
