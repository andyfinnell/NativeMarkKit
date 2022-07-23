import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#else
#error("Unsupported platform")
#endif

protocol LayoutManagerDelegate: AnyObject {
    func layoutManager(_ layoutManager: LayoutManager, invalidateFrame frame: CGRect, inContainer container: TextContainer)
}

final class LayoutManager: NSLayoutManager {
    weak var invalidationDelegate: LayoutManagerDelegate?
    
    override init() {
        super.init()
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        delegate = self
    }
    
    var storage: NSTextStorage? {
        textStorage
    }
    
    override func drawBackground(forGlyphRange glyphsToShow: NSRange, at origin: CGPoint) {
        super.drawBackground(forGlyphRange: glyphsToShow, at: origin)
        
        drawBackgroundBorders(forGlyphRange: glyphsToShow)
        drawInlineBackgrounds(forGlyphRange: glyphsToShow)
    }
    
    func drawBackground(in bounds: CGRect, using styleSheet: StyleSheet) {
        var attributes = [NSAttributedString.Key: Any]()
        styleSheet.styles(for: .document).updateAttributes(&attributes)
        if let backgroundColor = attributes[.backgroundColor] as? NativeColor {
            backgroundColor.set()
            bounds.fill()
        } else {
            bounds.clear()
        }
    }
    
    func accessibilityFrame(for characterRange: NSRange) -> CGRect {
        let glyphRange = glyphRange(forCharacterRange: characterRange, actualCharacterRange: nil)
        guard let container = textContainer(forGlyphAt: glyphRange.location, effectiveRange: nil) as? TextContainer else {
            return .zero
        }
        
        var rangeBounds = boundingRect(forGlyphRange: glyphRange, in: container)
        enumerateEnclosingRects(forGlyphRange: glyphRange,
                                withinSelectedGlyphRange: NSRange(location: NSNotFound, length: 0),
                                in: container) { rect, stop in
            rangeBounds = rect
            stop.pointee = true
        }
        return rangeBounds + container.origin
    }
    
    
    func invalidateImage(in characterRange: NSRange) {
        var actualRange = NSRange()
        invalidateLayout(forCharacterRange: characterRange, actualCharacterRange: &actualRange)
        invalidateDisplay(forCharacterRange: actualRange)
        
        let glyphRange = glyphRange(forCharacterRange: actualRange, actualCharacterRange: nil)
        
        if let container = textContainer(forGlyphAt: glyphRange.location, effectiveRange: nil) as? TextContainer {
            let bounds = boundingRect(forGlyphRange: glyphRange, in: container)
            invalidationDelegate?.layoutManager(self, invalidateFrame: bounds, inContainer: container)
        } else {
            // In this case, the image is big enough to force things out of the container
            //  Brute force the updates
            for wrappedContainer in textContainers {
                let glyphRange = self.glyphRange(for: wrappedContainer)
                let bounds = boundingRect(forGlyphRange: glyphRange, in: wrappedContainer)
                if let container = wrappedContainer as? TextContainer {
                    invalidationDelegate?.layoutManager(self, invalidateFrame: bounds, inContainer: container)
                }
            }
        }
    }
    
}

extension LayoutManager: NSLayoutManagerDelegate {
    func layoutManager(_ layoutManager: NSLayoutManager, shouldSetLineFragmentRect lineFragmentRect: UnsafeMutablePointer<CGRect>, lineFragmentUsedRect: UnsafeMutablePointer<CGRect>, baselineOffset: UnsafeMutablePointer<CGFloat>, in textContainer: NSTextContainer, forGlyphRange glyphRange: NSRange) -> Bool {
        let characterRange = layoutManager.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)
                
#if false // DEBUG
        if let storage = storage, let stringRange = Range(characterRange, in: storage.string) {
            let string = storage.string[stringRange]
            print("laying out [\(characterRange)](\(string)) at \(lineFragmentRect.pointee)")
        }
#endif
        
        return false
    }
    
    func layoutManager(_ layoutManager: NSLayoutManager, shouldUse action: NSLayoutManager.ControlCharacterAction, forControlCharacterAt charIndex: Int) -> NSLayoutManager.ControlCharacterAction {
        let ch = storage?.character(at: charIndex)
        if ch == 13 /* \r */ {
            return .lineBreak
        } else if action.contains(.containerBreak),
                  let containerBreakValue = storage?.safeAttribute(.containerBreak, at: charIndex, effectiveRange: nil) as? ContainerBreakValue {
            return containerBreakValue.shouldContainerBreak ? .containerBreak : .zeroAdvancement
        } else if action.contains(.lineBreak) {
            // If we're about to actually break to a new container, don't also do a line break
            let isAboutToContainerBreak = areAnyOfNextCharactersContainerBreaks(startingAt: charIndex + 1)
            return isAboutToContainerBreak ? .zeroAdvancement : action
        } else {
            return action
        }
    }
}

private extension LayoutManager {
        
    func drawBackgroundBorders(forGlyphRange glyphsToShow: NSRange) {
        guard let storage = textStorage else {
            return
        }
        
        let characterRange = self.characterRange(forGlyphRange: glyphsToShow, actualGlyphRange: nil)
        storage.enumerateAttribute(.backgroundBorder, in: characterRange, options: []) { value, range, stop in
            guard let backgroundBorder = value as? BackgroundBorderValue else { return }
            drawBackgroundBorder(backgroundBorder, forCharacterRange: range)
        }
    }
    
