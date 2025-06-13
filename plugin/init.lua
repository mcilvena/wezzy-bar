-- Standard plugin entry point following WezTerm conventions
local wezterm = require 'wezterm'

-- Plugin module path resolution
local function resolve_plugin_path()
  for _, plugin in ipairs(wezterm.plugin.list()) do
    if plugin.url == 'https://github.com/mcilvena/wezzy-bar' then
      return plugin.plugin_dir
    end
  end
  return nil
end

local plugin_path = resolve_plugin_path()
if plugin_path then
  -- Load the main plugin module
  package.path = package.path .. ';' .. plugin_path .. '/?.lua'
  package.path = package.path .. ';' .. plugin_path .. '/?/init.lua'
end

return require('wezzy-bar')