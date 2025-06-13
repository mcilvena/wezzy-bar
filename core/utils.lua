local M = {}

function M.truncate_string(str, max_length, suffix)
  suffix = suffix or '...'
  
  if string.len(str) <= max_length then
    return str
  end
  
  return string.sub(str, 1, max_length - string.len(suffix)) .. suffix
end

function M.pad_string(str, total_length, char, align)
  char = char or ' '
  align = align or 'left'
  
  local current_length = string.len(str)
  
  if current_length >= total_length then
    return str
  end
  
  local padding_needed = total_length - current_length
  
  if align == 'center' then
    local left_padding = math.floor(padding_needed / 2)
    local right_padding = padding_needed - left_padding
    return string.rep(char, left_padding) .. str .. string.rep(char, right_padding)
  elseif align == 'right' then
    return string.rep(char, padding_needed) .. str
  else
    return str .. string.rep(char, padding_needed)
  end
end

function M.escape_string(str)
  return str:gsub('([%^%$%(%)%%%.%[%]%*%+%-%?])', '%%%1')
end

return M