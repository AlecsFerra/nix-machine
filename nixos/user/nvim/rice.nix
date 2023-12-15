{ pkgs, ... }:
{
  programs.nixvim = {

    plugins.packer = {
      enable = true;
      plugins = [
        # Make scrolling nice
        "karb94/neoscroll.nvim"
        # Center tab
        "shortcuts/no-neck-pain.nvim"
      ];
    };

    colorschemes.onedark.enable = true;
    
    # Fancy menus
    plugins.noice = {
      enable = true;
      views = {
        cmdline_popup = {
          border = {
            style = "none";
          };
        };
      };
    };
    
    # Higlight colors like orange
    plugins.nvim-colorizer.enable = true;
    
    # Colorize delimiters
    plugins.rainbow-delimiters.enable = true;
    
    # Status line on the bottom
    plugins.lualine.enable = true;
    
    # Show scope guides
    plugins.indent-blankline = {
      enable = true;
      scope = {
        showEnd = false;
        showStart = false;
      };
      whitespace.removeBlanklineTrail = false;
    };

    extraConfigLua = ''
      -- Noice messages in lualine
      require("lualine").setup({
        sections = {
          lualine_x = {
            {
              require("noice").api.statusline.mode.get,
              cond = require("noice").api.statusline.mode.has,
              color = { fg = "#ff9e64" },
            }
          },
        },
      })
      -- Neoscroll
      require('neoscroll').setup {
        mappings = { 
          "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" 
        },
        hide_cursor = true,
        stop_eof = true,
        use_local_scrolloff = false,
        respect_scrolloff = false,
        cursor_scrolls_alone = true,
      };
    '';
  };
}
