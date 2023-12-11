if vim.loader then
    vim.loader.enable()
end

local core = {
    'core/bootstrap',
    'core/options',
    'core/lazy',
    'core/plugins',
    'core/autocmd',
    'core/mappings'
}

local lang = {
    'lang/lsp',
    'lang/lint',
    'lang/fmt',
    'lang/snippet',
}

local ui = {
    'ui/dashboard',
    'ui/theme',
    'ui/tree',
    'ui/statusline',
    'ui/commandbar',
}

local helper = {
    'helper/copilot'
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
