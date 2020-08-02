import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#else
#error("Unsupported platform")
#endif

final class ThematicBreakAttachment: NativeTextAttachment {
    let thickness: CGFloat
    private let color: NativeColor
    
    init(thickness: CGFloat, color: NativeColor) {
        self.thickness = thickness
        self.color = color
        super.init()
    }
    
    override func draw(in rect: CGRect) {
        color.set()
        rect.fill()
    }
    
    override func lineFragment(for textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect) -> CGRect {
        let maxWidth = textContainer?.size.width ?? lineFrag.width
        // TODO: should the x and y be relative?
        return CGRect(x: lineFrag.minX, y: lineFrag.minY, width: min(maxWidth, lineFrag.width), height: thickness)
    }
}
