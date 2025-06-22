local wezterm = require("wezterm")
local base = require("components.base")
local theme = require("core.theme")

local M = {}

function M.new()
  local component = base.new("tabs")

  function component:render(context)
    local config = self.config
    local colors = theme.get_tab_colors()
    local result = {}

    for i, tab in ipairs(context.tabs) do
      local is_active = context.active_tab
        and tab:tab_id() == context.active_tab:tab_id()
      local bg_color = is_active and colors.active_tab.bg_color
        or colors.inactive_tab.bg_color
      local fg_color = is_active and colors.active_tab.fg_color
        or colors.inactive_tab.fg_color
      local tab_id = tab:tab_id()

      table.insert(result, { Background = { Color = bg_color } })
      table.insert(result, { Foreground = { Color = fg_color } })

      table.insert(result, { Text = "  " .. tostring(i) .. "  " })

      if i < #context.tabs then
        table.insert(result, { Text = " " })
      end
    end

    return result
  end

  return component
end

return M
