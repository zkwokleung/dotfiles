if vim.loader then
    vim.loader.enable()
end

-- Load my configs
for _, config in ipairs {
    'core/bootstrap',
    'core/options',
    'core/lazy',
    'core/plugins',
    'core/autocmd',
    'core/mappings'
} do
    require(config)
end

-- Load UI configs
for _, config in ipairs {
    'ui/dashboard',
    'ui/theme',
    'ui/tree',
} do
    require(config)
end
