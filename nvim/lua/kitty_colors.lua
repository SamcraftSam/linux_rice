
-- ~/.config/nvim/lua/kitty_colors.lua
local function kitty_colors()
  local handle = io.popen("kitty @ get-colors")
  if not handle then return {} end
  local result = handle:read("*a")
  handle:close()

  local colors = {}
  for k, v in result:gmatch("([%w_]+)%s+(#[0-9a-fA-F]+)") do
    colors[k] = v
  end
  return colors
end

local function apply_kitty_colors()
  local c = kitty_colors()
  if vim.tbl_isempty(c) then return end

  -- Base colors
  vim.cmd("hi Normal guifg=" .. (c.foreground or "#ffffff") .. " guibg=" .. (c.background or "#000000"))
  vim.cmd("hi Cursor guibg=" .. (c.cursor or c.foreground or "#ffffff"))
  vim.cmd("hi CursorLine guibg=" .. (c.selection_background or "#333333"))
  vim.cmd("hi CursorColumn guibg=" .. (c.selection_background or "#333333"))
  vim.cmd("hi Visual guibg=" .. (c.selection_background or "#555555"))
  vim.cmd("hi LineNr guifg=" .. (c.color8 or "#888888"))
  vim.cmd("hi VertSplit guifg=" .. (c.color8 or "#444444"))

  -- Map ANSI colors 0–15
  for i = 0, 15 do
    local key = "color" .. i
    if c[key] then
      vim.cmd(string.format("hi KittyColor%d guifg=%s", i, c[key]))
      vim.cmd(string.format("hi KittyBgColor%d guibg=%s", i, c[key]))
    end
  end
end

return {
  apply = apply_kitty_colors
}
