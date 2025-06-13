# wezzy-bar

A minimal, performant tab bar plugin for WezTerm focused on keyboard users. Features clickable tab numbers, customizable clock, and seamless theme integration.

![wezzy-bar demo](demo.png)

## Features

- **Minimal tab design** - Just numbers (`1`, `2`, `3`) for maximum screen space efficiency
- **Clickable tabs** - Full mouse interaction for tab switching  
- **Theme integration** - Automatically adapts to your color scheme (Catppuccin, etc.)
- **Configurable background** - Set custom colors or use theme defaults
- **Clean clock** - Customizable time format without visual clutter
- **High performance** - Smart caching and optimized rendering
- **Keyboard-first** - Designed for users who prefer keyboard shortcuts

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
    left = { 'tabs' },
    right = { 'clock' }
  }
})

return config
```

### Restart WezTerm

That's it! You should now see minimal tab numbers on the left and a clock on the right.

## Configuration

### Full Configuration Example

```lua
wezzy_bar.apply_to_config(config, {
  position = 'bottom',  -- 'top' or 'bottom'
  zones = {
    left = { 'tabs' },
    right = { 'clock' }
  },
  components = {
    tabs = {},  -- Minimal configuration
    clock = {
      format = '%l:%M %p',        -- 9:01 PM (default)
      -- format = '%H:%M',        -- 21:01 (24-hour)
      -- format = '%a %l:%M %p',  -- Mon 9:01 PM
      update_interval = 60000,    -- Update every minute
    }
  },
  theme = {
    tab_bar_background = nil,     -- Use theme default
    -- tab_bar_background = '#000000',  -- Custom black
    -- tab_bar_background = '#1a1a1a',  -- Custom dark gray
  }
})
```

### Theme Integration

wezzy-bar automatically adapts to your color scheme:

- **Active tabs** use your theme's accent color (perfect for Catppuccin!)
- **Inactive tabs** blend with the background
- **Clock** inherits theme colors
- **Background** uses theme base color (or custom override)

### Position Options

**Bottom (recommended):**
- Uses WezTerm's status bar area
- Guaranteed clickable functionality
- Works with all themes

**Top:**
- Integrates with native tab bar
- More traditional tab bar placement

## Platform Support

Works on all platforms supported by WezTerm (Windows, macOS, Linux, WSL). The plugin installation is handled automatically by WezTerm.

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
- Ensure `position = 'bottom'` (most reliable)
- Check that no other tab bar plugins are conflicting
- Verify WezTerm version supports the features

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
│   └── zones.lua          # Layout management
├── components/
│   ├── tabs.lua           # Tab number component
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

# Or configure manually
config.color_scheme = 'Tokyo Night'  # Test theme
```

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Credits

Built for the WezTerm community. Inspired by the need for a minimal, keyboard-focused tab bar that stays out of your way while providing essential functionality.

---

**Perfect for:** Terminal power users, Vim/Neovim users, developers who live in the terminal, anyone who wants clean aesthetics without sacrificing functionality.