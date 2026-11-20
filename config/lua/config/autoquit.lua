local SIDEBARS = { ["neo-tree"] = true, ["toggleterm"] = true }

local function is_sidebar(win)
  return SIDEBARS[vim.bo[vim.api.nvim_win_get_buf(win)].filetype] == true
end

vim.api.nvim_create_autocmd("QuitPre", {
  group = vim.api.nvim_create_augroup("AutoQuitSidebars", { clear = true }),
  callback = function()
    local cur = vim.api.nvim_get_current_win()
    if is_sidebar(cur) or vim.bo.modified then return end

    local others = {}
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if win ~= cur and vim.api.nvim_win_get_config(win).relative == "" then
        if not is_sidebar(win) then return end -- a real window remains
        table.insert(others, win)
      end
    end
    if #others == 0 then return end

    for _, win in ipairs(others) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].buftype == "terminal" then
        vim.api.nvim_buf_delete(buf, { force = true }) -- kills the shell
      elseif vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
    end
  end,
})
