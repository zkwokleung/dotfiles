local lsp = require('lspconfig')
local lsps = require('lang.requirements').lsps

require("mason-lspconfig").setup({
    ensure_installed = lsps,
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
for _, s in ipairs(lsps) do
    lsp[s].setup {
        capabilities = capabilities
    }
end