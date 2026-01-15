import AppKit
import HawgCore

final class HawgApp {
    private let monitor: CPUMonitor
    private let badgeManager = BadgeManager()
    private var windows: [Int32: BadgeWindow] = [:]
    private var timer: Timer?

    init(threshold: Double) {
        monitor = CPUMonitor(threshold: threshold)
    }

    func run() {
        let app = NSApplication.shared
        app.setActivationPolicy(.accessory)

        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.update()
        }

        update()
        app.run()
    }

    private func update() {
        let processes = monitor.getHighCPUProcesses()
        guard let screen = NSScreen.main else { return }
        let screenWidth = screen.frame.width
        let screenHeight = screen.frame.height

        let layouts = badgeManager.calculateLayouts(
            for: processes,
            screenWidth: screenWidth,
            screenHeight: screenHeight
        )
        let currentPids = Set(processes.map { $0.pid })
        let existingPids = Set(windows.keys)

        let pidsToRemove = existingPids.subtracting(currentPids)
        for pid in pidsToRemove {
            windows[pid]?.close()
            windows[pid] = nil
        }

        for layout in layouts {
            let pid = layout.processInfo.pid
            if let window = windows[pid] {
                window.update(layout: layout)
            } else {
                let window = BadgeWindow(layout: layout)
                window.setClickHandler {
                    NSWorkspace.shared.open(URL(fileURLWithPath: "/System/Applications/Utilities/Activity Monitor.app"))
                }
                window.orderFront(nil)
                windows[pid] = window
            }
        }
    }
}

func parseThreshold() -> Double {
    let args = CommandLine.arguments
    if let idx = args.firstIndex(of: "--threshold"), idx + 1 < args.count {
        return Double(args[idx + 1]) ?? 100
    }
    return 100
}

let threshold = parseThreshold()
let app = HawgApp(threshold: threshold)
app.run()
