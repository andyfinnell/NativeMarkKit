import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#else
#error("Unsupported platform")
#endif

struct AccessibileURL {
    let label: String
    let url: URL
    let frame: CGRect
}

final class AbstractView {
    private let storage: NSTextStorage
    private let layoutManager = NSLayoutManager()
    private let container = NSTextContainer(containerSize: .zero)
    private var hasSetIntrinsicWidth = false
    private let styleSheet: StyleSheet
    private var currentlyTrackingUrl: URL?
    var bounds: CGRect = .zero {
        didSet {
            boundsDidChange()
        }
    }
    var nativeMark: String {
        didSet {
            nativeMarkDidChange()
        }
    }
    
    var onOpenLink: ((URL) -> Void)?
    
    init(nativeMark: String, styleSheet: StyleSheet) {
        self.styleSheet = styleSheet
        self.nativeMark = nativeMark
        let attributedString = (try? NSAttributedString(nativeMark: nativeMark, styleSheet: styleSheet))
            ?? NSAttributedString(string: nativeMark)
        self.storage = NSTextStorage(attributedString: attributedString)
        container.lineFragmentPadding = 0
        layoutManager.addTextContainer(container)
        storage.addLayoutManager(layoutManager)
    }
    
    func intrinsicSize() -> CGSize {
        let width = hasSetIntrinsicWidth ? bounds.width : .greatestFiniteMagnitude
        
        let computedSize = measure(maxWidth: width)
        
        hasSetIntrinsicWidth = true
        
        return computedSize
    }
    
    func draw() {
        let glyphRange = layoutManager.glyphRange(for: container)
        layoutManager.drawGlyphs(forGlyphRange: glyphRange, at: .zero)
    }
    
    func beginTracking(at location: CGPoint) -> Bool {
        currentlyTrackingUrl = url(under: location)
        
        return currentlyTrackingUrl != nil
    }
    
    func continueTracking(at location: CGPoint) -> Bool {
        currentlyTrackingUrl != nil
    }
    
    func finishTracking(at location: CGPoint) {
        if let currentUrl = url(under: location), currentUrl == currentlyTrackingUrl {
            onOpenLink?(currentUrl)
        }
        
        currentlyTrackingUrl = nil
    }
    
    func cancelTracking() {
        currentlyTrackingUrl = nil
    }
    
    func accessibleText() -> String {
        storage.string
    }
    
    func accessibleUrls() -> [AccessibileURL] {
        var accessibleUrls = [AccessibileURL]()
        
        storage.enumerateAttribute(.link, in: NSRange(location: 0, length: storage.length), options: []) { attributeValue, attributeRange, _ in
            guard let url = attributeValue as? NSURL,
                let labelRange = Range(attributeRange, in: storage.string) else {
                    return
            }
            
            let label = String(storage.string[labelRange])
            let frame = self.frame(for: attributeRange)
            accessibleUrls.append(AccessibileURL(label: label, url: url as URL, frame: frame))
        }
        
        return accessibleUrls
    }
}

private extension AbstractView {
    func measure(maxWidth: CGFloat) -> CGSize {
        setContainerSize(CGSize(width: maxWidth, height: .greatestFiniteMagnitude))
        
        let size = usedSize()
        
        setContainerSize(bounds.size)

        return size
    }
    
    func setContainerSize(_ size: CGSize) {
        container.size = size
        layoutManager.textContainerChangedGeometry(container)
    }
        
    func boundsDidChange() {
        setContainerSize(bounds.size)
    }
    
    func usedSize() -> CGSize {
        _ = layoutManager.glyphRange(for: container)
        return layoutManager.usedRect(for: container).integral.size
    }
    
    func url(under point: CGPoint) -> URL? {
        let characterIndex = layoutManager.characterIndex(for: point,
                                                          in: container,
                                                          fractionOfDistanceBetweenInsertionPoints: nil)
        guard characterIndex >= 0 && characterIndex < storage.length,
            let url = storage.attribute(.link, at: characterIndex, effectiveRange: nil) as? NSURL else {
            return nil
        }
        
        return url as URL
    }
    
    func frame(for characterRange: NSRange) -> CGRect {
        let glyphRange = layoutManager.glyphRange(forCharacterRange: characterRange, actualCharacterRange: nil)
        var rangeBounds = layoutManager.boundingRect(forGlyphRange: glyphRange, in: container)
        layoutManager.enumerateEnclosingRects(forGlyphRange: glyphRange,
                                              withinSelectedGlyphRange: NSRange(location: NSNotFound, length: 0),
                                              in: container) { rect, stop in
            rangeBounds = rect
            stop.pointee = true
        }
        return rangeBounds
    }
    
    func nativeMarkDidChange() {
        do {
            let attributedString = try NSAttributedString(nativeMark: nativeMark, styleSheet: styleSheet)
            storage.setAttributedString(attributedString)
            hasSetIntrinsicWidth = false
        } catch {
            // TODO: do something
        }
    }
}
