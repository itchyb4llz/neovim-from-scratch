-- Watcher pane: the whole of every file the agents are changing.
-- Launched by ~/.local/bin/herdr-watch. nvim's cwd is the repo root.
local M = { follow = true, last_mtime = 0 }

local function mtime(path)
  local st = (vim.uv or vim.loop).fs_stat(path)
  return st and st.mtime and st.mtime.sec or 0
end

local function changed_files()
  local out = vim.fn.systemlist({ "git", "status", "--porcelain=v1", "--untracked-files=all" })
  if vim.v.shell_error ~= 0 then
    return {}
  end
  local files = {}
  for _, line in ipairs(out) do
    -- "XY path", or "XY orig -> path" for a rename: the path we want is last.
    local path = line:sub(4)
    path = path:match("^.*%s%->%s(.*)$") or path
    path = path:gsub('^"(.*)"$', "%1")
    if vim.fn.filereadable(path) == 1 then
      table.insert(files, vim.fn.fnamemodify(path, ":p"))
    end
  end
  return files
end

function M.sync()
  local newest, newest_mtime = nil, -1
  for _, file in ipairs(changed_files()) do
    if vim.fn.bufexists(file) == 0 then
      vim.cmd.badd(vim.fn.fnameescape(file))
    end
    local mt = mtime(file)
    if mt > newest_mtime then
      newest, newest_mtime = file, mt
    end
  end
  vim.cmd("silent! checktime")
  -- Jump to the file only when it was written since the last sync, so the view
  -- doesn't yank itself away while you're reading something else.
  if M.follow and newest and newest_mtime > M.last_mtime then
    M.last_mtime = newest_mtime
    if vim.api.nvim_buf_get_name(0) ~= newest and not vim.bo.modified then
      vim.cmd.edit(vim.fn.fnameescape(newest))
    end
  end
end

function M.start(opts)
  M.follow = (opts or {}).follow ~= false
  M.sync()
  local timer = (vim.uv or vim.loop).new_timer()
  timer:start(1500, 1500, function()
    vim.schedule(M.sync)
  end)
  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
      timer:stop()
      timer:close()
    end,
  })
  vim.keymap.set("n", "<F5>", M.sync, { desc = "watch: resync changed files" })
  vim.keymap.set("n", "<F6>", function()
    M.follow = not M.follow
    vim.notify("watch: follow " .. (M.follow and "on" or "off"))
  end, { desc = "watch: toggle follow" })
end

return M
