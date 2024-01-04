-- Higlight on search
vim.o.hlsearch = true

-- Line numbers by default
vim.wo.number = true

-- Mouse mode
vim.o.mouse = 'a'

-- Synchronise clipboard between OS and Neovim
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive during search unless \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Signcolumn
vim.wo.signcolumn = 'yes'

-- Decrease update time for reason…
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Termgui color support
vim.o.termguicolors = true

-- vim: ts=2 sts=2 sw=2 et
