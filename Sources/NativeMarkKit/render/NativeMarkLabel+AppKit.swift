import Foundation
#if canImport(AppKit)
import AppKit

public final class NativeMarkLabel: NSView {
    private let abstractView: AbstractView
    
    public override var isFlipped: Bool { true }

    public var onOpenLink: ((URL) -> Void)? {
        get { abstractView.onOpenLink }
        set { abstractView.onOpenLink = newValue }
    }
    
    public var nativeMark: String {
        get { abstractView.nativeMark }
        set {
            guard abstractView.nativeMark != newValue else {
                return
            }
            abstractView.nativeMark = newValue
            invalidateIntrinsicContentSize()
            setNeedsDisplay(bounds)
            updateAccessibility()
            onIntrinsicSizeInvalidated?()
        }
    }

    var onIntrinsicSizeInvalidated: (() -> Void)?
    var isMultiline: Bool { abstractView.isMultiline }
    
    public init(nativeMark: String, styleSheet: StyleSheet = .default) {
        abstractView = AbstractView(nativeMark: nativeMark, styleSheet: styleSheet)
        super.init(frame: .zero)
        abstractView.delegate = self
        updateAccessibility()
    }
    
    required init?(coder: NSCoder) {
        abstractView = AbstractView(nativeMark: "", styleSheet: .default)
        super.init(frame: .zero)
        abstractView.delegate = self
        updateAccessibility()
    }
    
    public override var intrinsicContentSize: CGSize {
        abstractView.intrinsicSize()
    }
        
    public override var frame: NSRect {
        didSet {
            abstractView.bounds = bounds
            invalidateIntrinsicContentSize()
            setNeedsDisplay(bounds)
            updateAccessibility()
            onIntrinsicSizeInvalidated?()
        }
    }
    
    public override func draw(_ dirtyRect: NSRect) {
        abstractView.draw()
    }
    
    public override func mouseDown(with event: NSEvent) {
        let location = convert(event.locationInWindow, from: nil)
        _ = abstractView.beginTracking(at: location)
    }
    
    public override func mouseDragged(with event: NSEvent) {
        let location = convert(event.locationInWindow, from: nil)
        _ = abstractView.continueTracking(at: location)
    }
    
    public override func mouseUp(with event: NSEvent) {
        let location = convert(event.locationInWindow, from: nil)
        abstractView.finishTracking(at: location)
    }
}

private extension NativeMarkLabel {
    func updateAccessibility() {
        setAccessibilityLabel(abstractView.accessibleText())
        let accessibleUrls = abstractView.accessibleUrls().map { URLAcccessibilityElement(url: $0, parent: self) }
        setAccessibilityChildren(accessibleUrls)
    }
}

final class URLAcccessibilityElement: NSAccessibilityElement {
    private let url: AccessibileURL
    private weak var parent: NativeMarkLabel?
    
    init(url: AccessibileURL, parent: NativeMarkLabel) {
        self.parent = parent
        self.url = url
        super.init()
        
        setAccessibilityRole(.link)
        setAccessibilityLabel(url.label)
        setAccessibilityURL(url.url)
        let screenFrame = parent.window?.convertToScreen(parent.convert(url.frame, to: nil)) ?? url.frame
        setAccessibilityFrame(screenFrame)
        setAccessibilityParent(parent)
        setAccessibilityFrameInParentSpace(url.frame)
    }
    
    override func accessibilityLabel() -> String? {
        url.label
    }

    override func accessibilityPerformPress() -> Bool {
        parent?.onOpenLink?(url.url)
        return true
    }
}

extension NativeMarkLabel: AbstractViewDelegate {
    func abstractViewDidInvalidateRect(_ rect: CGRect) {
        invalidateIntrinsicContentSize()
        setNeedsDisplay(rect)
        updateAccessibility()
        onIntrinsicSizeInvalidated?()
    }
}
#endif
