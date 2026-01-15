#!/bin/bash
set -e

INSTALL_PATH="/usr/local/bin/hawg"
PLIST_NAME="com.hawg.agent.plist"
PLIST_PATH="$HOME/Library/LaunchAgents/$PLIST_NAME"

echo "Building hawg..."
swift build -c release

echo "Installing binary to $INSTALL_PATH (requires sudo)..."
sudo install -d /usr/local/bin
sudo install .build/release/Hawg "$INSTALL_PATH"

echo "Installing LaunchAgent..."
mkdir -p "$HOME/Library/LaunchAgents"
sed "s|{{INSTALL_PATH}}|$INSTALL_PATH|g" com.hawg.agent.plist.template > "$PLIST_PATH"

echo "Loading LaunchAgent..."
launchctl unload "$PLIST_PATH" 2>/dev/null || true
launchctl load "$PLIST_PATH"

echo ""
echo "Done! hawg is running and will start at login."
echo "To change threshold, edit: $PLIST_PATH"
