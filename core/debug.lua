local wezterm = require 'wezterm'

local M = {}

M.enabled = false
M.log_file = nil

function M.enable(log_file_path)
  M.enabled = true
  M.log_file = log_file_path or (wezterm.home_dir .. '/.wezzy-bar-debug.log')
  
  -- Clear previous log
  local file = io.open(M.log_file, 'w')
  if file then
    file:write('=== Wezzy-bar Debug Log ===\n')
    file:write('Started at: ' .. os.date('%Y-%m-%d %H:%M:%S') .. '\n\n')
    file:close()
  end
  
  M.log('DEBUG', 'Debug logging enabled')
end

function M.log(level, message, data)
  if not M.enabled then return end
  
  local timestamp = os.date('%H:%M:%S')
  local log_entry = string.format('[%s] %s: %s', timestamp, level, message)
  
  if data then
    log_entry = log_entry .. '\n  Data: ' .. M.serialize(data)
  end
  
  log_entry = log_entry .. '\n'
  
  -- Write to file
  if M.log_file then
    local file = io.open(M.log_file, 'a')
    if file then
      file:write(log_entry)
      file:close()
    end
  end
  
  -- Also print to stderr in development
  io.stderr:write(log_entry)
end

function M.info(message, data)
  M.log('INFO', message, data)
end

function M.warn(message, data)
  M.log('WARN', message, data)
end

function M.error(message, data)
  M.log('ERROR', message, data)
end

function M.debug(message, data)
  M.log('DEBUG', message, data)
end

function M.serialize(obj, depth)
  depth = depth or 0
  if depth > 3 then return '...' end
  
  if type(obj) == 'table' then
    local result = '{'
    local first = true
    for k, v in pairs(obj) do
      if not first then result = result .. ', ' end
      result = result .. tostring(k) .. '=' .. M.serialize(v, depth + 1)
      first = false
    end
    return result .. '}'
  else
    return tostring(obj)
  end
end

function M.dump_context(context)
  M.debug('Context dump', {
    tab_count = #(context.tabs or {}),
    current_tab = context.tab and context.tab.tab_index or 'none',
    max_width = context.max_width,
    hover = context.hover
  })
end

function M.time_function(name, func)
  if not M.enabled then return func() end
  
  local start_time = wezterm.time.now()
  local result = func()
  local end_time = wezterm.time.now()
  local duration = (end_time - start_time) * 1000
  
  M.debug(string.format('Function "%s" took %.2fms', name, duration))
  
  return result
end

return M