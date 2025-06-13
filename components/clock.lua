local base = require 'components.base'
local theme = require 'core.theme'

local M = {}

function M.new()
  local component = base.new('clock')
  
  function component:render(context)
    local config = self.config
    local colors = theme.get_colors()
    local format = config.format or '%l:%M %p'
    
    local time_str = os.date(format)
    
    return {
      { Foreground = { Color = colors.foreground } },
      { Text = ' ' .. time_str .. ' ' }
    }
  end
  
  return component
end

return M