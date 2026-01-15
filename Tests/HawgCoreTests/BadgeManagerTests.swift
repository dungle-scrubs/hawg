import Testing
import Foundation
@testable import HawgCore

struct BadgeManagerTests {
    let screenWidth: CGFloat = 1920
    let screenHeight: CGFloat = 1080

    @Test func calculatesPositionsForSingleBadge() {
        let manager = BadgeManager()
        let processes = [ProcessInfo(pid: 1, name: "Safari", cpuPercent: 150)]
        let layouts = manager.calculateLayouts(for: processes, screenWidth: screenWidth, screenHeight: screenHeight)

        #expect(layouts.count == 1)
        #expect(layouts[0].text == "Safari 150%")
        #expect(layouts[0].frame.origin.y == screenHeight - 32 - 20)
        #expect(layouts[0].frame.maxX == screenWidth - 20)
    }

    @Test func calculatesPositionsForMultipleBadges() {
        let manager = BadgeManager()
        let processes = [
            ProcessInfo(pid: 1, name: "Safari", cpuPercent: 150),
            ProcessInfo(pid: 2, name: "Xcode", cpuPercent: 100),
        ]
        let layouts = manager.calculateLayouts(for: processes, screenWidth: screenWidth, screenHeight: screenHeight)

        #expect(layouts.count == 2)
        #expect(layouts[0].frame.maxX == screenWidth - 20)
        #expect(layouts[1].frame.maxX < layouts[0].frame.minX)
    }

    @Test func badgesFlowLeftFromRightEdge() {
        let manager = BadgeManager()
        let processes = [
            ProcessInfo(pid: 1, name: "A", cpuPercent: 100),
            ProcessInfo(pid: 2, name: "B", cpuPercent: 90),
            ProcessInfo(pid: 3, name: "C", cpuPercent: 80),
        ]
        let layouts = manager.calculateLayouts(for: processes, screenWidth: screenWidth, screenHeight: screenHeight)

        #expect(layouts.count == 3)
        for idx in 0..<(layouts.count - 1) {
            #expect(layouts[idx + 1].frame.maxX < layouts[idx].frame.minX)
        }
    }

    @Test func emptyProcessesReturnsEmptyLayouts() {
        let manager = BadgeManager()
        let layouts = manager.calculateLayouts(for: [], screenWidth: screenWidth, screenHeight: screenHeight)

        #expect(layouts.isEmpty)
    }
}
