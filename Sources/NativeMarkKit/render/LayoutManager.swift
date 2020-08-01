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
        
        drawBackgroundBorders(forGlyphRange: glyphsToShow)
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
        guard let container = textContainer(forGlyphAt: glyphRange.location, effectiveRange: nil) else {
            return
        }
        let frame = boundingRect(forGlyphRange: glyphRange, in: container)
        backgroundBorder.render(with: frame)
    }
}
