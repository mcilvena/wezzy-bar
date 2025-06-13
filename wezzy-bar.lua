local wezterm = require 'wezterm'
local config = require 'config'
local renderer = require 'core.renderer'

local M = {}

function M.apply_to_config(wezterm_config, opts)
  opts = opts or {}
  
  -- Setup the plugin configuration
  config.setup(opts)
  
  -- Apply WezTerm configuration overrides
  config.apply_wezterm_overrides(wezterm_config)
  
  -- Register event handlers
  wezterm.on('update-status', function(window, pane)
    return renderer.update_status(window, pane)
  end)
  
  -- Add format-tab-title event for clickable tabs
  wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
    return renderer.format_tab_title(tab, tabs, panes, config, hover, max_width)
  end)
  
  return wezterm_config
end

return M