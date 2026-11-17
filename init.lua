vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 3
vim.opt.shiftwidth = 0 -- when set to 0 this will automatically match tabstop
vim.opt.expandtab = false
vim.opt.breakindent = false
vim.opt.cindent = true

-- Oil
require("oil").setup({ keymaps = { ["<Space>"] = "actions.select" } })

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- telescope
local builtin = require('telescope.builtin')

vim.keymap.set('n', '<C-p>', builtin.find_files, { desc = 'Find files' })
vim.keymap.set('n', '<C-S-t>', builtin.live_grep, { desc = 'Grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Buffers' })

require("telescope").load_extension("fzf")

-- Various keymaps
vim.keymap.set({ "n", "v" }, "J", "}")
vim.keymap.set({ "n", "v" }, "K", "{")

vim.keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
