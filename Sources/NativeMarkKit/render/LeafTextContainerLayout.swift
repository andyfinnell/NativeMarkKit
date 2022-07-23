import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

final class LeafTextContainerLayout: TextContainerLayout {
    private let textContainer: TextContainer
    private let path: [ContainerKind]
    private let style: TextContainerStyle
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
    
    init(path: [ContainerKind], textContainer: TextContainer, style: TextContainerStyle) {
        self.path = path
        self.textContainer = textContainer
        self.style = style
    }
    
    var paragraphSpacingAfter: CGFloat {
        guard let layoutManager = layoutManager, let storage = layoutManager.storage else {
            return 0.0
        }
        
        let glyphRange = layoutManager.glyphRange(for: textContainer)
        let characterRange = layoutManager.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
        let characterIndex = lastNonContainerBreakIndex(characterRange) // last valid index
        if let characterIndex = characterIndex,
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
        style.measure(maxWidth: maxWidth) { contentMaxWidth in
            setContainerSize(CGSize(width: contentMaxWidth, height: .largestMeasurableNumber))
            
            let usedSize = usedSize()
            
            setContainerSize(size)
            
            return usedSize
        }
    }
    
    func draw(at point: CGPoint) {
        guard let layoutManager = layoutManager else {
            return
        }
        
        let offset = point + origin
        
        style.draw(in: CGRect(origin: offset, size: size))
        
        let glyphRange = layoutManager.glyphRange(for: textContainer)
        layoutManager.drawBackground(forGlyphRange: glyphRange, at: textContainer.origin)
        layoutManager.drawGlyphs(forGlyphRange: glyphRange, at: textContainer.origin)
    }
    
    func url(under point: CGPoint) -> URL? {
        guard let storage = storage, let layoutManager = layoutManager, frame.contains(point) else {
            return nil
        }
        
        let contentFrame = style.contentFrame(for: size)
        let location = point - origin - contentFrame.origin
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

private extension LeafTextContainerLayout {
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
        _ = layoutManager?.glyphRange(for: textContainer)
        
        return layoutManager?.usedRect(for: textContainer).integral.size ?? .zero
    }
    
    func originDidChange() {
        let contentFrame = style.contentFrame(for: size)
        var absoluteOrigin = origin + contentFrame.origin
        var layout = superLayout
        while let l = layout {
            absoluteOrigin += l.origin
            layout = l.superLayout
        }
        textContainer.origin = absoluteOrigin
    }
    
    func sizeDidChange() {
        let contentFrame = style.contentFrame(for: size)
        setContainerSize(contentFrame.size)
    }
    
    func isContainerBreak(at charIndex: Int) -> Bool {
        guard let storage = storage else {
            return false
        }
        return storage.character(at: charIndex) == 12
    }
    
    func lastNonContainerBreakIndex(_ characterRange: NSRange) -> Int? {
        var potentialIndex = characterRange.upperBound - 1
        while potentialIndex >= characterRange.lowerBound && isContainerBreak(at: potentialIndex) {
            potentialIndex -= 1
        }
        
        if potentialIndex >= characterRange.lowerBound && !isContainerBreak(at: potentialIndex) {
            return potentialIndex
        }
        
        return nil
    }
}
