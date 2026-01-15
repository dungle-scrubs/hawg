import AppKit

public final class BadgeWindow: NSWindow {
    private let label: NSTextField
    private var clickHandler: (() -> Void)?

    public init(layout: BadgeLayout) {
        label = NSTextField(labelWithString: layout.text)
        label.font = NSFont.systemFont(ofSize: 11)
        label.textColor = .white
        label.alignment = .center

        super.init(
            contentRect: layout.frame,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )

        level = .statusBar
        backgroundColor = .clear
        isOpaque = false
        hasShadow = false
        ignoresMouseEvents = false
        collectionBehavior = [.canJoinAllSpaces, .stationary]

        let container = BadgeView(frame: NSRect(origin: .zero, size: layout.frame.size))
        container.autoresizingMask = [.width, .height]
        container.wantsLayer = true
        container.layer?.backgroundColor = NSColor.black.withAlphaComponent(0.7).cgColor
        container.layer?.cornerRadius = 4
        container.addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor),
        ])

        container.onClick = { [weak self] in
            self?.clickHandler?()
        }

        contentView = container
    }

    public func update(layout: BadgeLayout) {
        setFrame(layout.frame, display: true)
        label.stringValue = layout.text
    }

    public func setClickHandler(_ handler: @escaping () -> Void) {
        clickHandler = handler
    }
}

private final class BadgeView: NSView {
    var onClick: (() -> Void)?

    override func mouseDown(with event: NSEvent) {
        onClick?()
    }
}
