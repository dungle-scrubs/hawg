import Testing
@testable import HawgCore

struct CPUMonitorTests {
    @Test func parsesValidPsOutput() {
        let mock = MockCPUDataSource(output: """
            PID   %CPU COMMAND
            123  150.5 Safari
            456   80.2 Xcode
            789   25.0 Finder
            """)
        let monitor = CPUMonitor(threshold: 50, dataSource: mock)
        let processes = monitor.getHighCPUProcesses()

        #expect(processes.count == 2)
        #expect(processes[0].name == "Safari")
        #expect(processes[0].cpuPercent == 150.5)
        #expect(processes[1].name == "Xcode")
    }

    @Test func filtersAtThreshold() {
        let mock = MockCPUDataSource(output: """
            PID   %CPU COMMAND
            123  100.0 Safari
            456   99.9 Xcode
            """)
        let monitor = CPUMonitor(threshold: 100, dataSource: mock)
        let processes = monitor.getHighCPUProcesses()

        #expect(processes.count == 1)
        #expect(processes[0].name == "Safari")
    }

    @Test func sortsDescendingByCPU() {
        let mock = MockCPUDataSource(output: """
            PID   %CPU COMMAND
            123   50.0 Safari
            456  200.0 Xcode
            789  100.0 Finder
            """)
        let monitor = CPUMonitor(threshold: 50, dataSource: mock)
        let processes = monitor.getHighCPUProcesses()

        #expect(processes.count == 3)
        #expect(processes[0].name == "Xcode")
        #expect(processes[1].name == "Finder")
        #expect(processes[2].name == "Safari")
    }

    @Test func handlesEmptyOutput() {
        let mock = MockCPUDataSource(output: "")
        let monitor = CPUMonitor(threshold: 100, dataSource: mock)
        let processes = monitor.getHighCPUProcesses()

        #expect(processes.isEmpty)
    }

    @Test func handlesMalformedLines() {
        let mock = MockCPUDataSource(output: """
            PID   %CPU COMMAND
            bad line here
            123  150.0 Safari
            incomplete
            456   80.0 Xcode
            """)
        let monitor = CPUMonitor(threshold: 50, dataSource: mock)
        let processes = monitor.getHighCPUProcesses()

        #expect(processes.count == 2)
        #expect(processes[0].name == "Safari")
        #expect(processes[1].name == "Xcode")
    }

    @Test func handlesCommandWithSpaces() {
        let mock = MockCPUDataSource(output: """
            PID   %CPU COMMAND
            123  150.0 Google Chrome Helper
            """)
        let monitor = CPUMonitor(threshold: 100, dataSource: mock)
        let processes = monitor.getHighCPUProcesses()

        #expect(processes.count == 1)
        #expect(processes[0].name == "Google Chrome Helper")
    }

    @Test func extractsBasenameFromFullPath() {
        let mock = MockCPUDataSource(output: """
            PID   %CPU COMMAND
            123  150.0 /Applications/Safari.app/Contents/MacOS/Safari
            456  120.0 /System/Library/CoreServices/Finder.app/Contents/MacOS/Finder
            """)
        let monitor = CPUMonitor(threshold: 100, dataSource: mock)
        let processes = monitor.getHighCPUProcesses()

        #expect(processes.count == 2)
        #expect(processes[0].name == "Safari")
        #expect(processes[1].name == "Finder")
    }

    @Test func handlesZeroCPU() {
        let mock = MockCPUDataSource(output: """
            PID   %CPU COMMAND
            123   0.0 Safari
            456 100.0 Xcode
            """)
        let monitor = CPUMonitor(threshold: 50, dataSource: mock)
        let processes = monitor.getHighCPUProcesses()

        #expect(processes.count == 1)
        #expect(processes[0].name == "Xcode")
    }

    @Test func handlesDecimalThreshold() {
        let mock = MockCPUDataSource(output: """
            PID   %CPU COMMAND
            123  50.5 Safari
            456  50.4 Xcode
            """)
        let monitor = CPUMonitor(threshold: 50.5, dataSource: mock)
        let processes = monitor.getHighCPUProcesses()

        #expect(processes.count == 1)
        #expect(processes[0].name == "Safari")
    }
}

final class MockCPUDataSource: CPUDataSource {
    let output: String

    init(output: String) {
        self.output = output
    }

    func fetchPsOutput() -> String {
        output
    }
}
