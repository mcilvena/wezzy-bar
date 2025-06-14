local wezterm = require 'wezterm'

local M = {}


function M.get_colors()
  local builtin_schemes = wezterm.color.get_builtin_schemes()
  local wezterm_config = wezterm.config_builder and wezterm.config_builder() or {}
  local plugin_config = require('config').get()
  
  local scheme_name = wezterm_config.color_scheme or 'default'
  local scheme = builtin_schemes[scheme_name]
  
  if not scheme then
    scheme = builtin_schemes['default'] or {
      foreground = '#ffffff',
      background = '#000000',
      cursor_bg = '#ffffff',
      cursor_fg = '#000000',
      selection_bg = '#444444',
      selection_fg = '#ffffff',
      ansi = {
        '#000000', '#cc0000', '#4e9a06', '#c4a000',
        '#3465a4', '#75507b', '#06989a', '#d3d7cf'
      },
      brights = {
        '#555753', '#ef2929', '#8ae234', '#fce94f',
        '#729fcf', '#ad7fa8', '#34e2e2', '#eeeeec'
      }
    }
  end
  
  -- Use existing theme colors for subtle text
  -- Many themes have subtle colors in their ansi palette:
  -- - ansi[8] is typically bright black / dark gray (good for subtle text)
  -- - ansi[7] is typically light gray
  -- - Some themes define specific subtle colors in their extended palette
  local subtle_fg = scheme.ansi and scheme.ansi[8] or  -- Bright black (subtle)
                    scheme.ansi and scheme.ansi[7] or  -- Light gray
                    scheme.foreground                  -- Fallback to normal foreground
  
  return {
    foreground = scheme.foreground,
    background = scheme.background,
    cursor_bg = scheme.cursor_bg,
    cursor_fg = scheme.cursor_fg,
    selection_bg = scheme.selection_bg,
    selection_fg = scheme.selection_fg,
    ansi = scheme.ansi,
    brights = scheme.brights,
    subtle_foreground = subtle_fg,
    tab_bar = scheme.tab_bar or {
      background = plugin_config.theme and plugin_config.theme.tab_bar_background or scheme.background,
      active_tab = {
        -- Try to use Catppuccin's accent colors: lavender, blue, or selection
        bg_color = scheme.indexed and scheme.indexed[16] or -- Catppuccin lavender
                   scheme.brights and scheme.brights[5] or   -- Bright blue
                   scheme.selection_bg or                    -- Selection color
                   scheme.ansi[5],                           -- Regular blue
        fg_color = scheme.background or scheme.cursor_fg,   -- Contrasting text
      },
      inactive_tab = {
        bg_color = plugin_config.theme and plugin_config.theme.tab_bar_background or scheme.background,
        fg_color = scheme.foreground,
      },
      inactive_tab_hover = {
        bg_color = scheme.selection_bg,
        fg_color = scheme.selection_fg,
      },
    }
  }
end

function M.get_tab_colors()
  local colors = M.get_colors()
  return colors.tab_bar
end

return M