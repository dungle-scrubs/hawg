# Hawg

[![CI](https://github.com/dungle-scrubs/hawg/actions/workflows/ci.yml/badge.svg)](https://github.com/dungle-scrubs/hawg/actions/workflows/ci.yml)

Persistent menu bar badges showing processes with high CPU usage. Click a badge to open Activity Monitor.

## Features

- Shows all processes above CPU threshold as badges
- Badges positioned top-right, below menu bar
- Sorted by CPU usage (highest first)
- Click badge to open Activity Monitor
- Configurable threshold via command-line
- Starts automatically at login

## Requirements

- macOS 13.0+
- Swift 5.9+

## Installation

```bash
git clone https://github.com/dungle-scrubs/hawg.git
cd hawg
./install.sh
```

To uninstall:

```bash
./uninstall.sh
```

## Configuration

Default threshold is 200% CPU. To change it, edit `~/Library/LaunchAgents/com.hawg.agent.plist`:

```xml
<string>--threshold</string>
<string>80</string>
```

Then reload:

```bash
launchctl unload ~/Library/LaunchAgents/com.hawg.agent.plist
launchctl load ~/Library/LaunchAgents/com.hawg.agent.plist
```

## Known Limitations

- macOS only (uses AppKit)
- Primary monitor only
- Fixed 2-second poll interval

## Development

```bash
swift test           # Run tests
swift build          # Build debug
swiftlint lint       # Lint

# Test with low threshold
swift run Hawg --threshold 10
```

## License

MIT
