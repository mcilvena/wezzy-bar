# Development Workflow for Wezzy-bar

This directory contains development tools and configurations for rapid iteration on the wezzy-bar plugin.

## Quick Start

```bash
# Start development instance
./dev/start-dev.sh

# Run test scenarios
./dev/test-scenarios.sh
```

## Development Features

### 🚀 Separate Development Instance
- **Orange titlebar** for visual identification
- **[DEV] indicator** in status bar
- **Tokyo Night theme** (different from your main setup)
- **Smaller window** (100x30) for focused testing
- **Second-by-second clock** for rapid feedback

### ⚡ Hot Reload
- **F5**: Hot reload plugin without restarting WezTerm
- **Cmd+Shift+R**: Full configuration reload
- Automatically clears Lua module cache

### 🐛 Debug Logging
- Logs to `~/.wezzy-bar-debug.log`
- Performance timing for functions
- Context dumps for troubleshooting
- Structured logging with timestamps

### 🧪 Test Scenarios
- Multiple tab creation/deletion
- Long directory names (truncation testing)
- Theme switching verification
- Clock update validation

## Development Keybindings

| Key | Action |
|-----|--------|
| `F5` | Hot reload plugin |
| `Cmd+Shift+R` | Reload full configuration |
| `Cmd+T` | Create new tab |
| `Cmd+W` | Close current tab |

## Files Structure

```
dev/
├── wezterm-dev.lua      # Development WezTerm configuration
├── start-dev.sh         # Launch development instance
├── test-scenarios.sh    # Setup test environment
├── hot-reload.lua       # Hot reload functionality
└── README.md           # This file
```

## Development Workflow

1. **Start development instance**:
   ```bash
   ./dev/start-dev.sh
   ```

2. **Make changes** to plugin code in your main editor

3. **Test changes**:
   - Press `F5` in dev instance for quick reload
   - Or `Cmd+Shift+R` for full reload

4. **Monitor debug log**:
   ```bash
   tail -f ~/.wezzy-bar-debug.log
   ```

5. **Run test scenarios**:
   ```bash
   ./dev/test-scenarios.sh
   ```

## Testing Checklist

- [ ] **Tab Creation**: Create 5+ tabs, verify styling
- [ ] **Tab Indexing**: Check index display and numbering
- [ ] **Long Titles**: Navigate to long directory names
- [ ] **Clock Updates**: Verify second-by-second updates
- [ ] **Theme Changes**: Switch color schemes, verify adaptation
- [ ] **Width Limits**: Test max_width configuration
- [ ] **Close Buttons**: Toggle show_close_button setting
- [ ] **Hot Reload**: Make code changes, press F5

## Debugging Tips

1. **Check debug log** for errors and timing information
2. **Use context dumps** to understand render parameters
3. **Monitor function timing** to identify performance issues
4. **Test with different themes** to ensure color compatibility
5. **Create many tabs** to test layout edge cases

## Performance Monitoring

The debug system automatically times key functions:
- Component rendering
- Zone calculations
- Theme color retrieval

Check the debug log for performance bottlenecks:
```
[12:34:56] DEBUG: Function "render_zones" took 2.34ms
```