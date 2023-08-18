local colorscheme = 'onedark'

vim.cmd.colorscheme(colorscheme)

require('lualine').setup({
  options = {
    icons_enabled = false,
    theme = auto,
  }
})

require('indent_blankline').setup({
  show_trailing_blankline_indent = false,
})


