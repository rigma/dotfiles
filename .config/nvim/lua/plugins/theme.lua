return {
  'navarasu/onedark.nvim',
  priority = 1000,
  opts = { theme = 'deep' },
  config = function()
    vim.cmd.colorscheme 'onedark'
  end,
}

-- vim: ts=2 sts=2 sw=2 et
