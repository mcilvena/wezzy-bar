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
    
    -- Fallback for systems that don't support %l (WSL, some Linux distros)
    if not time_str or time_str == format or time_str:match('^%%l') then
      time_str = os.date('%I:%M %p')  -- Alternative 12-hour format with leading zero
    end
    
    -- Final fallback to 24-hour format if 12-hour format fails
    if not time_str or time_str:match('^%%[Il]') then
      time_str = os.date('%H:%M')
    end
    
    return {
      { Foreground = { Color = colors.foreground } },
      { Text = ' ' .. time_str .. ' ' }
    }
  end
  
  return component
end

return M