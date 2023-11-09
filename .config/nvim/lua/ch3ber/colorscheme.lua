local colorscheme = "material"

-- config to colorscheme
vim.cmd "let g:material_terminal_italics = 1"
vim.cmd "let g:material_theme_style = 'ocean'"

--vim.g.tokyonight_style == "nigth"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  return
end
