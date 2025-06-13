local wezterm = require 'wezterm'
local zones = require 'core.zones'
local components = require 'components'
local config = require 'config'

local M = {}

-- Cache for avoiding unnecessary re-renders
local status_cache = {
  last_status = nil,
  last_update = 0,
  last_tab_count = 0,
  last_active_tab = nil
}

function M.update_status(window, pane)
  local plugin_config = config.get()
  local zone_config = plugin_config.zones
  
  -- Check if we can use cached status to avoid unnecessary re-renders
  local current_time = os.time()
  local mux_window = window:mux_window()
  local tabs = mux_window:tabs()
  local active_tab = window:active_tab()
  
  -- Check if clock component is enabled
  local has_clock = false
  for _, zone in pairs(zone_config) do
    for _, component_name in ipairs(zone or {}) do
      if component_name == 'clock' then
        has_clock = true
        break
      end
    end
    if has_clock then break end
  end
  
  -- Only update if significant time has passed or tab state changed
  local min_update_interval = has_clock and 30 or 5 -- 30 seconds if clock is present, 5 if not
  local tab_state_changed = (
    #tabs ~= status_cache.last_tab_count or 
    (active_tab and active_tab:tab_id() ~= status_cache.last_active_tab)
  )
  
  if not tab_state_changed and 
     status_cache.last_status and 
     (current_time - status_cache.last_update) < min_update_interval then
    -- Use cached status
    local left_status, right_status = zones.split_status_for_display(status_cache.last_status, {
      window = window,
      pane = pane,
      tabs = tabs,
      active_tab = active_tab,
      config = plugin_config
    })
    window:set_left_status(left_status)
    window:set_right_status(right_status)
    return
  end
  
  -- Filter out tabs from status bar zones since they're handled by format-tab-title
  local filtered_left = {}
  local filtered_right = {}
  
  for _, component_name in ipairs(zone_config.left or {}) do
    if component_name ~= 'tabs' then
      table.insert(filtered_left, component_name)
    end
  end
  
  for _, component_name in ipairs(zone_config.right or {}) do
    if component_name ~= 'tabs' then
      table.insert(filtered_right, component_name)
    end
  end
  
  local left_components = M.create_zone_components(filtered_left)
  local right_components = M.create_zone_components(filtered_right)
  
  local context = {
    window = window,
    pane = pane,
    tabs = tabs,
    active_tab = active_tab,
    config = plugin_config
  }
  
  local status_elements = zones.render_status_zones(left_components, right_components, context)
  
  -- Update cache
  status_cache.last_status = status_elements
  status_cache.last_update = current_time
  status_cache.last_tab_count = #tabs
  status_cache.last_active_tab = active_tab and active_tab:tab_id() or nil
  
  local left_status, right_status = zones.split_status_for_display(status_elements, context)
  window:set_left_status(left_status)
  window:set_right_status(right_status)
end

function M.create_zone_components(component_names)
  local zone_components = {}
  local plugin_config = config.get()
  
  for _, component_name in ipairs(component_names or {}) do
    local component_config = plugin_config.components[component_name] or {}
    local component = components.create_component(component_name, component_config)
    table.insert(zone_components, component)
  end
  
  return zone_components
end

-- Cache for tab component check
local tab_component_enabled = nil

function M.format_tab_title(tab, tabs, panes, wezterm_config, hover, max_width)
  -- Cache the tabs component check since it doesn't change often
  if tab_component_enabled == nil then
    local plugin_config = config.get()
    tab_component_enabled = false
    for _, zone in pairs(plugin_config.zones or {}) do
      for _, component_name in ipairs(zone or {}) do
        if component_name == 'tabs' then
          tab_component_enabled = true
          break
        end
      end
      if tab_component_enabled then break end
    end
  end
  
  if not tab_component_enabled then
    return nil -- Let WezTerm use default formatting
  end
  
  local theme = require 'core.theme'
  local colors = theme.get_tab_colors()
  
  -- Format the tab with just the tab number
  local bg_color = tab.is_active and colors.active_tab.bg_color or colors.inactive_tab.bg_color
  local fg_color = tab.is_active and colors.active_tab.fg_color or colors.inactive_tab.fg_color
  
  return {
    { Background = { Color = bg_color } },
    { Foreground = { Color = fg_color } },
    { Text = '  ' .. tostring(tab.tab_index + 1) .. '  ' },
  }
end

-- Function to reset cache when configuration changes
function M.reset_cache()
  status_cache.last_status = nil
  status_cache.last_update = 0
  status_cache.last_tab_count = 0
  status_cache.last_active_tab = nil
  tab_component_enabled = nil
end

return M