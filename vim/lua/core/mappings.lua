local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Delete without yanking
map("n", "<Leader>d", '"_d', opts)

-- Move lines up and down
map("n", "<A-j>", ":m .+1<CR>==", opts)
map("n", "<A-k>", ":m .-2<CR>==", opts)
map("i", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
map("i", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)
map("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
map("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)

-- Copy lines up
map("n", "<A-J>", ":copy .<CR>==", opts)
map("n", "<A-K>", ":copy .-1<CR>==", opts)
map("i", "<A-J>", "<Esc>:copy .-1<CR>==gi", opts)
map("i", "<A-K>", "<Esc>:copy .<CR>==gi", opts)
map("v", "<A-J>", ":copy '>-1<CR>gv=gv", opts)
map("v", "<A-K>", ":copy '<<CR>gv=gv", opts)

-- Create new line
map("i", "<C-j>", "<Esc>o", opts)
map("i", "<C-k>", "<Esc>O", opts)

-- Navigation
map("i", "<C-h>", "<Esc>^i", opts)
map("i", "<C-l>", "<Esc>$a", opts)

-- Escaping
map("n", "<Leader><Space>", ":nohl<CR>", opts)

-- Delete word
map("i", "<C-BS>", "<C-w>", opts)

-- ALE fix
map("n", "<Leader>?", ":ALEFixSuggest<CR>", opts)

-- barbar tabline
-- Move to previous/next
-- map("n", "<Leader>,", ":BufferPrevious<CR>", opts)
-- map("n", "<Leader>.", ":BufferNext<CR>", opts)
-- Re-order to previous/next
map("n", "<Leader><", ":BufferMovePrevious<CR>", opts)
map("n", "<Leader>>", " :BufferMoveNext<CR>", opts)
-- Goto buffer in position...
map("n", "<Leader>1", ":BufferGoto 1<CR>", opts)
map("n", "<Leader>2", ":BufferGoto 2<CR>", opts)
map("n", "<Leader>3", ":BufferGoto 3<CR>", opts)
map("n", "<Leader>4", ":BufferGoto 4<CR>", opts)
map("n", "<Leader>5", ":BufferGoto 5<CR>", opts)
map("n", "<Leader>6", ":BufferGoto 6<CR>", opts)
map("n", "<Leader>7", ":BufferGoto 7<CR>", opts)
map("n", "<Leader>8", ":BufferGoto 8<CR>", opts)
map("n", "<Leader>9", ":BufferGoto 9<CR>", opts)
map("n", "<Leader>0", ":BufferLast<CR>", opts)
-- Close buffer
map("n", "<Leader>c", ":BufferClose<CR>", opts)
-- Wipeout buffer
--                 :BufferWipeout<CR>
-- Close commands
--                 :BufferCloseAllButCurrent<CR>
--                 :BufferCloseBuffersLeft<CR>
--                 :BufferCloseBuffersRight<CR>
-- Magic buffer-picking mode
map("n", "<C-p>", ":BufferPick<CR>", opts)
-- Sort automatically by...
map("n", "<Space>bb", ":BufferOrderByBufferNumber<CR>", opts)
map("n", "<Space>bd", ":BufferOrderByDirectory<CR>", opts)
map("n", "<Space>bl", ":BufferOrderByLanguage<CR>", opts)

-- Other:
-- :BarbarEnable - enables barbar (enabled by default)
-- :BarbarDisable - very bad command, should never be used

-- Toggle Neotree
map({ "n", "v", "i" }, "<C-b>", "<cmd>Neotree toggle<CR>", opts)
map({ "n", "v" }, "<F3>", "<cmd>AutoFormat<CR>", opts)

-- FZF
map({ "n", "v", "i" }, "<C-p>", "<cmd>FZF<CR>", opts)

-- Rename
map({"n", "v", "i"}, "<F2>", function() vim.lsp.buf.rename() end, opts)
