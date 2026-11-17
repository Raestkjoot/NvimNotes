return {
  "stevearc/oil.nvim",
  lazy = false, -- lets Oil handle `nvim some/dir`
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    keymaps = {
       ["<Space>"] = { "actions.select", nowait = true },
    },
  },
  keys = {
    { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
  },
}
