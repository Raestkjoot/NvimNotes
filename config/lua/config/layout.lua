local THRESHOLD = 150 -- columns
local WIDE, NARROW = 35, 20 -- WIDE should match window.width in neo-tree opts
local shrunk = false

local function tree_win()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "neo-tree" then
      return win
    end
  end
end

local function adjust()
  local win = tree_win()
  if not win then
    shrunk = false -- tree closed, so start fresh when it's reopened
    return
  end

  local narrow = vim.o.columns < THRESHOLD
  if narrow and not shrunk then
    vim.api.nvim_win_set_width(win, NARROW)
    shrunk = true
  elseif not narrow and shrunk then
    vim.api.nvim_win_set_width(win, WIDE)
    shrunk = false
  end
end

vim.api.nvim_create_autocmd("VimResized", {
  group = vim.api.nvim_create_augroup("ResponsiveLayout", { clear = true }),
  callback = adjust,
})

return {
  -- called whenever neo-tree opens: it opens at full width, so reset and re-check
  on_open = function()
    shrunk = false
    adjust()
  end,
}
