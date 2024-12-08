{ pkgs, ... }:
{
  home.packages = with pkgs; [
    haskellPackages.hoogle
  ];

  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      # Seach hoogle from telescope
      # <leader> hh
      telescope_hoogle
    ];

    plugins.lsp.servers.hls = {
      enable = true;
      installGhc = true;
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>hh";
        action = ":Telescope hoogle<CR>";
        options.desc = "[H]askell [H]oogle";
      }
    ];

    extraConfigLua = ''
      local telescope = require('telescope')
      telescope.load_extension('hoogle')
    '';
  };
}
