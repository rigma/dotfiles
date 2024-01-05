return {
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatic installation of LSPs to stdpath for neovim
    { 'williamboman/mason.nvim', config = true },
    'williamboman/mason-lspconfig.nvim',

    -- Status update
    { 'j-hui/fidget.nvim',       opts = {} },

    -- Additional Lua config for *awesome* stuff! (I've been told to install it 🤷)
    'folke/neodev.nvim',
  },
  config = function()
    local _augroups = {}
    local autoformatting_enabled = true

    local get_augroup = function(client)
      if not _augroups[client.id] then
        _augroups[client.id] = vim.api.nvim_create_augroup('autoformatting-lsp-format-' .. client.name,
          { clear = true })
      end

      return _augroups[client.id]
    end

    local on_attach = function(_, bufnr)
      local nmap = function(keys, func, desc)
        if desc then
          desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
      end

      nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
      nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

      local telescope = require('telescope.builtin')
      nmap('gd', telescope.lsp_definitions, '[G]oto [D]efinition')
      nmap('gr', telescope.lsp_references, '[G]oto [R]eferences')
      nmap('gI', telescope.lsp_implementations, '[G]oto [I]mplementation')
      nmap('<leader>D', telescope.lsp_type_definitions, 'Type [D]efinition')
      nmap('<leader>ds', telescope.lsp_document_symbols, '[D]ocument [S]ymbols')
      nmap('<leader>ws', telescope.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

      nmap('K', vim.lsp.buf.hover, 'Hover documentation')
      nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature documentation')

      nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
      nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace - [A]dd folder')
      nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace - [R]emove folder')
      nmap('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, '[W]orkspace - [L]ist folders')

      vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
      end, { desc = 'Format current buffer with active LSP' })
    end

    -- Document existing key chains
    require('which-key').register {
      ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
      ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
      ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
      ['<leader>h'] = { name = 'Git [H]unk', _ = 'which_key_ignore' },
      ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
      ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
      ['<leader>t'] = { name = '[T]oggle', _ = 'which_key_ignore' },
      ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
    }
    require('which-key').register({
      ['<leader>'] = { name = 'VISUAL <leader>' },
      ['<leader>h'] = { 'Git [H]unk' },
    }, { mode = 'v' })

    -- We need to setup mason before integrate it with lspconfig
    require('mason').setup()
    require('mason-lspconfig').setup()

    -- Automatically installed LSP
    local servers = {
      bashls = {},
      clangd = {},
      cssls = {},
      html = { filetypes = { 'html' } },
      gopls = {},
      jsonls = {},
      ltex = {},
      lua_ls = {
        Lua = {
          diagnostics = { disable = { 'missing-fields' } },
          telemetry = { enable = false },
          workspace = { checkThirdParty = false },
        },
      },
      marksman = {},
      pyright = {
        pyright = {
          disableOrganizeImports = true,
        },
      },
      rust_analyzer = {},
      taplo = {},
      terraformls = {},
      tsserver = {},
      yamlls = {},
    }

    -- Setup neovim Lua configuration
    require('neodev').setup()

    -- Broadcast completions capabilities from nvim-cmp to LSP servers
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

    -- Ensure default servers are installed and setup
    local mason_lspconfig = require 'mason-lspconfig'

    mason_lspconfig.setup {
      ensure_installed = vim.tbl_keys(servers),
    }
    mason_lspconfig.setup_handlers {
      function(server_name)
        require('lspconfig')[server_name].setup {
          capabilities = capabilities,
          filetypes = (servers[server_name] or {}).filetypes,
          on_attach = on_attach,
          settings = servers[server_name],
        }
      end,
      ['pyright'] = function()
        require('lspconfig')['pyright'].setup {
          capabilities = capabilities,
          filetypes = (servers['pyright'] or {}).filetypes,
          on_attach = function(_, bufnr)
            on_attach(_, bufnr)

            local dap_python = require('dap-python')
            vim.keymap.set('n', '<leader>Pdm', dap_python.test_method,
              { buffer = bufnr, desc = '[P]ython: [D]ebug test [m]ethod' })
            vim.keymap.set('n', '<leader>Pdc', dap_python.test_class,
              { buffer = bufnr, desc = '[P]ython: [D]ebug test [c]lass' })
            vim.keymap.set('n', '<leader>Pds', dap_python.debug_selection,
              { buffer = bufnr, desc = '[P]ython: [D]ebug [s]election' })
          end,
          settings = servers['pyright'],
        }
      end
    }

    vim.api.nvim_create_user_command('AutoformatToggle', function()
      autoformatting_enabled = not autoformatting_enabled
      if autoformatting_enabled then
        print('Autoformatting: On')
      else
        print('Autoformatting: Off')
      end
    end, {})
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('autoformatting-lsp-attach', { clear = true }),
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client.server_capabilities.documentFormattingProvider or client.name == 'tsserver' then
          return
        end

        vim.api.nvim_create_autocmd('BufWritePre', {
          group = get_augroup(client),
          buffer = args.buf,
          callback = function()
            if not autoformatting_enabled then
              return
            end

            vim.lsp.buf.format {
              async = false,
              filter = function(c)
                return c.id == client.id
              end,
            }
          end
        })
      end,
    })
  end,
}

-- vim: ts=2 sts=2 sw=2 et
