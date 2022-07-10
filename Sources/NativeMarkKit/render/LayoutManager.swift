import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#else
#error("Unsupported platform")
#endif

final class LayoutManager: NSLayoutManager {
    override func drawBackground(forGlyphRange glyphsToShow: NSRange, at origin: CGPoint) {
        super.drawBackground(forGlyphRange: glyphsToShow, at: origin)
        
        drawBlockBackgrounds(forGlyphRange: glyphsToShow)
        drawBackgroundBorders(forGlyphRange: glyphsToShow)
        drawInlineBackgrounds(forGlyphRange: glyphsToShow)
    }
}

private extension LayoutManager {
    func drawBlockBackgrounds(forGlyphRange glyphsToShow: NSRange) {
        guard let storage = textStorage else {
            return
        }
        
        let characterRange = self.characterRange(forGlyphRange: glyphsToShow, actualGlyphRange: nil)
        storage.enumerateAttribute(.blockBackground, in: characterRange, options: []) { value, range, stop in
            guard let blockBackground = value as? BackgroundValue else { return }
            drawBlockBackground(blockBackground, forCharacterRange: range)
        }
    }
    
    func drawBlockBackground(_ blockBackground: BackgroundValue, forCharacterRange characterRange: NSRange) {
        let glyphRange = self.glyphRange(forCharacterRange: characterRange, actualCharacterRange: nil)
        guard let container = textContainer(forGlyphAt: glyphRange.location, effectiveRange: nil) as? TextContainer else {
            return
        }
        let frame = boundingRect(forGlyphRange: glyphRange, in: container) + container.origin
        let defaultFont = textStorage?.attribute(.font, at: characterRange.location, effectiveRange: nil) as? NativeFont ?? TextStyle.body.makeFont()
        blockBackground.render(in: frame, defaultFont: defaultFont)
    }

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
            guard let inlineBackground = value as? BackgroundValue else { return }
            drawInlineBackground(inlineBackground, forCharacterRange: range)
        }
    }
    
    func drawInlineBackground(_ inlineBackground: BackgroundValue, forCharacterRange characterRange: NSRange) {
        let defaultFont = textStorage?.attribute(.font, at: characterRange.location, effectiveRange: nil) as? NativeFont ?? TextStyle.body.makeFont()

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
        let defaultFont = self.textStorage?.attribute(.font, at: characterIndex, effectiveRange: nil) as? NativeFont ?? TextStyle.body.makeFont()

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
}
