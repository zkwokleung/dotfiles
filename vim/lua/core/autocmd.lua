local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local cmd = vim.api.nvim_create_user_command
local namespace = vim.api.nvim_create_namespace

-- * Groups
local filetypes_group = augroup("filetypes", { clear = true })
local indent_group = augroup("indent", { clear = true })
local lsp_group = augroup("lsp", { clear = true })
local treesitter_group = augroup("treesitter", { clear = true })
local files_group = augroup("files", { clear = true })

-- File type
autocmd({ "FileType" }, {
	desc = "Set format options for all file types",
	group = filetypes_group,
	pattern = "*",
	callback = function()
		vim.cmd("set formatoptions-=cro")
		vim.cmd("set formatoptions+=tqjnl")
	end,
})

-- Format on save
autocmd({ "BufWritePre" }, {
	desc = "Format on save",
	group = files_group,
	callback = function()
		-- Call AutoFormat
		vim.cmd("Autoformat")
	end,
})

-- Indent
autocmd({ "BufReadPre", "BufNewFile" }, {
	desc = "Indent",
	group = indent_group,
	pattern = "*",
	callback = function()
		vim.cmd("IndentGuidesEnable")
		vim.cmd "TSEnable highlight"
	end,
})

-- Lint
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	group = files_group,
	callback = function()
		require("lint").try_lint()
	end,
})
