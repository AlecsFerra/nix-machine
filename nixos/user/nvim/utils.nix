{ pkgs, ... }:
let
  telescopeBuiltin = call: 
    "<cmd>lua require('telescope.builtin').${call}<cr>";
in
{
  home.packages = with pkgs; [
    # Telescope dependencies
    ripgrep
    fd
  ];
  
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      vim-sleuth
    ];

    plugins.comment-nvim.enable = true;
    plugins.which-key.enable = true;
    
    plugins.treesitter = {
      enable = true;
      indent = true;
      
      nixvimInjections = true;

      incrementalSelection.enable = true;
      incrementalSelection.keymaps = {
        initSelection = "<c-space>";
        nodeIncremental = "<c-space>";
        scopeIncremental = "<c-s>";
        nodeDecremental = "<M-space>";
      };
    };

    plugins.telescope = {
      enable = true;
      extensions.fzf-native.enable = true;

      defaults.mappings.i = {
        "<C-u" = false;
        "<C-d>" = false;
      };
    };

    # Keybindings for telescope
    maps.normal = {
      "<leader>?" = {
        action = telescopeBuiltin "oldfile()";
        desc = "[?] Find recently opened files";
      };
      "<leader><space>" = {
        action = telescopeBuiltin "buffers()";
        desc = "[ ] Find existing buffers";
      };
      "<leader>/" = {
        action = telescopeBuiltin 
          ("current_bffer_fuzzy_find(require('telescope.themes')"
          + ".get_dropdown { winblend = 10, previewer = false, })");
        desc = "[/] Fuzzily search in current buffer";
      };
      "<leader>gf" = {
        action = telescopeBuiltin "git_files()";
        desc = "Search [G]it [F]iles";
      };
      "<leader>sf" = {
        action = telescopeBuiltin "find_files()";
        desc = "[S]earch [F]iles";
      };
      "<leader>sh" = {
        action = telescopeBuiltin "help_tags()";
        desc = "[S]earch [H]elp";
      };
      "<leader>sw" = {
        action = telescopeBuiltin "grep_string()";
        desc = "[S]earch current [W]ord";
      };
      "<leader>sg" = {
        action = telescopeBuiltin "grep_string()";
        desc = "[S]earch by [G]rep";
      };
      "<leader>sd" = {
        action = telescopeBuiltin "diagnostics()";
        desc = "[S]earch [D]iagnostics";
      };
    };
  };
}
