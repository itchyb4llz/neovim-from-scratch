-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Reload files changed outside nvim (agents writing in other herdr panes).
-- `autoread` only acts when something prods nvim, and LazyVim's own checktime
-- autocmd fires on FocusGained/TermClose/TermLeave — none of which happen in a
-- pane that just sits there displaying a file. A timer prods it unconditionally.
local uv = vim.uv or vim.loop
local checktime = uv.new_timer()
if checktime then
  checktime:start(1000, 1000, function()
    vim.schedule(function()
      -- checktime is refused while the cmdline or a prompt is up.
      local mode = vim.fn.mode()
      if mode == "c" or mode == "r" or mode == "!" or vim.fn.getcmdwintype() ~= "" then
        return
      end
      vim.cmd("silent! checktime")
    end)
  end)
  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
      checktime:stop()
      checktime:close()
    end,
  })
end

-- Say so when a reload happens, so a change you didn't cause is never silent.
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  callback = function(ev)
    local name = ev.file or vim.api.nvim_buf_get_name(ev.buf)
    vim.notify("reloaded " .. vim.fn.fnamemodify(name, ":~:."), vim.log.levels.INFO)
  end,
})
