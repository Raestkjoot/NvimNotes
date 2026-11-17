return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    opts = {
      event_handlers = {
         {
            event = "neo_tree_window_after_open",
            handler = function()
               vim.schedule(function()
                  require("config.layout").on_open()
               end)
            end,
         },
      },
      close_if_last_window = true,
      filesystem = {
        hijack_netrw_behavior = "disabled", -- let Oil own directory buffers
      },
      commands = {
        reveal_in_files = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          if node.type == "file" then
            vim.fn.jobstart({ "dolphin", "--select", path }, { detach = true })
          else
            vim.ui.open(path)
          end
        end,
      },
      window = {
        width = 25,
        mappings = {
          ["O"] = "reveal_in_files",
          ["<space>"] = { "open", nowait = true },
          ["l"] = "open",
          ["h"] = "close_node",
          ["."] = "none", -- disable set_root because it's close to -
          ["-"] = function(state)
             local node = state.tree:get_node()
             local parent_id = node:get_parent_id()
             if parent_id then
                require("neo-tree.ui.renderer").focus_node(state, parent_id)
             end
          end,
        },
      },
    },
    lazy = false,
    init = function()
      vim.api.nvim_create_autocmd("VimEnter", {
        once = true,
        callback = function()
          local arg = vim.fn.argv(0)
          if arg == "" then return end
          local is_dir = vim.startswith(arg, "oil://") or vim.fn.isdirectory(arg) == 1
          if not is_dir then return end
          vim.schedule(function()
            vim.cmd("Neotree show left")
          end)
        end,
      })
    end,
  }
}
