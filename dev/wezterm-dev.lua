local wezterm = require 'wezterm'

-- Development configuration for testing wezzy-bar
-- This creates a separate WezTerm instance for development

-- Add the current directory to Lua path for development
package.path = package.path .. ';' .. wezterm.home_dir .. '/code/wezzy-bar/?.lua'

local wezzy_bar = require 'wezzy-bar'
local debug = require 'core.debug'
local hot_reload = require 'dev.hot-reload'

-- Enable debug logging in development
debug.enable()
hot_reload.setup_hot_reload()

-- Development-specific configuration
local config = wezterm.config_builder()

-- Apply the plugin with configuration
wezzy_bar.apply_to_config(config, {
  position = 'bottom',
  zones = {
    left = { 'tabs' },
    right = { 'clock' }
  },
  components = {
    tabs = {},
    clock = {
      format = '%I:%M %p',  -- Remove seconds for better performance
      update_interval = 30000,  -- Update every 30 seconds
    }
  },
  theme = {
    tab_bar_background = '#000000', -- Demonstrate custom black background
  }
})

-- Visual distinction from main instance
config.color_scheme = 'Tokyo Night'
config.window_background_opacity = 0.95

-- Smaller window for testing
config.initial_cols = 100
config.initial_rows = 30

-- Different font size for testing
config.font_size = 12

-- Enable debug key bindings
config.keys = {
  -- Reload configuration quickly
  {
    key = 'r',
    mods = 'CMD|SHIFT',
    action = wezterm.action.ReloadConfiguration,
  },
  -- Hot reload plugin (F5)
  {
    key = 'F5',
    mods = '',
    action = wezterm.action.EmitEvent 'reload-plugin',
  },
  -- Create new tab for testing
  {
    key = 't',
    mods = 'CMD',
    action = wezterm.action.SpawnTab 'CurrentPaneDomain',
  },
  -- Close tab for testing
  {
    key = 'w',
    mods = 'CMD',
    action = wezterm.action.CloseCurrentTab { confirm = false },
  },
}

-- Set a different title to identify dev instance
config.window_frame = {
  active_titlebar_bg = '#ff6b35',
  font_size = 11,
}

-- Add visual indicator this is development
wezterm.on('update-right-status', function(window, pane)
  window:set_right_status(wezterm.format {
    { Attribute = { Intensity = 'Bold' } },
    { Foreground = { Color = '#ff6b35' } },
    { Text = ' [DEV] ' },
  })
end)

return config