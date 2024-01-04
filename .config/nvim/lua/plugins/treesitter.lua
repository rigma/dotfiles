return {
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
    config = function()
      -- The setup is deferred after the first render to improve startup time when opening a file
      vim.defer_fn(function()
        require('nvim-treesitter.configs').setup {
          auto_install = false,
          ensure_installed = {
            'bash',
            'c',
            'cpp',
            'css',
            'comment',
            'dockerfile',
            'git_config',
            'git_rebase',
            'gitattributes',
            'gitcommit',
            'gitignore',
            'go',
            'gomod',
            'gosum',
            'javascript',
            'json',
            'lua',
            'make',
            'markdown',
            'mermaid',
            'nix',
            'python',
            'requirements',
            'rust',
            'sql',
            'terraform',
            'tsx',
            'typescript',
            'vim',
            'vimdoc',
            'yaml',
            'zig',
          },

          indent = { enable = true },
          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = '<c-space>',
              node_incremental = '<c-space>',
              scope_incremental = '<c-s>',
              node_decremental = '<M-space>',
            },
          },
          highlight = { enable = true },
          textobjects = {
            move = {
              enable = true,
              set_jumps = true,
              goto_next_start = {
                [']m'] = '@function.outer',
                [']]'] = '@class.outer',
              },
              goto_next_end = {
                [']M'] = '@function.outer',
                [']['] = '@class.outer',
              },
              goto_previous_end = {
                ['[m'] = '@function.outer',
                ['[['] = '@class.outer',
              },
              goto_previous_start = {
                ['[M'] = '@function.outer',
                ['[]'] = '@class.outer',
              },
            },
            select = {
              enable = true,
              lookahead = true,
              keymaps = {
                ['aa'] = '@parameter.outer',
                ['ia'] = '@parameter.inner',
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner',
              },
            },
            swap = {
              enable = true,
              swap_next = {
                ['<leader>a'] = '@parameter.inner',
              },
              swap_previous = {
                ['<leader>A'] = '@parameter.outer',
              },
            },
          },
        }
      end, 0)
    end
  },
}

-- vim: ts=2 sts=2 sw=2 et
