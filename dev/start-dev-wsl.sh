#!/bin/bash

# Start development WezTerm instance for WSL
# This script launches a separate WezTerm instance for testing wezzy-bar from WSL

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_PATH="$(wslpath -w "$SCRIPT_DIR/wezterm-dev.lua")"

echo "Starting WezTerm development instance from WSL..."
echo "Config: $CONFIG_PATH"

# Check for WezTerm in common Windows installation locations
WEZTERM_PATHS=(
    "/mnt/c/Program Files/WezTerm/wezterm.exe"
    "/mnt/c/Program Files (x86)/WezTerm/wezterm.exe"
    "/mnt/c/Users/$USER/AppData/Local/Programs/WezTerm/wezterm.exe"
)

# Detect Windows username (may differ from WSL username)
WINDOWS_USER=$(cmd.exe /c "echo %USERNAME%" 2>/dev/null | tr -d '\r')
if [ -n "$WINDOWS_USER" ]; then
    WEZTERM_PATHS+=("/mnt/c/Users/$WINDOWS_USER/AppData/Local/Programs/WezTerm/wezterm.exe")
fi

# Find WezTerm executable
WEZTERM_PATH=""
for path in "${WEZTERM_PATHS[@]}"; do
    if [ -f "$path" ]; then
        WEZTERM_PATH="$path"
        break
    fi
done

# Check if WezTerm was found
if [ -z "$WEZTERM_PATH" ]; then
    echo "Error: WezTerm not found in any of the following locations:"
    for path in "${WEZTERM_PATHS[@]}"; do
        echo "  - $path"
    done
    echo "Please check that WezTerm is installed on Windows"
    exit 1
fi

echo "Found WezTerm at: $WEZTERM_PATH"

# Launch WezTerm with development config using Windows executable
"$WEZTERM_PATH" --config-file "$CONFIG_PATH" &

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
echo "  - Clock updates every 30 seconds for performance"