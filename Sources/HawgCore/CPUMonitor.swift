import Foundation

public protocol CPUDataSource {
    func fetchPsOutput() -> String
}

public final class ShellCPUDataSource: CPUDataSource {
    public init() {}

    public func fetchPsOutput() -> String {
        let task = Process()
        let pipe = Pipe()

        task.standardOutput = pipe
        task.standardError = FileHandle.nullDevice
        task.executableURL = URL(fileURLWithPath: "/bin/ps")
        task.arguments = ["-Ao", "pid,%cpu,comm"]

        do {
            try task.run()
            task.waitUntilExit()
        } catch {
            return ""
        }

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: .utf8) ?? ""
    }
}

public final class CPUMonitor {
    public let threshold: Double
    private let dataSource: CPUDataSource

    public init(threshold: Double, dataSource: CPUDataSource) {
        self.threshold = threshold
        self.dataSource = dataSource
    }

    public convenience init(threshold: Double = 100) {
        self.init(threshold: threshold, dataSource: ShellCPUDataSource())
    }

    public func getHighCPUProcesses() -> [ProcessInfo] {
        let output = dataSource.fetchPsOutput()
        let lines = output.components(separatedBy: .newlines)

        var processes: [ProcessInfo] = []

        for line in lines {
            guard let info = parseLine(line) else { continue }
            if info.cpuPercent >= threshold {
                processes.append(info)
            }
        }

        return processes.sorted { $0.cpuPercent > $1.cpuPercent }
    }

    private func parseLine(_ line: String) -> ProcessInfo? {
        let trimmed = line.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return nil }

        let components = trimmed.split(separator: " ", maxSplits: 2, omittingEmptySubsequences: true)
        guard components.count == 3 else { return nil }

        guard let pid = Int32(components[0]),
              let cpu = Double(components[1]) else {
            return nil
        }

        let fullPath = String(components[2])
        let name = (fullPath as NSString).lastPathComponent
        return ProcessInfo(pid: pid, name: name, cpuPercent: cpu)
    }
}
