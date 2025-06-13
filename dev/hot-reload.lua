-- Hot reload utility for wezzy-bar development
-- This module provides automatic reloading of plugin components

local wezterm = require 'wezterm'

local M = {}

local file_watchers = {}
local reload_callbacks = {}

function M.watch_files(file_patterns, callback)
  for _, pattern in ipairs(file_patterns) do
    local watcher = wezterm.window.create_tab {}
    -- Note: WezTerm doesn't have built-in file watching
    -- This is a conceptual implementation
    table.insert(file_watchers, {
      pattern = pattern,
      callback = callback
    })
  end
end

function M.setup_hot_reload()
  -- Watch core plugin files for changes
  local plugin_files = {
    'init.lua',
    'config.lua',
    'core/*.lua',
    'components/*.lua'
  }
  
  -- In a real implementation, you'd use external file watching
  -- For now, provide manual reload functionality
  wezterm.on('reload-plugin', function()
    -- Clear the Lua module cache
    for module_name, _ in pairs(package.loaded) do
      if module_name:match('^wezzy%-bar') or 
         module_name:match('^components') or
         module_name:match('^core') or
         module_name:match('^config') then
        package.loaded[module_name] = nil
      end
    end
    
    -- Force reload configuration
    wezterm.reload_configuration()
  end)
end

function M.add_reload_keybind(config)
  config.keys = config.keys or {}
  
  table.insert(config.keys, {
    key = 'F5',
    mods = '',
    action = wezterm.action.EmitEvent 'reload-plugin',
  })
  
  return config
end

return M