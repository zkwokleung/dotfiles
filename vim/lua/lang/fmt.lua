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
            require("formatter.filetypes.python").black,
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
