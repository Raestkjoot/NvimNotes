vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 3
vim.opt.shiftwidth = 0 -- when set to 0 this will automatically match tabstop
vim.opt.expandtab = false
vim.opt.breakindent = false
vim.opt.cindent = true

require("oil").setup()
vim.keymap.set("n", "-", require("oil").open_float, { desc = "Open oil in float" })
