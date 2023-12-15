local dashboard = require('alpha.themes.dashboard')

dashboard.section.header.val = {
    [[░░░░░░░█▐▓▓░████▄▄▄█▀▄▓▓▓▌█░░░]],
    [[░░░░░▄█▌▀▄▓▓▄▄▄▄▀▀▀▄▓▓▓▓▓▌█░░░]],
    [[░░░▄█▀▀▄▓█▓▓▓▓▓▓▓▓▓▓▓▓▀░▓▌█░░░]],
    [[░░█▀▄▓▓▓███▓▓▓███▓▓▓▄░░▄▓▐█▌░░]],
    [[░█▌▓▓▓▀▀▓▓▓▓███▓▓▓▓▓▓▓▄▀▓▓▐█░░]],
    [[▐█▐██▐░▄▓▓▓▓▓▀▄░▀▓▓▓▓▓▓▓▓▓▌█▌░]],
    [[█▌███▓▓▓▓▓▓▓▓▐░░▄▓▓███▓▓▓▄▀▐█░]],
    [[█▐█▓▀░░▀▓▓▓▓▓▓▓▓▓██████▓▓▓▓▐█░]],
    [[▌▓▄▌▀░▀░▐▀█▄▓▓██████████▓▓▓▌█░]],
    [[▌▓▓▓▄▄▀▀▓▓▓▀▓▓▓▓▓▓▓▓█▓█▓█▓▓▌█▌]],
    [[█▐▓▓▓▓▓▓▄▄▄▓▓▓▓▓▓█▓█▓█▓█▓▓▓▐█░]],
}

dashboard.section.buttons.val = {
    dashboard.button("n", "  New file", ":ene <BAR> startinsert <CR>"),
    dashboard.button("f", "󰈞  Find file", ":FZF <CR>"),
    dashboard.button("b", "󰙅  Browse files", ":Neotree toggle <CR>"),
}

require('alpha').setup(dashboard.opts)