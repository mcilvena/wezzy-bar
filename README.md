# wezzy-bar

A minimal, performant tab bar plugin for WezTerm focused on keyboard users. Features clickable tab numbers, customizable clock, and seamless theme integration.

## Features

- **Always clickable tabs** - Full mouse interaction for tab switching using WezTerm's native tab bar
- **Minimal tab design** - Just numbers (`1`, `2`, `3`) for maximum screen space efficiency
- **Theme integration** - Automatically adapts to your color scheme (Catppuccin, etc.)
- **Configurable status bar** - Clean clock display without visual clutter
- **High performance** - Smart caching and optimized rendering
- **Keyboard-first** - Designed for users who prefer keyboard shortcuts
- **Clean UI** - No visual controls for opening/closing tabs

## Quick Setup

Add to your `~/.wezterm.lua`:

```lua
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Your existing theme
config.color_scheme = 'Catppuccin Mocha'

-- Add wezzy-bar
local wezzy_bar = wezterm.plugin.require 'https://github.com/mcilvena/wezzy-bar'

wezzy_bar.apply_to_config(config, {
  position = 'bottom',
  zones = {
    left = {},              -- Empty for clean look
    right = { 'clock' }     -- Clock on right
  }
})

return config
```

### Restart WezTerm

That's it! You should now see minimal clickable tab numbers and a clock on the right.

## Configuration

### Full Configuration Example

```lua
wezzy_bar.apply_to_config(config, {
  position = 'bottom',  -- 'top' or 'bottom'
  zones = {
    left = {},              -- No status bar components on left
    right = { 'clock' }     -- Show clock on right
  },
  components = {
    clock = {
      format = '%l:%M %p',        -- 9:01 PM (default)
      -- format = '%H:%M',        -- 21:01 (24-hour)
      -- format = '%H:%M:%S',     -- 21:01:30 (with seconds)
      update_interval = 60000,    -- Update every minute
    }
  },
  theme = {
    tab_bar_background = nil,     -- Use theme default
    -- tab_bar_background = '#1e1e2e',  -- Custom color
  }
})
```

### Position Options

- **`bottom`** (default) - Status bar at bottom of terminal
- **`top`** - Status bar at top of terminal

### Zone Configuration

Configure what appears in each zone:

```lua
zones = {
  left = {},              -- Available: [] (empty for clean look)
  right = { 'clock' }     -- Available: ['clock'] or [] (empty)
}
```

**Note:** Tabs are always displayed in WezTerm's native tab bar and are always clickable. They cannot be placed in status bar zones.

### Component Configuration

#### Clock Component

```lua
components = {
  clock = {
    format = '%l:%M %p',          -- Time format
    update_interval = 60000,      -- Update frequency in milliseconds
  }
}
```

**Clock format options:**
- `%l:%M %p` - 9:01 PM (12-hour, no leading zero)
- `%I:%M %p` - 09:01 PM (12-hour, with leading zero)
- `%H:%M` - 21:01 (24-hour)
- `%H:%M:%S` - 21:01:30 (24-hour with seconds)
- `%a %l:%M %p` - Mon 9:01 PM (with day)

### Theme Integration

wezzy-bar automatically adapts to your color scheme:

- **Active tabs** use your theme's accent color
- **Inactive tabs** blend with the background  
- **Clock** inherits theme colors
- **Background** uses theme base color or custom override

```lua
theme = {
  tab_bar_background = nil,        -- Use theme default (recommended)
  -- tab_bar_background = '#1e1e2e', -- Custom background color
}
```

## Tab Behavior

- **Always clickable** - Tabs appear in WezTerm's native tab bar
- **Custom styling** - Numbered tabs (1, 2, 3, etc.) with theme colors
- **No new tab button** - Clean UI without visual controls
- **Keyboard shortcuts work** - Ctrl+1, Ctrl+2, etc. still function
- **Mouse wheel support** - Scroll to switch tabs (if enabled in WezTerm)

## Platform Support

Works on all platforms supported by WezTerm:
- Windows 11
- WSL/Windows
- macOS
- Linux
- Arch Linux

The plugin installation is handled automatically by WezTerm.

## Troubleshooting

### Plugin Not Loading
If the plugin fails to load:
```lua
-- Debug: List loaded plugins
for _, plugin in ipairs(wezterm.plugin.list()) do
  wezterm.log_info('Plugin: ' .. plugin.url)
end
```

You can also try updating plugins:
```lua
wezterm.plugin.update_all()
```

### Tabs Not Clickable
This should not happen with the current version as tabs are always in WezTerm's native tab bar. If experiencing issues:
- Restart WezTerm completely
- Check that no other tab bar plugins are conflicting
- Verify WezTerm version is recent

### Colors Look Wrong
- Confirm your `color_scheme` is set before applying wezzy-bar
- Try `tab_bar_background = nil` to use theme defaults
- Check if your theme supports the required color fields

### Performance Issues
The plugin includes smart caching, but if you experience slowness:
- Increase `clock.update_interval` (default: 60000ms)
- Check for conflicting plugins

## Development

### Project Structure
```
wezzy-bar/
├── wezzy-bar.lua          # Main plugin entry point
├── init.lua               # Legacy entry point  
├── config.lua             # Configuration management
├── core/
│   ├── renderer.lua       # Tab and status rendering
│   ├── theme.lua          # Color scheme integration
│   ├── zones.lua          # Layout management
│   └── utils.lua          # Utility functions
├── components/
│   ├── clock.lua          # Clock component
│   └── base.lua           # Base component class
└── dev/                   # Development tools
    ├── wezterm-dev.lua    # Development config
    └── start-dev-wsl.sh   # Development launcher
```

### Contributing

1. Fork the repository
2. Create a feature branch
3. Test your changes with the development setup
4. Submit a pull request

### Development Setup

```bash
# Use the development launcher
./dev/start-dev-wsl.sh

# Or configure manually in wezterm.lua
local wezzy_bar = require '/path/to/wezzy-bar'
```

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Credits

Built for the WezTerm community. Inspired by the need for a minimal, keyboard-focused tab bar that stays out of your way while providing essential functionality.

---

**Perfect for:** Terminal power users, Vim/Neovim users, developers who live in the terminal, anyone who wants clean aesthetics without sacrificing functionality.