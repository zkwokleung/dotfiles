local lsps = {
    'clangd',
    'cmake',
    'cssls',
    'csharp_ls',
    'java_language_server',
    'denols',
    'bashls',
    'pyright',
    'grammarly',
    'tsserver',
}

require("mason-lspconfig").setup({
    ensure_installed = lsps,
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
for _, s in ipairs(lsps) do
    require('lspconfig')[s].setup {
        capabilities = capabilities
    }
end
