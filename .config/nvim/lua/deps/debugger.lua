local function nmap(keys, action, opts)
  vim.keymap.set('n', keys, action, opts)
end

return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    -- Supported DAP
    'leoluz/nvim-dap-go',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      automatic_setup = true,
      handlers = {},
      ensure_installed = {
        'codelldb',
        'chrome',
        'delve',
        'firefox',
        'node2',
      },
    }
    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    require('dap-go').setup {}

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_exited['dapui_config'] = dapui.close
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close

    nmap('<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
    nmap('<S-F5>', dap.terminate, { desc = 'Debug: Terminate' })
    nmap('<F7>', dapui.toggle, { desc = 'Debug: Show last session result' })
    nmap('<F10>', dap.step_over, { desc = 'Debug: Step' })
    nmap('<F11>', dap.step_into, { desc = 'Debug: Step into' })
    nmap('<S-F11>', dap.step_out, { desc = 'Debug: Step out' })
    nmap('<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle breakpoint' })
    nmap('<leader>B', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint continue: ')
    end, { desc = 'Debug: Set breakpoint' })
  end
}

-- vim: ts=2 sts=2 sw=2 et
