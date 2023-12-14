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
}

require('alpha').setup(dashboard.opts)
