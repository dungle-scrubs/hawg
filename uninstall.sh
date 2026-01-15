#!/bin/bash
set -e

INSTALL_PATH="/usr/local/bin/hawg"
PLIST_PATH="$HOME/Library/LaunchAgents/com.hawg.agent.plist"

echo "Stopping hawg..."
launchctl unload "$PLIST_PATH" 2>/dev/null || true

echo "Removing LaunchAgent..."
rm -f "$PLIST_PATH"

echo "Removing binary..."
sudo rm -f "$INSTALL_PATH"

echo "Done."
