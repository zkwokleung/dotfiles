local M = {}

M.lsps = {
    'clangd',
    'cmake',
    'cssls',
    'bashls',
    'pyright',
    'eslint',
    'ts_ls',
    'tailwindcss',
}

M.linters = {
    'ast-grep',
    'stylelint',
    'eslint_d',
    'markdownlint',
    'flake8',
    'shellcheck',
    'vint',
    'yamllint',
}

M.linters_by_ft = {
    bash = { 'shellcheck' },
    c = { 'ast-grep' },
    cpp = { 'ast-grep' },
    css = { 'stylelint' },
    html = { 'ast-grep' },
    java = { 'ast-grep' },
    javascript = { 'eslint_d' },
    javascriptreact = { 'eslint_d' },
    json = { 'jsonlint' },
    kotlin = { 'ast-grep' },
    lua = { 'ast-grep' },
    markdown = { 'markdownlint' },
    python = { 'flake8' },
    sass = { 'stylelint' },
    scss = { 'stylelint' },
    sh = { 'shellcheck' },
    typescript = { 'eslint_d' },
    typescriptreact = { 'eslint_d' },
    vim = { 'vint' },
    yaml = { 'yamllint' },
}

M.fmts = {
    'clang-format',
    'prettier',
    'google-java-format',
    'ktlint',
    'latexindent',
    'black',
    'shfmt',
    'stylua',
}

M.all = {}
for _, v in ipairs(M.lsps) do
    table.insert(M.all, v)
end
for _, v in ipairs(M.linters) do
    table.insert(M.all, v)
end
for _, v in ipairs(M.fmts) do
    table.insert(M.all, v)
end

return M
