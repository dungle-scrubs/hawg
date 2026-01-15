import Foundation

public struct ProcessInfo: Equatable, Hashable {
    public let pid: Int32
    public let name: String
    public let cpuPercent: Double

    public init(pid: Int32, name: String, cpuPercent: Double) {
        self.pid = pid
        self.name = name
        self.cpuPercent = cpuPercent
    }

    public var displayText: String {
        "\(name) \(Int(cpuPercent))%"
    }
}
