-- #region Mason
require("mason").setup()
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
