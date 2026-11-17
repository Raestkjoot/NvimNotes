return {
  "stevearc/oil.nvim",
  lazy = false, -- lets Oil handle `nvim some/dir`
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    keymaps = {
       ["<Space>"] = { "actions.select", nowait = true },
    },
    skip_confirm_for_simple_edits = true,
    delete_to_trash = true,
  },
  keys = {
    { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
  },
}
