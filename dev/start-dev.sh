#!/bin/bash

# Start development WezTerm instance
# This script launches a separate WezTerm instance for testing wezzy-bar

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_PATH="$SCRIPT_DIR/wezterm-dev.lua"

echo "Starting WezTerm development instance..."
echo "Config: $CONFIG_PATH"

# Launch WezTerm with development config
wezterm --config-file "$CONFIG_PATH" &

echo "Development instance started!"
echo ""
echo "Development shortcuts:"
echo "  Cmd+Shift+R : Reload configuration"
echo "  Cmd+T       : New tab (test tab creation)"
echo "  Cmd+W       : Close tab (test tab removal)"
echo ""
echo "The dev instance has:"
echo "  - Orange titlebar for identification"
echo "  - [DEV] indicator in status"
echo "  - Tokyo Night theme"
echo "  - Clock updates every second"