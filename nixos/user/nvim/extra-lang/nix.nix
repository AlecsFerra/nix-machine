{ pkgs, ... }:
{
  programs.nixvim = {
    # Highlight inline code in nix files
    plugins.hmts.enable = true;

    # plugins.lsp.servers.nixd.enable = true;
  };
}
