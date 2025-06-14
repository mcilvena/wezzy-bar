local wezterm = require 'wezterm'
local config = require 'config'
local renderer = require 'core.renderer'

local M = {}

function M.setup(user_config)
  config.setup(user_config)
  return M
end

function M.apply(wezterm_module)
  wezterm_module = wezterm_module or wezterm
  
  wezterm_module.on('update-status', function(window, pane)
    return renderer.update_status(window, pane)
  end)
  
  -- Add format-tab-title event for clickable tabs
  wezterm_module.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
    return renderer.format_tab_title(tab, tabs, panes, config, hover, max_width)
  end)
  
  
  M.setup_key_bindings(wezterm_module)
  
  return M
end

function M.configure_wezterm(wezterm_config)
  return config.apply_wezterm_overrides(wezterm_config)
end

function M.setup_key_bindings(wezterm_module)
  local act = wezterm_module.action
  
  return {
    {
      key = '1',
      mods = 'CTRL',
      action = act.ActivateTab(0),
    },
    {
      key = '2',
      mods = 'CTRL',
      action = act.ActivateTab(1),
    },
    {
      key = '3',
      mods = 'CTRL',
      action = act.ActivateTab(2),
    },
    {
      key = '4',
      mods = 'CTRL',
      action = act.ActivateTab(3),
    },
    {
      key = '5',
      mods = 'CTRL',
      action = act.ActivateTab(4),
    },
    {
      key = '6',
      mods = 'CTRL',
      action = act.ActivateTab(5),
    },
    {
      key = '7',
      mods = 'CTRL',
      action = act.ActivateTab(6),
    },
    {
      key = '8',
      mods = 'CTRL',
      action = act.ActivateTab(7),
    },
    {
      key = '9',
      mods = 'CTRL',
      action = act.ActivateTab(8),
    },
    {
      key = 'Tab',
      mods = 'CTRL',
      action = act.ActivateTabRelative(1),
    },
    {
      key = 'Tab',
      mods = 'CTRL|SHIFT',
      action = act.ActivateTabRelative(-1),
    },
  }
end


return M