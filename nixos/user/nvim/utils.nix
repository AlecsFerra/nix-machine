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

    plugins.packer = {
      enable = true;
      plugins = [
        # Autoamtically  adjust tab size etc
        "tpope/vim-sleuth"
        # Enhanced increment/decrement
        "monaqa/dial.nvim"
        # Show f-like command hint
        "unblevable/quick-scope"
        # Automatically create directory on save
        "jghauser/mkdir.nvim"
        # Unicode latex symbols
        "arthurxavierx/vim-unicoder"
      ];
    };
    
    # Comment and decomment blocks
    # Select a block and then *gc*
    plugins.comment.enable = true;

    # Menu that shows key combinations
    plugins.which-key.enable = true;
    
    # Use :SessionSave to save the session in the current directory
    # The rest of options is under :Save
    plugins.auto-session = {
      enable = true;
      extraOptions."auto_save_enabled" = true;
    };
    
    # S<symbol> in visual mode
    plugins.surround.enable = true;
    
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
    # <leader> b c
    plugins.vim-bbye.enable = true;

    # Suggestion in :, / and ? menu
    plugins.wilder.enable = true;

    # Better syntax highlighting and selection
    # ctrl space to start selecion
    plugins.treesitter = {
      enable = true;
      nixvimInjections = true;
      folding = false;
      
      settings = {
        indent.enable = true;
        incremental_selection = {
          enable = true;
          keymaps = {
            init_selection = "<c-space>";
            node_incremental = "<c-space>";
            scope_incremental = "<c-s>";
            node_decremental = "<bs>";
          };
        };
      };
    };
    
    # Display context on the top line
    plugins.treesitter-context.enable = true;

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

      settings.defaults.mappings.i = {
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
        action.__raw = telescopeBuiltin "oldfiles";
        options.desc = "[?] Find recently opened files";
      }
      {
        mode = "n";
        key = "<leader><space>";
        action.__raw = telescopeBuiltin "buffers";
        options.desc = "[ ] Find existing buffers";
      }
      {
        mode = "n";
        key = "<leader>/";
        action.__raw = /* lua */ ''
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
        action.__raw = telescopeBuiltin "git_files";
        options.desc = "Search [G]it [F]iles";
      }
      {
        mode = "n";
        key = "<leader>sf";
        action.__raw = telescopeBuiltin "find_files";
        options.desc = "[S]earch [F]iles";
      }
      {
        mode = "n";
        key = "<leader>sh";
        action.__raw = telescopeBuiltin "help_tags";
        options.desc = "[S]earch [H]elp";
      }
      {
        mode = "n";
        key = "<leader>sw";
        action.__raw = telescopeBuiltin "grep_string";
        options.desc = "[S]earch current [W]ord";
      }
      {
        mode = "n";
        key = "<leader>sg";
        action.__raw = telescopeBuiltin "live_grep";
        options.desc = "[S]earch by [G]rep";
      }
      {
        mode = "n";
        key = "<leader>sd";
        action.__raw = telescopeBuiltin "diagnostics";
        options.desc = "[S]earch [D]iagnostics";
      }
      {
        mode = "n";
        key = "<leader>sr";
        action.__raw = telescopeBuiltin "resume";
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

    extraConfigLua = ''
      -- dial.nvim
      local dial_config = require "dial.config"
      local augend = require "dial.augend"

      dial_config.augends:register_group {
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
        },
        visual = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
          augend.constant.alias.alpha,
          augend.constant.alias.Alpha,
        },
        mygroup = {
          augend.constant.new {
            elements = { "and", "or" },
            word = true,   -- if false, "sand" is incremented into "sor", 
                           -- "doctor" into "doctand", etc.
            cyclic = true, -- "or" is incremented into "and".
          },
          augend.constant.new {
            elements = { "True", "False" },
            word = true,
            cyclic = true,
          },
          augend.constant.new {
            elements = { "public", "private" },
            word = true,
            cyclic = true,
          },
          augend.constant.new {
            elements = { "&&", "||" },
            word = false,
            cyclic = true,
          },
          augend.date.alias["%m/%d/%Y"], -- date (02/19/2022, etc.)
          augend.constant.alias.bool, -- boolean value (true <-> false)
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.semver.alias.semver
        },
      }

      local map = require "dial.map"

      -- change augends in VISUAL mode
      vim.api.nvim_set_keymap("n", "<C-a>", map.inc_normal "mygroup", { noremap = true })
      vim.api.nvim_set_keymap("n", "<C-x>", map.dec_normal "mygroup", { noremap = true })
      vim.api.nvim_set_keymap("v", "<C-a>", map.inc_normal "visual", { noremap = true })
      vim.api.nvim_set_keymap("v", "<C-x>", map.dec_normal "visual", { noremap = true })
    '';

  };
}
