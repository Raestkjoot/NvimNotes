local MIN_COLUMNS = 180

return {
   "akinsho/toggleterm.nvim",
   version = "*",
   event = "VeryLazy",
   opts = {
      direction = "vertical",
      size = 60,
      start_in_insert = false,
      on_open = function(term)
      vim.keymap.set("t", "<Esc>", [[<C-\><C-n><Cmd>lua require("config.harpoon_panel").focus_editor()<CR>]], {
         buffer = term.bufnr,
         desc = "Leave terminal",
      })

         local panel = require("config.harpoon_panel")
         panel.open(term.window)

         vim.api.nvim_create_autocmd("WinClosed", {
            pattern = tostring(term.window),
            once = true,
            callback = function()
               vim.schedule(panel.close)
            end,
         })
      end,
      on_close = function()
         require("config.harpoon_panel").close()
      end,
   },
   config = function(_, opts)
      require("toggleterm").setup(opts)

      local was_wide = nil

      local function sync_terminal()
         local wide = vim.o.columns >= MIN_COLUMNS
         if wide == was_wide then
            return -- only react when crossing the threshold
         end
         was_wide = wide

         local term = require("toggleterm.terminal").get(1)
         local is_open = term ~= nil and term:is_open()

         if wide and not is_open then
            local prev = vim.api.nvim_get_current_win()
            vim.cmd("ToggleTerm")
            if vim.api.nvim_win_is_valid(prev) then
               vim.api.nvim_set_current_win(prev)
            end
         elseif not wide and is_open then
            term:close()
         end
      end

      vim.api.nvim_create_autocmd("VimResized", {
         group = vim.api.nvim_create_augroup("ToggletermAutoResize", { clear = true }),
         callback = sync_terminal,
      })

      sync_terminal() -- apply on startup
   end, 
}
