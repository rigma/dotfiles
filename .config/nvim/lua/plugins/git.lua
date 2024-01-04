return {
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
}

-- vim: ts=2 sts=2 sw=2 et
