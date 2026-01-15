import Testing
@testable import HawgCore

struct ProcessInfoTests {
    @Test func displayTextFormatsCorrectly() {
        let process = ProcessInfo(pid: 123, name: "Safari", cpuPercent: 150.7)
        #expect(process.displayText == "Safari 150%")
    }

    @Test func displayTextRoundsDown() {
        let process = ProcessInfo(pid: 123, name: "Safari", cpuPercent: 99.9)
        #expect(process.displayText == "Safari 99%")
    }

    @Test func displayTextHandlesZero() {
        let process = ProcessInfo(pid: 123, name: "Safari", cpuPercent: 0)
        #expect(process.displayText == "Safari 0%")
    }

    @Test func equatableWorks() {
        let a = ProcessInfo(pid: 123, name: "Safari", cpuPercent: 50)
        let b = ProcessInfo(pid: 123, name: "Safari", cpuPercent: 50)
        let c = ProcessInfo(pid: 456, name: "Safari", cpuPercent: 50)

        #expect(a == b)
        #expect(a != c)
    }

    @Test func hashableWorks() {
        let a = ProcessInfo(pid: 123, name: "Safari", cpuPercent: 50)
        let b = ProcessInfo(pid: 123, name: "Safari", cpuPercent: 50)

        var set: Set<ProcessInfo> = [a]
        set.insert(b)
        #expect(set.count == 1)
    }
}
