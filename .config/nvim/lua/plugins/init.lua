return {
  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- To detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- Which key is doing what? I'm lost in my config…
  { 'folke/which-key.nvim',                opts = {} },

  -- Visual guidelines for blank lines
  { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {} },

  -- Comment support
  { 'numToStr/Comment.nvim',               opts = {} },
}

-- vim: ts=2 sts=2 sw=2 et
