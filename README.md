# Hawg

[![CI](https://github.com/dungle-scrubs/hawg/actions/workflows/ci.yml/badge.svg)](https://github.com/dungle-scrubs/hawg/actions/workflows/ci.yml)

Persistent menu bar badges showing processes with high CPU usage. Click a badge to open Activity Monitor.

![Hawg badges](https://via.placeholder.com/400x50?text=Safari+142%25+%7C+Xcode+98%25)

## Features

- Shows all processes above CPU threshold as badges
- Badges positioned top-right, below menu bar
- Sorted by CPU usage (highest first)
- Click badge to open Activity Monitor
- Configurable threshold via command-line
- Runs as headless app (no dock icon)

## Requirements

- macOS 13.0+
- Swift 5.9+

## Installation

### From Source

```bash
git clone https://github.com/dungle-scrubs/hawg.git
cd hawg
swift build -c release
cp .build/release/Hawg /usr/local/bin/hawg
```

### LaunchAgent (start at login)

```bash
cp com.kevin.hawg.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.kevin.hawg.plist
```

## Usage

```bash
# Default: show processes >= 100% CPU
hawg

# Custom threshold
hawg --threshold 50
```

## Configuration

Edit `com.kevin.hawg.plist` to change the default threshold:

```xml
<key>ProgramArguments</key>
<array>
    <string>/usr/local/bin/hawg</string>
    <string>--threshold</string>
    <string>80</string>
</array>
```

## Known Limitations

- **macOS only** - uses AppKit for window management
- **Primary monitor only** - badges appear on main screen
- **Fixed poll interval** - checks every 2 seconds
- **Hardcoded Activity Monitor path** - assumes standard macOS install

## Development

```bash
# Run tests
swift test

# Build debug
swift build

# Run with low threshold for testing
swift run Hawg --threshold 10

# Lint
swiftlint lint
```

## License

MIT
