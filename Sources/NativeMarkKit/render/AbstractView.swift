import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit

extension NSTextContainer {
    convenience init(containerSize: CGSize) {
        self.init(size: containerSize)
    }
}
#endif

struct AccessibileURL {
    let label: String
    let url: URL
    let frame: CGRect
}

final class AbstractView: NSObject {
    private let storage: NSTextStorage
    private let layoutManager = LayoutManager()
    private let container = TextContainer(containerSize: .zero)
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
        super.init()
        
        container.lineFragmentPadding = 0
        container.delegate = self
        layoutManager.addTextContainer(container)
        storage.addLayoutManager(layoutManager)
        
        layoutManager.delegate = self
    }
    
    func intrinsicSize() -> CGSize {
        let width = hasSetIntrinsicWidth ? bounds.width : .greatestFiniteMagnitude
        
        let computedSize = measure(maxWidth: width)
        
        hasSetIntrinsicWidth = true
        
        return computedSize
    }
    
    func draw() {
        drawBackground()
        let glyphRange = layoutManager.glyphRange(for: container)
        layoutManager.drawBackground(forGlyphRange: glyphRange, at: .zero)
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

extension AbstractView: NSLayoutManagerDelegate {
    func layoutManager(_ layoutManager: NSLayoutManager, shouldSetLineFragmentRect lineFragmentRect: UnsafeMutablePointer<CGRect>, lineFragmentUsedRect: UnsafeMutablePointer<CGRect>, baselineOffset: UnsafeMutablePointer<CGFloat>, in textContainer: NSTextContainer, forGlyphRange glyphRange: NSRange) -> Bool {
        let characterRange = layoutManager.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
        
        if let thematicBreak = storage.attribute(.attachment, at: characterRange.location, effectiveRange: nil) as? ThematicBreakAttachment {
            let originalRect = lineFragmentRect.pointee
            let updatedRect = CGRect(x: originalRect.minX,
                                     y: originalRect.minY,
                                     width: originalRect.width,
                                     height: thematicBreak.thickness)
            lineFragmentRect.assign(repeating: updatedRect, count: 1)
            return true
        }
        
        #if DEBUG
        if let stringRange = Range(characterRange, in: storage.string) {
            let string = storage.string[stringRange]
            print("laying out [\(characterRange)](\(string)) at \(lineFragmentRect.pointee)")
        }
        #endif
        
        return false
    }
}

private extension AbstractView {
    func findPreviousTab(_ characterIndex: Int, forIndent indent: Int) -> Int? {
        var index = characterIndex - 1
        
        while index >= 0 && !isTab(index, forIndent: indent) {
            index -= 1
        }
        
        guard index >= 0 && (index + 1) < characterIndex else {
            return nil
        }

        return index + 1
    }

    func isTab(_ characterIndex: Int, forIndent indent: Int) -> Bool {
        let tabUnichar: unichar = 9
        let isTab = storage.mutableString.character(at: characterIndex) == tabUnichar
        let actualIndent = storage.attribute(.leadingMarginIndent, at: characterIndex, effectiveRange: nil) as? Int
        return isTab && actualIndent == indent
    }
    
    func horizontalLocation(for characterIndex: Int) -> CGFloat {
        let glyphIndex = layoutManager.glyphIndexForCharacter(at: characterIndex)
        let lineFragmentRect = layoutManager.lineFragmentRect(forGlyphAt: glyphIndex, effectiveRange: nil)
        let locationInsideLineFragmentRect = layoutManager.location(forGlyphAt: glyphIndex)
        return lineFragmentRect.minX + locationInsideLineFragmentRect.x
    }
        
    func drawBackground() {
        var attributes = [NSAttributedString.Key: Any]()
        styleSheet.styles(for: .document).updateAttributes(&attributes)
        if let backgroundColor = attributes[.backgroundColor] as? NativeColor {
            backgroundColor.set()
            bounds.fill()
        } else {
            bounds.clear()
        }
    }
    
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

extension AbstractView: TextContainerDelegate {
    func textContainerLeadingMarginAt(_ characterIndex: Int) -> CGFloat? {
        let desiredIndent = storage.attribute(.leadingMarginIndent, at: characterIndex, effectiveRange: nil) as? Int
        return desiredIndent.flatMap { findPreviousTab(characterIndex, forIndent: $0) }
            .flatMap { horizontalLocation(for: $0) }
    }
}
