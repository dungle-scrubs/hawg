# Hawg - CPU Monitor Badge App

Swift app that shows persistent badges when processes exceed configurable CPU threshold.

## Architecture

**Swift Package** with testable modules:

```
hawg/
├── Package.swift
├── Sources/
│   ├── Hawg/               # Main executable
│   │   └── main.swift
│   └── HawgCore/           # Testable library
│       ├── CPUMonitor.swift
│       ├── ProcessInfo.swift
│       ├── BadgeManager.swift
│       └── BadgeWindow.swift
├── Tests/
│   └── HawgCoreTests/
│       ├── CPUMonitorTests.swift
│       └── BadgeManagerTests.swift
└── ...
```

### Components

1. **CPUMonitor** - Parses `ps` output, returns `[ProcessInfo]` above threshold (testable)
2. **BadgeManager** - Manages multiple badge windows, layout logic (testable)
3. **BadgeWindow** - Single badge NSWindow
4. **NSApplication** - Headless app (no dock icon, no menu bar) with run loop

### Badge Design

- Position: Top-right, 20px from edge, 30px below top (under menu bar)
- Multiple badges: Horizontal row, 8px spacing between badges
- Size: Dynamic width per badge, 20px height
- Font: System font, 11pt (small)
- Style: Dark semi-transparent rounded rect (#000 @ 70%), white text
- Content: "AppName 142%" format
- Click action: Opens Activity Monitor
- Shows ALL apps above threshold, sorted by CPU descending

## Configuration

Threshold configurable via command-line argument:

```bash
hawg --threshold 50   # Alert at 50%+ CPU
hawg                  # Default: 100%
```

LaunchAgent can include the threshold:

```xml
<key>ProgramArguments</key>
<array>
    <string>/usr/local/bin/hawg</string>
    <string>--threshold</string>
    <string>80</string>
</array>
```

## TDD Implementation Order

### 1. ProcessInfo (data model)

```swift
struct ProcessInfo: Equatable {
    let pid: Int32
    let name: String
    let cpuPercent: Double
}
```

### 2. CPUMonitor (testable, no UI)

Tests first:
- `test_parsesValidPsOutput` - parses multi-line ps output
- `test_filtersAtThreshold` - only returns processes >= threshold
- `test_sortsDescendingByCPU` - highest CPU first
- `test_handlesEmptyOutput` - returns empty array
- `test_handlesMalformedLines` - skips bad lines gracefully

```swift
protocol CPUDataSource {
    func fetchPsOutput() -> String
}

class CPUMonitor {
    let threshold: Double
    let dataSource: CPUDataSource

    func getHighCPUProcesses() -> [ProcessInfo]
}
```

Inject `CPUDataSource` for testing (mock ps output).

### 3. BadgeManager (testable layout logic)

Tests first:
- `test_calculatesPositionsForSingleBadge` - rightmost position
- `test_calculatesPositionsForMultipleBadges` - horizontal row, 8px gaps
- `test_badgesFlowLeftFromRightEdge` - new badges push left

```swift
struct BadgeLayout {
    let frame: NSRect
    let text: String
}

class BadgeManager {
    func calculateLayouts(for processes: [ProcessInfo], screenWidth: CGFloat) -> [BadgeLayout]
}
```

### 4. BadgeWindow (UI, not unit tested)

```swift
class BadgeWindow: NSWindow {
    init(layout: BadgeLayout)
    func update(layout: BadgeLayout)
    // Click handler -> NSWorkspace.shared.open(activityMonitorURL)
}
```

### 5. main.swift (wiring)

- Parse args (`--threshold`)
- Create `CPUMonitor` with real `ShellCPUDataSource`
- Timer loop: poll -> calculate layouts -> update windows
- Run NSApplication

## Build & Test

```bash
cd ~/dev/hawg
swift test                    # Run unit tests
swift build -c release        # Build release binary
```

## Install

```bash
cp .build/release/Hawg /usr/local/bin/hawg
cp com.kevin.hawg.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.kevin.hawg.plist
```

## Verification

1. `swift test` - all tests pass
2. `swift run Hawg --threshold 50` - run manually
3. Spawn CPU hogs: `yes > /dev/null & yes > /dev/null &`
4. Confirm 2 badges appear, horizontally aligned
5. Click a badge -> Activity Monitor opens
6. Kill `yes` processes -> badges disappear
7. Test LaunchAgent after install
