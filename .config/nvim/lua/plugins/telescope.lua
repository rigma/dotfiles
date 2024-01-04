return {
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
  config = function()
    local telescope_builtin = require('telescope.builtin')

    local function nmap(keys, action, opts)
      vim.keymap.set('n', keys, action, opts)
    end

    local function find_git_root()
      local current_file = vim.api.nvim_buf_get_name(0)
      local cwd = vim.fn.getcwd()
      local current_dir

      if current_file == '' then
        current_dir = cwd
      else
        current_dir = vim.fn.fnamemodify(current_file, ':h')
      end

      local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')
          [1]
      if vim.v.shell_error ~= 0 then
        print 'Not a git repository. Searching on current working directory'
        return cwd
      end

      return git_root
    end

    local function live_grep_git_root()
      local git_root = find_git_root()
      if git_root then
        telescope_builtin.live_grep {
          search_dirs = { git_root },
        }
      end
    end

    local function telescope_live_grep_open_files()
      telescope_builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live grep on open files',
      }
    end

    require('telescope').setup {
      defaults = {
        mappings = {
          i = {
            ['<C-u>'] = false,
            ['<C-d>'] = false,
          },
        },
      },
    }

    -- Enable telescope fzf native if installed
    pcall(require('telescope').load_extension, 'fzf')

    vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

    -- Search in current buffer
    nmap('<leader>?', telescope_builtin.oldfiles, { desc = '[?] Find recently opened files' })
    nmap('<leader><space>', telescope_builtin.buffers, { desc = '[ ] Find existing buffers' })
    nmap('<leader>/', function()
      telescope_builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzy search in current buffer' })

    -- Search through a dialog
    nmap('<leader>s/', telescope_live_grep_open_files, { desc = '[S]earch [/] in open files' })
    nmap('<leader>ss', telescope_builtin.builtin, { desc = '[S]earch [s]elect Telescope' })
    nmap('<leader>gf', telescope_builtin.git_files, { desc = '[S]earch [g]it [f]iles' })
    nmap('<leader>sf', telescope_builtin.find_files, { desc = '[S]earch [f]iles' })
    nmap('<leader>sh', telescope_builtin.help_tags, { desc = '[S]earch [h]elp' })
    nmap('<leader>sw', telescope_builtin.grep_string, { desc = '[S]earch current [w]ord' })
    nmap('<leader>sg', telescope_builtin.live_grep, { desc = '[S]earch by [g]rep' })
    nmap('<leader>sG', ':LiveGrepGitRoot', { desc = '[S]earch by [g]rep on git root' })
    nmap('<leader>sd', telescope_builtin.diagnostics, { desc = '[S]earch [d]iagnostics' })
    nmap('<leader>sr', telescope_builtin.resume, { desc = '[S]earch [r]esume' })
  end
}

-- vim: ts=2 sts=2 sw=2 et
