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
        didSet {
            guard nativeMark != oldValue else {
                return
            }
            abstractView.document = RenderParser.parse(nativeMark)
            invalidateIntrinsicContentSize()
            setNeedsDisplay()
            updateAccessibility()
            onIntrinsicSizeInvalidated?()
        }
    }
    
    var onIntrinsicSizeInvalidated: (() -> Void)?
    var isMultiline: Bool { abstractView.isMultiline }

    public init(nativeMark: String, styleSheet: StyleSheet = .default, environment: Environment) {
        self.nativeMark = nativeMark
        abstractView = AbstractView(document: RenderParser.parse(nativeMark), styleSheet: styleSheet, environment: environment)
        super.init(frame: .zero)
        if styleSheet.backgroundColor() == nil {
            backgroundColor = .clear
        }
        abstractView.delegate = self
        updateAccessibility()
    }
    
    public required init?(coder: NSCoder) {
        let styleSheet = StyleSheet.default
        nativeMark = ""
        abstractView = AbstractView(document: RenderParser.parse(""), styleSheet: styleSheet, environment: .default)
        super.init(frame: .zero)
        if styleSheet.backgroundColor() == nil {
            backgroundColor = .clear
        }
        abstractView.delegate = self
        updateAccessibility()
    }
        
    public override var intrinsicContentSize: CGSize {
        abstractView.intrinsicSize()
    }
    
    public override var bounds: CGRect {
        didSet {
            abstractView.bounds = bounds
            invalidateIntrinsicContentSize()
            setNeedsDisplay()
            updateAccessibility()
            onIntrinsicSizeInvalidated?()
        }
    }

    public override var frame: CGRect {
        didSet {
            abstractView.bounds = bounds
            invalidateIntrinsicContentSize()
            setNeedsDisplay()
            updateAccessibility()
            onIntrinsicSizeInvalidated?()

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
            if #available(iOS 10.0, tvOS 10.0, *) {
                element.accessibilityFrameInContainerSpace = url.frame
            }
            return element
        }
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

private extension StyleSheet {
    func backgroundColor() -> NativeColor? {
        var attributes = [NSAttributedString.Key: Any]()
        styles(for: .document).updateAttributes(&attributes)
        return attributes[.backgroundColor] as? NativeColor
    }
}

#endif

