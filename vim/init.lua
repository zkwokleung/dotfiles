if vim.loader then
    vim.loader.enable()
end

-- Load my configs
for _, config in ipairs {
    'custom/bootstrap',
    'custom/options',
    'custom/lazy',
    'custom/plugins',
    'custom/autocmd',
    'custom/mappings'
} do
    require(config)
end
