require('lazy').setup({
  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- To detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- LSP stuff
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatic installation of LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Status update
      { 'j-hui/fidget.nvim', opts = {} },

      -- Additional Lua config for *awesome* stuff! (I've been told to install it 🤷)
      'folke/neodev.nvim',
    },
  },

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'rafamadriz/friendly-snippets',
    },
  },

  -- Which key is doing what? I'm lost in my config…
  { 'folke/which-key.nvim', opts = {} },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '-' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map({ 'n', 'v' }, ']c', function()
        if vim.wo.diff then
          return ']c'
        end

        vim.schedule(function()
          gs.next_hunk()
        end)

        return '<Ignore>'
      end, { expr = true, desc = 'Jump to next hunk' })
      map({ 'n', 'v' }, '[c', function()
        if vim.wo.diff then
          return '[c'
        end

        vim.schedule(function()
          gs.prev_hunk()
        end)

        return '<Ignore>'
      end, { expr = true, desc = 'Jump to previous hunk' })

      -- Actions
      map('n', '<leader>hs', gs.stage_hunk, { desc = 'git stage hunk' })
      map('n', '<leader>hr', gs.reset_hunk, { desc = 'git reset hunk' })
      map('n', '<leader>hS', gs.stage_buffer, { desc = 'git stage buffer' })
      map('n', '<leader>hR', gs.reset_buffer, { desc = 'git reset buffer' })
      map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'Undo stage git hunk' })
      map('n', '<leader>hp', gs.preview_hunk, { desc = 'Preview git hunk' })
      map('n', '<leader>hb', function()
        gs.blame_line { full = false }
      end, { desc = 'Blame line' })
      map('n', '<leader>hd', gs.diffthis, { desc = 'git diff against index' })
      map('n', '<leader>hD', function()
        gs.diffthis '~'
      end, { desc = 'git diff againt last commit' })

      map('v', '<leader>hs', function()
        gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = 'Stage git hunk' })
      map('v', '<leader>hr', function()
        gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = 'Reset git hunk' })

      -- Toggles
      map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'Toggle git blame line' })
      map('n', '<leader>td', gs.toggle_deleted, { desc = 'Toggle git deleted show' })

      -- Text objects
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Select git hunk' })
    end,
  },

  -- An awesome theme!
  {
    'navarasu/onedark.nvim',
    priority = 1000,
    opts = { theme = 'deep' },
    config = function()
      vim.cmd.colorscheme 'onedark'
    end,
  },

  -- Status line
  {
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        icons_enabled = true,
        theme = 'onedark',
        component_separators = '|',
        section_separators = '',
      },
    },
  },

  -- Visual guidelines for blank lines
  { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {} },

  -- Code edition/navigation utilities
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
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },
  { 'numToStr/Comment.nvim', opts = {} },

  -- Atomic plugins dependencies
  { import = 'deps' },
})

-- vim: ts=2 sts=2 sw=2 et

