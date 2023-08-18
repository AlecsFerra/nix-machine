-- Set up leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.mouse = 'a'
vim.o.clipboard = 'unnamedplus'

vim.o.breakindent = true

vim.o.undofile = true
vim.opt.swapfile = false

vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.smartcase = true

vim.wo.number = true
vim.wo.signcolumn = 'yes'

vim.o.updatetime = 250
vim.o.timeoutlen = 300

vim.o.completeopt = 'menuone,noselect'

vim.o.termguicolors = true

vim.o.tabstop = 4
vim.o.shiftwidth = 2
vim.o.expandtab = true;

require 'packagemanager'
require 'telescopesetup'
require 'languagesupport'
require 'visual'
require 'git'

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
-- Word wrapping ew
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})
