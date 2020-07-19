import Foundation
#if canImport(UIKit)
import UIKit

public final class NativeMarkLabel: UIControl {
    private let abstractView: AbstractView
    
    public var onOpenLink: ((URL) -> Void)? {
        get { abstractView.onOpenLink }
        set { abstractView.onOpenLink = newValue }
    }
    
    public var nativeMark: String {
        get { abstractView.nativeMark }
        set {
            abstractView.nativeMark = newValue
            invalidateIntrinsicContentSize()
            setNeedsDisplay()
            updateAccessibility()
        }
    }

    public init(nativeMark: String, styleSheet: StyleSheet) {
        abstractView = AbstractView(nativeMark: nativeMark, styleSheet: styleSheet)
        super.init(frame: .zero)
        updateAccessibility()
    }
    
    required init?(coder: NSCoder) {
        abstractView = AbstractView(nativeMark: "", styleSheet: .default)
        super.init(frame: .zero)
        updateAccessibility()
    }
    
    public override var bounds: CGRect {
        didSet {
            abstractView.bounds = bounds
            invalidateIntrinsicContentSize()
            setNeedsDisplay()
            updateAccessibility()
        }
    }
    
    public override func draw(_ rect: CGRect) {
        abstractView.draw()
    }
    
    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        return abstractView.beginTracking(at: location)
    }
    
    public override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        return abstractView.continueTracking(at: location)
    }
    
    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        if let location = touch?.location(in: self) {
            abstractView.finishTracking(at: location)
        } else {
            abstractView.cancelTracking()
        }
    }
    
    public override func cancelTracking(with event: UIEvent?) {
        abstractView.cancelTracking()
    }
}

private extension NativeMarkLabel {
    func updateAccessibility() {
        accessibilityLabel = abstractView.accessibleText()
        accessibilityElements = abstractView.accessibleUrls().map { url in
            let element = UIAccessibilityElement(accessibilityContainer: self)
            element.isAccessibilityElement = true
            element.accessibilityLabel = url.label
            element.accessibilityValue = url.url.absoluteString
            element.accessibilityTraits = [.link]
            let screen = window?.screen ?? UIScreen.main
            element.accessibilityFrame = convert(url.frame, to: screen.fixedCoordinateSpace)
            if #available(iOS 10.0, *) {
                element.accessibilityFrameInContainerSpace = url.frame
            }
            return element
        }
    }
}

#endif
