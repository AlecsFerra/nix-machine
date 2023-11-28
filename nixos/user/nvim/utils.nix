{ pkgs, ... }:
let
  telescopeBuiltin = call: /* lua */ "require('telescope.builtin').${call}";
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
    
    # Comment and decomment blocks
    # Select a block and then *gc*
    plugins.comment-nvim.enable = true;

    # Menu that shows key combinations
    plugins.which-key.enable = true;
    
    # Use :SessionSave to save the session in the current directory
    # The rest of options is under :Save
    plugins.auto-session = {
      enable = true;
      extraOptions."auto_save_enabled" = true;
    };
    
    # Floating terminal
    # <leader> t
    plugins.floaterm = {
      enable = true;
      wintype = "split";
      height = 10;
      keymaps.toggle = "<leader>t";
    };
    
    # Move in undo history
    # <leader> u
    plugins.undotree.enable = true;

    # Delete buffers safely
    # <leader> q
    plugins.vim-bbye.enable = true;

    # Suggestion in :, / and ? menu
    plugins.wilder.enable = true;
    
    # Better syntax highlighting and selection
    # ctrl space to start selecion
    plugins.treesitter = {
      enable = true;
      indent = true;
      
      nixvimInjections = true;

      incrementalSelection.enable = true;
      incrementalSelection.keymaps = {
        initSelection = "<c-space>";
        nodeIncremental = "<c-space>";
        scopeIncremental = "<c-s>";
        nodeDecremental = "<bs>";
      };
    };

    # Pretty menus
    # Find files:
    #   - old         <leader> ?
    #   - buffer      <leader> <space>
    #   - git files   <leader> gf
    #   - local files <leader> sf
    # Search:
    #   - buffers     <leader> /
    #   - help        <leader> sh
    #   - grep        <leader> sg
    #   - diagnostics <leader> sd
    # Resume search with <leader> sr
    plugins.telescope = {
      enable = true;
      extensions.fzf-native.enable = true;

      defaults.mappings.i = {
        "<C-u" = false;
        "<C-d>" = false;
      };
    };

    keymaps = [
      # Bindings for undotree
      {
        mode = "n";
        key = "<leader>u";
        action = ":UndotreeToggle<CR>";
        options.desc = "[U]ndo tree";
      }
      # Keybindings for telescope
      {
        mode = "n";
        key = "<leader>?";
        lua = true;
        action = telescopeBuiltin "oldfiles";
        options.desc = "[?] Find recently opened files";
      }
      {
        mode = "n";
        key = "<leader><space>";
        lua = true;
        action = telescopeBuiltin "buffers";
        options.desc = "[ ] Find existing buffers";
      }
      {
        mode = "n";
        key = "<leader>/";
        lua = true;
        action = /* lua */ ''
            function()
              require('telescope.builtin')
                .current_buffer_fuzzy_find(require('telescope.themes')
                .get_dropdown {
                  winblend = 10,
                  previewer = false,
                })
            end
          '';
        options.desc = "[/] Fuzzily search in current buffer";
      }
      {
        mode = "n";
        key = "<leader>gf";
        lua = true;
        action = telescopeBuiltin "git_files";
        options.desc = "Search [G]it [F]iles";
      }
      {
        mode = "n";
        key = "<leader>sf";
        lua = true;
        action = telescopeBuiltin "find_files";
        options.desc = "[S]earch [F]iles";
      }
      {
        mode = "n";
        key = "<leader>sh";
        lua = true;
        action = telescopeBuiltin "help_tags";
        options.desc = "[S]earch [H]elp";
      }
      {
        mode = "n";
        key = "<leader>sw";
        lua = true;
        action = telescopeBuiltin "grep_string";
        options.desc = "[S]earch current [W]ord";
      }
      {
        mode = "n";
        key = "<leader>sg";
        lua = true;
        action = telescopeBuiltin "live_grep";
        options.desc = "[S]earch by [G]rep";
      }
      {
        mode = "n";
        key = "<leader>sd";
        lua = true;
        action = telescopeBuiltin "diagnostics";
        options.desc = "[S]earch [D]iagnostics";
      }
      {
        mode = "n";
        key = "<leader>sr";
        lua = true;
        action = telescopeBuiltin "resume";
        options.desc = "[S]earch [R]esume";
      }
      # vim-bbye
      {
        mode = "n";
        key = "<leader>bc";
        action = ":Bdelete<CR>";
        options.desc = "[B]uffer [C]lose";
      }
    ];
  };
}
