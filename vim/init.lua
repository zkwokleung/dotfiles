if vim.loader then
	vim.loader.enable()
end

local core = {
	"core/bootstrap",
	"core/options",
	"core/lazy",
	"core/plugins",
	"core/autocmd",
	"core/mappings",
}

local lang = {
	"lang/lsp",
	"lang/lint",
	"lang/fmt",
	"lang/snippet",
	"lang/comments",
}

local ui = {
	"ui/commandbar",
	"ui/comments",
	"ui/dashboard",
	"ui/indent",
	"ui/statusline",
	"ui/theme",
	"ui/tree",
}

local helper = {
	"helper/copilot",
}

-- Load my configs

for _, v in ipairs(core) do
	require(v)
end

for _, v in ipairs(lang) do
	require(v)
end

for _, v in ipairs(ui) do
	require(v)
end

for _, v in ipairs(helper) do
	require(v)
end
