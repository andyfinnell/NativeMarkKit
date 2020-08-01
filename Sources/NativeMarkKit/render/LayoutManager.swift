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
    }
}

private extension LayoutManager {
    func drawBlockBackgrounds(forGlyphRange glyphsToShow: NSRange) {
        guard let storage = textStorage else {
            return
        }
        
        let characterRange = self.characterRange(forGlyphRange: glyphsToShow, actualGlyphRange: nil)
        storage.enumerateAttribute(.blockBackground, in: characterRange, options: []) { value, range, stop in
            guard let blockBackground = value as? BlockBackgroundValue else { return }
            drawBlockBackground(blockBackground, forCharacterRange: range)
        }
    }
    
    func drawBlockBackground(_ blockBackground: BlockBackgroundValue, forCharacterRange characterRange: NSRange) {
        let glyphRange = self.glyphRange(forCharacterRange: characterRange, actualCharacterRange: nil)
        guard let container = textContainer(forGlyphAt: glyphRange.location, effectiveRange: nil) else {
            return
        }
        let frame = boundingRect(forGlyphRange: glyphRange, in: container)
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
        guard let container = textContainer(forGlyphAt: glyphRange.location, effectiveRange: nil) else {
            return
        }
        let frame = boundingRect(forGlyphRange: glyphRange, in: container)
        backgroundBorder.render(with: frame)
    }
}
