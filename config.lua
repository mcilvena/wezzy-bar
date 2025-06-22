local wezterm = require("wezterm")
local M = {}

local default_config = {
  position = "bottom", -- 'top' or 'bottom'
  zones = {
    left = {},
    right = { "clock" },
  },
  components = {
    clock = {
      format = "%H:%M",
      update_interval = 10000,
    },
  },
  theme = {
    tab_bar_background = nil, -- nil = use theme base color, or set custom color like '#000000'
  },
  wezterm_config_overrides = {
    show_tabs_in_tab_bar = true,
    show_new_tab_button_in_tab_bar = false,
    use_fancy_tab_bar = false,
  },
}

local current_config = {}

function M.setup(user_config)
  current_config = M.merge_config(default_config, user_config or {})
  return current_config
end

function M.get()
  return current_config
end

function M.get_component_config(component_name)
  return current_config.components[component_name] or {}
end

function M.get_zones()
  return current_config.zones or default_config.zones
end

function M.get_wezterm_overrides()
  return current_config.wezterm_config_overrides
    or default_config.wezterm_config_overrides
end

function M.apply_wezterm_overrides(wezterm_config)
  local overrides = M.get_wezterm_overrides()
  for key, value in pairs(overrides) do
    wezterm_config[key] = value
  end

  if current_config.position == "top" then
    wezterm_config.tab_bar_at_bottom = false
  else
    wezterm_config.tab_bar_at_bottom = true
  end

  -- Always enable tab bar with clickable tabs
  wezterm_config.enable_tab_bar = true
  wezterm_config.show_tabs_in_tab_bar = true

  -- Set status bar background color if configured
  if current_config.theme and current_config.theme.tab_bar_background then
    wezterm_config.colors = wezterm_config.colors or {}
    wezterm_config.colors.tab_bar = wezterm_config.colors.tab_bar or {}
    wezterm_config.colors.tab_bar.background =
      current_config.theme.tab_bar_background
  end

  return wezterm_config
end

function M.merge_config(default, user)
  local result = {}

  for key, value in pairs(default) do
    if type(value) == "table" and type(user[key]) == "table" then
      result[key] = M.merge_config(value, user[key])
    else
      result[key] = user[key] ~= nil and user[key] or value
    end
  end

  for key, value in pairs(user) do
    if result[key] == nil then
      result[key] = value
    end
  end

  return result
end

return M
