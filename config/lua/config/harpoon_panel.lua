local M = {}

local PANEL_HEIGHT = 12
local ns = vim.api.nvim_create_namespace("harpoon_panel")
local buf, win, last_file, term_win, last_edit_wim
local registered = false

local function list()
   return require("harpoon"):list()
end

local function is_normal_win(w)
   if not (w and w ~= 0 and vim.api.nvim_win_is_valid(w)) then
      return false
   end
   if vim.api.nvim_win_get_config(w).relative ~= "" then
      return false
   end
   local b = vim.api.nvim_win_get_buf(w)
   return vim.bo[b].buftype == "" or vim.bo[b].filetype == "oil"
end

-- window where files should open (never the panel or terminal)
local function edit_win()
   local cur = vim.api.nvim_get_current_win()
   if is_normal_win(cur) then
      return cur
   end
   if is_normal_win(last_edit_win) then
      return last_edit_win
   end
   for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if is_normal_win(w) then
         return w
      end
   end
end

local function render()
   if not (buf and vim.api.nvim_buf_is_valid(buf)) then
      return
   end
   local items = list().items
   local lines = {}
   for i, item in ipairs(items) do
      lines[i] = string.format(" %d  %s", i, item.value)
   end
   if #lines == 0 then
      lines = { " (empty - <leader>a to add a file)" }
   end

   vim.bo[buf].modifiable = true
   vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
   vim.bo[buf].modifiable = false

   vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
   for i, item in ipairs(items) do
      if item.value == last_file then
         vim.api.nvim_buf_set_extmark(buf, ns, i - 1, 0, { end_col = #lines[i], hl_group = "Title" })
      end
   end
end

local function select_idx(idx)
   if idx < 1 or idx > #list().items then
      return
   end
   local w = edit_win()
   if w then
      vim.api.nvim_set_current_win(w)
   end
   list():select(idx)
end

local function create_buf()
   buf = vim.api.nvim_create_buf(false, true)
   vim.bo[buf].buftype = "nofile"
   vim.bo[buf].bufhidden = "hide"
   vim.bo[buf].swapfile = false
   vim.bo[buf].filetype = "harpoon-panel"
   vim.bo[buf].modifiable = false

   local function map(lhs, fn, desc)
      vim.keymap.set("n", lhs, fn, { buffer = buf, desc = desc, nowait = true })
   end

   local function open_entry()
      local idx = vim.api.nvim_win_get_cursor(0)[1]
      if idx > #list().items then
         return
      end
      local w = edit_win()
      if w then
         vim.api.nvim_set_current_win(w)
      end
      list():select(idx)
   end

   map("<CR>", function()
      select_idx(vim.api.nvim_win_get_cursor(0)[1])
   end, "Open harpoon file")

   map("dd", function()
      local idx = vim.api.nvim_win_get_cursor(0)[1]
      if idx <= #list().items then
         list():remove_at(idx)
         render()
      end
   end, "Remove harpoon file")

   map("<Esc>", "<C-w>p", "Leave panel")
end

local function setup_once()
   if registered then
      return
   end
   registered = true

   local refresh = function()
      vim.schedule(render)
   end
   require("harpoon"):extend({
      ADD = refresh,
      REMOVE = refresh,
      REORDER = refresh,
      LIST_CHANGE = refresh,
   })

   vim.api.nvim_create_autocmd("BufEnter", {
      group = vim.api.nvim_create_augroup("HarpoonPanel", { clear = true }),
      callback = function(ev)
         if vim.bo[ev.buf].buftype == "" and vim.api.nvim_buf_get_name(ev.buf) ~= "" then
            last_file = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(ev.buf), ":.")
            render()
         end
      end,
   })

   vim.api.nvim_create_autocmd("WinEnter", {
      group = vim.api.nvim_create_augroup("HarpoonPanelSkip", { clear = true }),
      callback = function()
         if not (win and vim.api.nvim_get_current_win() == win) then
            return
         end
         local prev = vim.fn.win_getid(vim.fn.winnr("#"))
         vim.schedule(function()
            if prev == term_win then
               local w = edit_win()
               if w then
                  vim.api.nvim_set_current_win(w)
               end
            elseif term_win and vim.api.nvim_win_is_valid(term_win) then
               vim.api.nvim_set_current_win(term_win)
            end
         end)
      end,
   })

   vim.api.nvim_create_autocmd("WinEnter", {
      group = vim.api.nvim_create_augroup("HarpoonPanelTrack", { clear = true }),
      callback = function()
         local w = vim.api.nvim_get_current_win()
         if is_normal_win(w) then
            last_edit_win = w
         end
      end,
   })

   for _, key in ipairs({ "<LeftMouse>", "<2-LeftMouse>" }) do
      vim.keymap.set("n", key, function()
         local pos = vim.fn.getmousepos()
         if not (win and pos.winid == win) then
            return key -- not on the panel: normal mouse behaviour
         end
         if key == "<2-LeftMouse>" then
            vim.schedule(function()
               select_idx(pos.line)
            end)
         end
         return "" -- swallow the click so focus never moves
      end, { expr = true, desc = "Harpoon panel click" })
   end
end

function M.open(tw)
   term_win = tw
   setup_once()
   if win and vim.api.nvim_win_is_valid(win) then
      return
   end
   if not (buf and vim.api.nvim_buf_is_valid(buf)) then
      create_buf()
   end

   vim.api.nvim_set_current_win(term_win)
   vim.cmd("leftabove split")
   win = vim.api.nvim_get_current_win()
   vim.api.nvim_win_set_buf(win, buf)
   vim.api.nvim_win_set_height(win, PANEL_HEIGHT)
   for opt, val in pairs({
      number = false,
      relativenumber = false,
      signcolumn = "no",
      cursorline = true,
      wrap = false,
      winfixheight = true,
   }) do
      vim.wo[win][opt] = val
   end

   vim.api.nvim_set_current_win(term_win) -- keep focus where it was
   render()
end

function M.close()
   if win and vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
   end
   win = nil
end

function M.focus_editor()
   local w = edit_win()
   if w then
      vim.api.nvim_set_current_win(w)
   end
end

return M
