return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  keys = {
    { "<C-p>",      function() require("telescope.builtin").find_files() end, desc = "Find files" },
    { "<C-S-t>",    function() require("telescope.builtin").live_grep() end,  desc = "Grep" },
    { "<leader>fb", function() require("telescope.builtin").buffers() end,    desc = "Buffers" },
  },
  config = function()
    require("telescope").load_extension("fzf")
  end,
}
