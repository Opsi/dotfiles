vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local keymap = vim.keymap -- for conciseness

-- clear highlights on search when pressing <Esc> in normal mode
keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlights' })

-- increment/decrement numbers
keymap.set('n', '<leader>+', '<C-a>', { desc = 'Increment number' }) -- increment
keymap.set('n', '<leader>-', '<C-x>', { desc = 'Decrement number' }) -- decrement

-- move lines in normal mode
vim.keymap.set('n', '<C-Down>', ':m .+1<CR>==', { desc = 'Move line down' })
vim.keymap.set('n', '<C-Up>', ':m .-2<CR>==', { desc = 'Move line up' })
-- move lines in visual mode
vim.keymap.set('v', '<C-Down>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', '<C-Up>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- window management
-- use CTRL+<hjkl> to switch between windows
keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- tab management
keymap.set('n', '<leader>to', '<cmd>tabnew<CR>', { desc = '[o]pen new tab' }) -- open new tab
keymap.set('n', '<leader>tx', '<cmd>tabclose<CR>', { desc = 'E[x]it current tab' }) -- close current tab
keymap.set('n', '<leader>tn', '<cmd>tabn<CR>', { desc = 'Go to [n]ext tab' }) --  go to next tab
keymap.set('n', '<leader>tp', '<cmd>tabp<CR>', { desc = 'Go to [p]revious tab' }) --  go to previous tab

-- TODO: delete if it is 2026-06-18 and you have never used this
-- diagnostic keymaps
keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- make the umlauts useful
keymap.set('n', 'ö', ':')

-- disable "jumpy" default behaviour when pressing Shift-Down/Up
-- now we just jump 5 lines
vim.keymap.set({ 'n', 'v', 'i' }, '<S-Down>', '5j')
vim.keymap.set({ 'n', 'v', 'i' }, '<S-Up>', '5k')
