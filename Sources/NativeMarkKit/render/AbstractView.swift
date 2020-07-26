import Foundation
#if canImport(AppKit)
import AppKit

extension CGRect {
    func fill() {
        NSBezierPath(rect: self).fill()
    }
    
    func clear() {
        NSGraphicsContext.current?.cgContext.clear(self)
    }
}

#elseif canImport(UIKit)
import UIKit

extension NSTextContainer {
    convenience init(containerSize: CGSize) {
        self.init(size: containerSize)
    }
}

extension CGRect {
    func fill() {
        UIBezierPath(rect: self).fill()
    }
    
    func clear() {
        UIGraphicsGetCurrentContext()?.clear(self)
    }
}
#else
#error("Unsupported platform")
#endif

struct AccessibileURL {
    let label: String
    let url: URL
    let frame: CGRect
}

final class AbstractView: NSObject {
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
        super.init()
        
        container.lineFragmentPadding = 0
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
        if let stringRange = Range(characterRange, in: storage.string) {
            let substr = storage.string[stringRange]
            let fragmentRect = lineFragmentRect.pointee
            print("laying out [\(characterRange)] '\(substr)' at \(fragmentRect)")
        }
        
        if let overrideLocation = overrideLineFragmentStartingLocation(for: glyphRange) {
            let proposedRect = lineFragmentRect.pointee
            let overrideRect = CGRect(x: overrideLocation,
                                      y: proposedRect.origin.y,
                                      width: proposedRect.maxX - overrideLocation,
                                      height: proposedRect.height)
            
            lineFragmentRect.assign(repeating: overrideRect, count: 1)
            lineFragmentUsedRect.assign(repeating: overrideRect, count: 1)
            layoutManager.setDrawsOutsideLineFragment(true, forGlyphAt: glyphRange.upperBound - 1)
            return true
        }
        
        return false
    }
    
    func layoutManager(_ layoutManager: NSLayoutManager, shouldBreakLineByWordBeforeCharacterAt charIndex: Int) -> Bool {
        if let stringRange = Range(NSRange(location: charIndex, length: 1), in: storage.string) {
            let substr = storage.string[stringRange]
            print("breaking at \(substr) index [\(charIndex)]")
        }

        return true
    }

}

private extension AbstractView {
    func overrideLineFragmentStartingLocation(for glyphRange: NSRange) -> CGFloat? {
        let characterRange = layoutManager.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
        guard let stringRange = Range(characterRange, in: storage.string) else {
            return nil
        }
        
        let tabLocations = findParagraphTabStopIndices(stringRange.lowerBound).map { horizontalLocation(for: $0) }
        guard let firstLocation = tabLocations.first else {
            return nil
        }
        return tabLocations.reduce(firstLocation) { max($0, $1) }
    }
    
    func findParagraphTabStopIndices(_ characterIndex: String.Index) -> [String.Index] {
        let string = storage.string
        guard characterIndex > string.startIndex else {
            return []
        }
        var index = string.index(before: characterIndex)
        var indicesAfterTab = [String.Index]()
        
        while string[index] != "\n" {
            if string[index] == "\t" {
                indicesAfterTab.append(string.index(after: index))
            }
            if index > string.startIndex {
                index = string.index(before: index)
            } else {
                break
            }
        }
        return indicesAfterTab
    }
    
    func horizontalLocation(for index: String.Index) -> CGFloat {
        let nsRange = NSRange(index...index, in: storage.string)
        let glyphIndex = layoutManager.glyphIndexForCharacter(at: nsRange.location)
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
