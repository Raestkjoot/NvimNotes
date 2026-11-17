vim.keymap.set({ "n", "v" }, "J", "}", { desc = "Jump to previous empty line" })
vim.keymap.set({ "n", "v" }, "K", "{", { desc = "Jump to next empty line" })

vim.keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
