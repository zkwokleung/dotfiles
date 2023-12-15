local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local cmd = vim.api.nvim_create_user_command
local namespace = vim.api.nvim_create_namespace

-- File type
autocmd({ "FileType" }, {
	desc = "Set format options for all file types",
	group = augroup("filetype", { clear = true }),
	pattern = "*",
	callback = function()
		vim.cmd("set formatoptions-=cro")
		vim.cmd("set formatoptions+=tqjnl")
	end,
})

-- Format on save
autocmd({ "BufWritePre" }, {
	desc = "Format on save",
	group = augroup("files", { clear = true }),
	callback = function()
		-- Call AutoFormat
		vim.cmd("Autoformat")
	end,
})
