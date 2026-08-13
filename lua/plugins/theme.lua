local omarchy_theme_spec = vim.fn.expand("~/.config/omarchy/current/theme/neovim.lua")

if vim.fn.filereadable(omarchy_theme_spec) == 0 then
  return {}
end

local ok, spec = pcall(dofile, omarchy_theme_spec)
if not ok then
  vim.notify("omarchy: failed to load theme spec: " .. tostring(spec), vim.log.levels.WARN)
  return {}
end

return spec
