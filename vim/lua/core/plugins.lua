-- #region local
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

local linters_by_ft = {
  bash = { 'fish' },
  c = { 'clangtidy' },
  cpp = { 'clangtidy' },
  css = { 'stylelint' },
  html = { 'tidy' },
  java = { 'spotless' },
  javascript = { 'eslint' },
  javascriptreact = { 'eslint' },
  json = { 'jsonlint' },
  lua = { 'luacheck' },
  make = { 'checkmake' },
  markdown = { 'markdownlint' },
  python = { 'flake8' },
  rust = { 'rustfmt', 'clippy' },
  sass = { 'stylelint' },
  scss = { 'stylelint' },
  sh = { 'shellcheck' },
  typescript = { 'eslint' },
  typescriptreact = { 'eslint' },
  vim = { 'vint' },
  yaml = { 'yamllint' },
  zsh = { 'fish' },
}
-- #endregion

-- #region Mason
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = lsps,
})
-- #endregion

-- #region Lint
require('lint').linters_by_ft = linters_by_ft

-- Sort the table in ascending order
local sorted_linters_by_ft = {}
for k, v in pairs(linters_by_ft) do
  table.insert(sorted_linters_by_ft, { k, v })
end
table.sort(sorted_linters_by_ft, function(a, b) return a[1] < b[1] end)

-- Reconstruct the table
linters_by_ft = {}
for _, v in ipairs(sorted_linters_by_ft) do
  linters_by_ft[v[1]] = v[2]
end
-- #endregion

-- #region UI
vim.cmd [[colorscheme tokyonight]]

require('neo-tree').setup {
  disable_netrw = true,
  hijack_netrw = true,
  auto_close = true,
  open_on_setup = false,
  open_on_tab = false,
  hijack_cursor = true,
  update_cwd = true,
  lsp_diagnostics = true,
  update_focused_file = {
    enable = true,
    update_cwd = true,
    ignore_list = {}
  },
  system_open = {
    cmd = nil,
    args = {}
  },
  view = {
    width = 30,
    side = 'left',
    auto_resize = false,
    mappings = {
      custom_only = false,
      list = {}
    }
  },
  filesystem = {
    filtered_items = {
      visible = true,
      hide_dotfiles = false,
      hide_gitignore = true
    },
  }
}
-- #endregion

-- #region Completion
-- Wilder
local wilder = require('wilder')
wilder.setup({
  modes = {
    '/', '?', '[', ':'
  },
  separator = '|',
  next_key = 'ctrl-n',
  previous_key = 'ctrl-N'
})

wilder.set_option('renderer', wilder.popupmenu_renderer({
  highlighter = wilder.basic_highlighter(),
  left = { ' ', wilder.popupmenu_devicons() },
  right = { ' ', wilder.popupmenu_scrollbar() },
}))
-- #endregion

-- #region Snippets
-- nvim-cmp
local cmp = require('cmp')

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For luasnip users.
  }, {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})
-- #endregion

-- #region LSP
-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
for _, s in ipairs(lsps) do
  require('lspconfig')[s].setup {
    capabilities = capabilities
  }
end
-- #endregion

-- #region Formatter
-- Utilities for creating configurations
local util = require "formatter.util"

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup {
  -- Enable or disable logging
  logging = true,
  -- Set the log level
  log_level = vim.log.levels.WARN,
  -- All formatter configurations are opt-in
  filetype = {
    -- Formatter configurations for filetype "lua" go here
    -- and will be executed in order
    lua = {
      -- "formatter.filetypes.lua" defines default configurations for the
      -- "lua" filetype
      require("formatter.filetypes.lua").stylua,

      -- You can also define your own configuration
      function()
        -- Supports conditional formatting
        if util.get_current_buffer_file_name() == "special.lua" then
          return nil
        end

        -- Full specification of configurations is down below and in Vim help
        -- files
        return {
          exe = "stylua",
          args = {
            "--search-parent-directories",
            "--stdin-filepath",
            util.escape_path(util.get_current_buffer_file_path()),
            "--",
            "-",
          },
          stdin = true,
        }
      end
    },

    c = {
      require("formatter.filetypes.c").clangformat,
    },

    cpp = {
      require("formatter.filetypes.cpp").clangformat,
    },

    cs = {
      require("formatter.filetypes.cs").dotnetformat,
    },

    css = {
      require("formatter.filetypes.css").prettier,
    },

    html = {
      require("formatter.filetypes.html").prettier,
    },

    java = {
      require("formatter.filetypes.java").google_java_format,
    },

    javascript = {
      require("formatter.filetypes.javascript").prettier,
    },

    javascriptreact = {
      require("formatter.filetypes.javascript").prettier,
    },

    json = {
      require("formatter.filetypes.json").prettier,
    },

    kotlin = {
      require("formatter.filetypes.kotlin").ktlint,
    },

    latex = {
      require("formatter.filetypes.latex").latexindent,
    },

    markdown = {
      require("formatter.filetypes.markdown").prettier,
    },

    python = {
      require("formatter.filetypes.python").autoflake,
    },

    sh = {
      require("formatter.filetypes.sh").shfmt,
    },

    typescript = {
      require("formatter.filetypes.typescript").prettier,
    },

    typescriptreact = {
      require("formatter.filetypes.typescript").prettier,
    },

    yaml = {
      require("formatter.filetypes.yaml").prettier,
    },

    zsh = {
      require("formatter.filetypes.zsh").shfmt,
    },

    -- Use the special "*" filetype for defining formatter configurations on
    -- any filetype
    ["*"] = {
      -- "formatter.filetypes.any" defines default configurations for any
      -- filetype
      require("formatter.filetypes.any").remove_trailing_whitespace
    }
  }
}
-- #endregion
