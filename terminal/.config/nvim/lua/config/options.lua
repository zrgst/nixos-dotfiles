local opt = vim.opt

-- Grunnleggende koding-instillinger
opt.relativenumber = true -- Relative linjenummer
opt.number = true -- Vanlige linjenummer
opt.shiftwidth = 4 -- Tab-størrelse 4
opt.expandtab = true -- Bruk mellomrom i stedet for tab
opt.tabstop = 4
opt.mouse = "a" -- Tillat mus (nyttig på laptop)

-- Dette trengs for at farger skal vises riktig
opt.termguicolors = true
