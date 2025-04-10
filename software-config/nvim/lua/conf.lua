-- Leader
vim.g.mapleader = ' '

-- Terminal
vim.opt.termguicolors = true

-- Indenting
vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes'

-- Searching
vim.opt.hlsearch = true
vim.opt.smartcase = true
vim.keymap.set('n', '<leader>nh', '<cmd>nohlsearch<CR>')

-- Completion
vim.opt.wildmenu = true
vim.opt.completeopt = { 'menuone', 'popup', 'noinsert', 'noselect' }

-- Buffer-related
vim.keymap.set('n', '<leader>lb', '<cmd>bnext<CR>')
vim.keymap.set('n', '<leader>hb', '<cmd>bprevious<CR>')
vim.keymap.set('n', '<leader>db', '<cmd>bdelete<CR>')

-- Miscellaneous
vim.opt.cursorline = true  -- Highlight current line
vim.opt.title = true       -- Change window title
vim.opt.exrc = true        -- Read per-project settings
vim.opt.wrap = false       -- Do not wrap line
vim.opt.splitright = true  -- Split at right
vim.opt.showmode = false   -- No mode hint in the bottom
