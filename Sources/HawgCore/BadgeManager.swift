import Foundation
#if canImport(AppKit)
import AppKit
#endif

public struct BadgeLayout: Equatable {
    public let frame: CGRect
    public let text: String
    public let processInfo: ProcessInfo

    public init(frame: CGRect, text: String, processInfo: ProcessInfo) {
        self.frame = frame
        self.text = text
        self.processInfo = processInfo
    }
}

public final class BadgeManager {
    private let badgeHeight: CGFloat = 20
    private let horizontalPadding: CGFloat = 12
    private let rightMargin: CGFloat = 20
    private let topMargin: CGFloat = 32
    private let badgeSpacing: CGFloat = 8

    public init() {}

    public func calculateLayouts(for processes: [ProcessInfo], screenWidth: CGFloat, screenHeight: CGFloat) -> [BadgeLayout] {
        var layouts: [BadgeLayout] = []
        var currentX = screenWidth - rightMargin
        let y = screenHeight - topMargin - badgeHeight

        for process in processes {
            let text = process.displayText
            let width = estimateTextWidth(text) + horizontalPadding * 2
            let frame = CGRect(
                x: currentX - width,
                y: y,
                width: width,
                height: badgeHeight
            )
            layouts.append(BadgeLayout(frame: frame, text: text, processInfo: process))
            currentX = frame.minX - badgeSpacing
        }

        return layouts
    }

    private func estimateTextWidth(_ text: String) -> CGFloat {
        #if canImport(AppKit)
        let font = NSFont.systemFont(ofSize: 11)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let size = (text as NSString).size(withAttributes: attributes)
        return ceil(size.width)
        #else
        return CGFloat(text.count) * 7
        #endif
    }
}