    func drawBackgroundBorder(_ backgroundBorder: BackgroundBorderValue, forCharacterRange characterRange: NSRange) {
        let glyphRange = self.glyphRange(forCharacterRange: characterRange, actualCharacterRange: nil)
        guard let container = textContainer(forGlyphAt: glyphRange.location, effectiveRange: nil) as? TextContainer else {
            return
        }
        let frame = boundingRect(forGlyphRange: glyphRange, in: container) + container.origin
        backgroundBorder.render(with: frame)
    }
    
    func drawInlineBackgrounds(forGlyphRange glyphsToShow: NSRange) {
        guard let storage = textStorage else {
            return
        }
        
        let characterRange = self.characterRange(forGlyphRange: glyphsToShow, actualGlyphRange: nil)
        storage.enumerateAttribute(.inlineBackground, in: characterRange, options: []) { value, range, stop in
            guard let inlineBackground = value as? InlineBackgroundValue else { return }
            drawInlineBackground(inlineBackground, forCharacterRange: range)
        }
    }
    
    func drawInlineBackground(_ inlineBackground: InlineBackgroundValue, forCharacterRange characterRange: NSRange) {
        let defaultFont = textStorage?.safeAttribute(.font, at: characterRange.location, effectiveRange: nil) as? NativeFont ?? TextStyle.body.makeFont()
        
        enumerateTypographicBounds(forCharacterRange: characterRange) { glyphRange, lineFrame, container in
            guard let textContainer = container as? TextContainer else {
                return
            }
            inlineBackground.render(in: lineFrame + textContainer.origin, defaultFont: defaultFont)
        }
    }
    
    func enumerateTypographicBounds(forCharacterRange characterRange: NSRange, with block: @escaping (NSRange, CGRect, NSTextContainer) -> Void) {
        let glyphRange = self.glyphRange(forCharacterRange: characterRange, actualCharacterRange: nil)
        
        enumerateLineFragments(forGlyphRange: glyphRange) { lineFrame, usedRect, container, lineRange, _ in
            guard let intersectingRange = glyphRange.intersection(lineRange) else { return }
            
            let totalFrame = self.typographicBounds(ofGlyphRange: intersectingRange, onLineFragment: lineFrame, container: container)
            
            if let theFrame = totalFrame {
                block(intersectingRange, theFrame, container)
            }
        }
    }
    
    func typographicBounds(ofGlyphRange glyphRange: NSRange, onLineFragment lineFrame: CGRect, container: NSTextContainer) -> CGRect? {
        let glyphs = UnsafeMutablePointer<CGGlyph>.allocate(capacity: glyphRange.length)
        let characterIndices = UnsafeMutablePointer<Int>.allocate(capacity: glyphRange.length)
        let count = self.getGlyphs(in: glyphRange, glyphs: glyphs, properties: nil, characterIndexes: characterIndices, bidiLevels: nil)
        
        var totalFrame: CGRect?
        for i in 0..<count {
            let glyph = glyphs[i]
            let characterIndex = characterIndices[i]
            let glyphIndex = glyphRange.location + i
            
            let frame = typographicBounds(ofGlyph: glyph, atGlyphIndex: glyphIndex, characterIndex: characterIndex, onLineFragment: lineFrame, container: container)
            
            if let previousFrame = totalFrame {
                totalFrame = previousFrame.union(frame)
            } else {
                totalFrame = frame
            }
        }
        
        glyphs.deallocate()
        characterIndices.deallocate()
        
        return totalFrame
    }
    
    func typographicBounds(ofGlyph glyph: CGGlyph, atGlyphIndex glyphIndex: Int, characterIndex: Int, onLineFragment lineFrame: CGRect, container: NSTextContainer) -> CGRect {
        let location = self.location(forGlyphAt: glyphIndex)
        let defaultFont = self.textStorage?.safeAttribute(.font, at: characterIndex, effectiveRange: nil) as? NativeFont ?? TextStyle.body.makeFont()
        
        let frameLocation = CGPoint(x: lineFrame.minX + location.x,
                                    y: lineFrame.minY + location.y)
        let glyphBoundingRect = boundingRect(forGlyphRange: NSRange(location: glyphIndex, length: 1),
                                             in: container)
        let ascender = defaultFont.ascender
        let descender = defaultFont.descender
        return CGRect(x: glyphBoundingRect.minX,
                      y: frameLocation.y - ascender,
                      width: glyphBoundingRect.width,
                      height: ascender - descender)
    }
    
    func areAnyOfNextCharactersContainerBreaks(startingAt charIndex: Int) -> Bool {
        var current = charIndex
        var result = isContainerBreak(at: current)
        while result != .notContainerBreak {
            switch result {
            case .notContainerBreak:
                return false // stop entire process
            case .isContainerBreakButDoesNotBreak:
                break // go to the next character
            case .isContainerBreak:
                return true // we have one, so stop process
            }
            current += 1
            result = isContainerBreak(at: current)
        }
        
        return false
    }
    
    enum Break {
        case notContainerBreak
        case isContainerBreakButDoesNotBreak
        case isContainerBreak
    }
    
    func isContainerBreak(at charIndex: Int) -> Break {
        let length = storage?.length ?? 0
        if charIndex < length, let containerBreakValue = storage?.safeAttribute(.containerBreak, at: charIndex, effectiveRange: nil) as? ContainerBreakValue {
            return containerBreakValue.shouldContainerBreak ? .isContainerBreak : .isContainerBreakButDoesNotBreak
        } else {
            return .notContainerBreak
        }
    }
}
