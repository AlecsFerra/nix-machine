-- Download the lazy package manager if not present
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- Git integration
  'tpope/vim-fugitive',
  'tpope/vim-sleuth',
  'lewis6991/gitsigns.nvim',

  -- General util
  { 'numToStr/Comment.nvim', opts = {} },
  { 'folke/which-key.nvim', opts = {} },
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
  },

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  -- LSP
  'anott03/nvim-lspinstall',
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- LSP auto install
      { 
	'williamboman/mason.nvim', 
        config = true,
    	build = ':MasonUpdate',
      },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

      -- Additional lua configuration
      'folke/neodev.nvim',
    },
  },

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- Snippets
      'rafamadriz/friendly-snippets',
    },
  },

  -- Colorschemes and visual
  'navarasu/onedark.nvim',
  'lukas-reineke/indent-blankline.nvim',
  'nvim-lualine/lualine.nvim',
})
