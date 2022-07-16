import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

final class ListItemMarkerContainerLayout: TextContainerLayout {
    private let textContainer: TextContainer
    private let path: [ContainerKind]
    weak var superLayout: TextContainerLayout?
    var origin: CGPoint = .zero {
        didSet {
            originDidChange()
        }
    }
    var size: CGSize = .zero {
        didSet {
            sizeDidChange()
        }
    }
    
    init(path: [ContainerKind], textContainer: TextContainer) {
        self.path = path
        self.textContainer = textContainer
    }
    
    var paragraphSpacingAfter: CGFloat {
        guard let layoutManager = layoutManager, let storage = layoutManager.storage else {
            return 0.0
        }
        
        let glyphRange = layoutManager.glyphRange(for: textContainer)
        let characterRange = layoutManager.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
        let characterIndex = characterRange.upperBound - 1 // last valid index
        if characterIndex < storage.length,
           let paragraphStyle = storage.safeAttribute(.paragraphStyle,
                                                  at: characterIndex,
                                                  effectiveRange: nil) as? NSParagraphStyle {
            return paragraphStyle.paragraphSpacing
        }
        return 0.0
    }
    
    var paragraphSpacingBefore: CGFloat {
        guard let layoutManager = layoutManager, let storage = layoutManager.storage else {
            return 0.0
        }
        
        let glyphRange = layoutManager.glyphRange(for: textContainer)
        let characterRange = layoutManager.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
        let characterIndex = characterRange.lowerBound // first valid index
        if characterIndex < storage.length, characterIndex >= 0,
           let paragraphStyle = storage.safeAttribute(.paragraphStyle,
                                                  at: characterIndex,
                                                  effectiveRange: nil) as? NSParagraphStyle {
            return paragraphStyle.paragraphSpacingBefore
        }
        return 0.0
    }
    
    func measure(maxWidth: CGFloat) -> CGSize {
        setContainerSize(CGSize(width: maxWidth, height: .largestMeasurableNumber))
        
        let usedSize = usedSize()
        
        setContainerSize(size)
        
        return usedSize
    }
    
    func draw(at point: CGPoint) {
        guard let layoutManager = layoutManager else {
            return
        }
        
        let offset = point + origin
        let glyphRange = layoutManager.glyphRange(for: textContainer)
        layoutManager.drawBackground(forGlyphRange: glyphRange, at: offset)
        layoutManager.drawGlyphs(forGlyphRange: glyphRange, at: offset)
    }
    
    func url(under point: CGPoint) -> URL? {
        guard let storage = storage, let layoutManager = layoutManager, frame.contains(point) else {
            return nil
        }
        
        let location = point - origin
        let characterIndex = layoutManager.characterIndex(for: location,
                                                          in: textContainer,
                                                          fractionOfDistanceBetweenInsertionPoints: nil)
        guard characterIndex >= 0 && characterIndex < storage.length,
              let url = storage.safeAttribute(.nativeMarkLink, at: characterIndex, effectiveRange: nil) as? NSURL else {
            return nil
        }
        
        return url as URL
    }
    
}

private extension ListItemMarkerContainerLayout {
    var layoutManager: LayoutManager? {
        textContainer.layoutManager as? LayoutManager
    }
    
    var storage: NSTextStorage? {
        layoutManager?.textStorage
    }
    
    func setContainerSize(_ size: CGSize) {
        textContainer.size = size
        layoutManager?.textContainerChangedGeometry(textContainer)
    }
    
    func usedSize() -> CGSize {
        guard let layoutManager = layoutManager,
              let storage = layoutManager.storage else {
            return .zero
        }
        
        let glyphRange = layoutManager.glyphRange(for: textContainer)
        let characterRange = layoutManager.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
        
        var rawRect = layoutManager.usedRect(for: textContainer)
        if let paragraphStyle = storage.safeAttribute(.paragraphStyle, at: characterRange.location, effectiveRange: nil) as? NSParagraphStyle {
            if paragraphStyle.tailIndent < 0 {
                rawRect.size.width -= paragraphStyle.tailIndent
            }
            if paragraphStyle.firstLineHeadIndent < 0 {
                rawRect.size.width -= paragraphStyle.firstLineHeadIndent
            }
        }
        
        return rawRect.integral.size
    }
    
    func originDidChange() {
        var absoluteOrigin = origin
        var layout = superLayout
        while let l = layout {
            absoluteOrigin += l.origin
            layout = l.superLayout
        }
        textContainer.origin = absoluteOrigin
    }
    
    func sizeDidChange() {
        setContainerSize(size)
    }
}
