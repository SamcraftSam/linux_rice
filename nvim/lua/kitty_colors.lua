
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
  vim.cmd("hi Visual guifg=" .. (c.selection_foreground or "#111111"))
  vim.cmd("hi LineNr guifg=" .. (c.color8 or "#888888"))
  vim.cmd("hi VertSplit guifg=" .. (c.color8 or "#444444"))

  vim.cmd("hi TabLine guifg=" .. c.inactive_tab_foreground .. " guibg=" .. c.inactive_tab_background)
  vim.cmd("hi TabLineSel guifg=" .. c.foreground .. " guibg=" .. c.tab_bar_background)
  vim.cmd("hi Underlined guifg=" .. c.url_color .. " gui=underline")

  vim.cmd("hi Mark1 guifg=" .. c.mark1_foreground .. " guibg=" .. c.mark1_background)
  vim.cmd("hi Mark2 guifg=" .. c.mark2_foreground .. " guibg=" .. c.mark2_background)
  vim.cmd("hi Mark3 guifg=" .. c.mark3_foreground .. " guibg=" .. c.mark3_background)
    

  vim.api.nvim_set_hl(0, "cType", { fg = (c.bell_border_color or c.foreground or "#ff5a00"), bold = true })
  vim.api.nvim_set_hl(0, "cStorageClass", { fg = (c.bell_border_color or c.foreground or "#ff5a00"), italic = true })
  vim.api.nvim_set_hl(0, "cStructure", { fg = (c.bell_border_color or c.foreground or "#ff5a00"), bold = true })
  vim.api.nvim_set_hl(0, "cTypedef", { fg = (c.bell_border_color or c.foreground or "#ff5a00"), bold = false, italic = true }) 
  vim.api.nvim_set_hl(0, "cConditional", { fg = (c.bell_border_color or c.foreground or "#ff5a00"), bold = true, italic = false })
  vim.api.nvim_set_hl(0, "cLabel", { fg = (c.color11 or c.foreground or "#ff5780"), bold = true, italic = false })
  vim.api.nvim_set_hl(0, "cStatement", { fg = (c.color6 or c.foreground or "#0abdc6"), bold = false, italic = true })
  vim.api.nvim_set_hl(0, "cInclude", { fg = (c.color89 or c.foreground or "#87005f"), bold = false, italic = true })
  vim.api.nvim_set_hl(0, "cDefine", { fg = (c.color89 or c.foreground or "#87005f"), bold = false, italic = true })
  vim.api.nvim_set_hl(0, "cPreCondit", { fg = (c.color89 or c.foreground or "#87005f"), bold = false, italic = true })
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
