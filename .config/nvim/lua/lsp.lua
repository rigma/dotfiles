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

  vim.api.nvim_buf_create_user_command(bufnr, 'format', function(_)
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
  clangd = {},
  ltex = {},
  lua_ls = {
    Lua = {
      diagnostics = { disable = { 'missing-fields' } },
      telemetry = { enable = false },
      workspace = { checkThirdParty = false },
    },
  },
  pyright = {},
  rust_analyzer = {},
  tsserver = {},
  html = { filetypes = { 'html' } },
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
  end
}

-- vim: ts=2 sts=2 sw=2 et

