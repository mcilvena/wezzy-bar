local M = {}

function M.render_status_zones(left_components, right_components, context)
  local left_content = M.render_zone_components(left_components, context)
  local right_content = M.render_zone_components(right_components, context)
  
  local window_width = M.get_window_width(context)
  local left_width = M.calculate_content_width(left_content)
  local right_width = M.calculate_content_width(right_content)
  
  local padding = math.max(0, window_width - left_width - right_width)
  
  local result = {}
  
  for _, item in ipairs(left_content) do
    table.insert(result, item)
  end
  
  if padding > 0 then
    table.insert(result, { Text = string.rep(' ', padding) })
  end
  
  for _, item in ipairs(right_content) do
    table.insert(result, item)
  end
  
  return result
end

function M.split_status_for_display(status_elements, context)
  local left_status = ''
  local right_status = ''
  local is_right_section = false
  
  for _, element in ipairs(status_elements) do
    if element.Text and string.match(element.Text, '^%s+$') and string.len(element.Text) > 2 then
      is_right_section = true
    elseif element.Text then
      if is_right_section then
        right_status = right_status .. element.Text
      else
        left_status = left_status .. element.Text
      end
    elseif element.Foreground or element.Background then
      local attr_str = M.format_attribute(element)
      if is_right_section then
        right_status = right_status .. attr_str
      else
        left_status = left_status .. attr_str
      end
    end
  end
  
  return left_status, right_status
end

function M.format_attribute(element)
  if element.Foreground and element.Foreground.Color then
    local color = element.Foreground.Color
    if color:sub(1,1) == '#' then
      color = color:sub(2)
    end
    local r, g, b = string.match(color, '(%x%x)(%x%x)(%x%x)')
    if r and g and b then
      return string.format('\27[38;2;%d;%d;%dm', 
        tonumber(r, 16), tonumber(g, 16), tonumber(b, 16))
    end
  elseif element.Background and element.Background.Color then
    local color = element.Background.Color
    if color:sub(1,1) == '#' then
      color = color:sub(2)
    end
    local r, g, b = string.match(color, '(%x%x)(%x%x)(%x%x)')
    if r and g and b then
      return string.format('\27[48;2;%d;%d;%dm',
        tonumber(r, 16), tonumber(g, 16), tonumber(b, 16))
    end
  end
  return ''
end

function M.get_window_width(context)
  if context.window then
    local window_dims = context.window:get_dimensions()
    if window_dims and window_dims.pixel_width then
      return math.floor(window_dims.pixel_width / 8)
    end
  end
  return 120
end

function M.render_zone_components(components, context)
  local result = {}
  
  for _, component in ipairs(components or {}) do
    local component_content = component:render(context)
    
    if type(component_content) == 'string' then
      table.insert(result, { Text = component_content })
    elseif type(component_content) == 'table' then
      for _, item in ipairs(component_content) do
        table.insert(result, item)
      end
    end
  end
  
  return result
end

function M.calculate_content_width(content)
  local width = 0
  
  for _, item in ipairs(content) do
    if item.Text then
      width = width + string.len(item.Text)
    end
  end
  
  return width
end

return M