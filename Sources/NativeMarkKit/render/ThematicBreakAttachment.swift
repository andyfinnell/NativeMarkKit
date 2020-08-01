import Foundation
#if canImport(AppKit)
import AppKit

final class ThematicBreakAttachmentCell: NSTextAttachmentCell {
    private var thematicBreakAttachment: ThematicBreakAttachment? { attachment as? ThematicBreakAttachment }
    private var thickness: CGFloat { thematicBreakAttachment?.thickness ?? 5 }
    private var color: NativeColor { thematicBreakAttachment?.color ?? .red }
    
    override func draw(withFrame cellFrame: NSRect, in controlView: NSView?) {
        color.set()
        cellFrame.fill()
    }

    override func cellFrame(for textContainer: NSTextContainer, proposedLineFragment lineFrag: NSRect, glyphPosition position: NSPoint, characterIndex charIndex: Int) -> NSRect {
        let maxWidth = textContainer.size.width
        return CGRect(x: lineFrag.minX, y: lineFrag.minY, width: min(maxWidth, lineFrag.width), height: thickness)
    }

}

#elseif canImport(UIKit)
import UIKit
#else
#error("Unsupported platform")
#endif

final class ThematicBreakAttachment: NSTextAttachment {
    let thickness: CGFloat
    fileprivate let color: NativeColor
    
    init(thickness: CGFloat, color: NativeColor) {
        self.thickness = thickness
        self.color = color
        super.init(data: nil, ofType: nil)
        #if canImport(AppKit)
        self.attachmentCell = ThematicBreakAttachmentCell()
        #endif
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // These are used by iOS. They exist for macOS, but aren't called.
    override func image(forBounds imageBounds: CGRect, textContainer: NSTextContainer?, characterIndex charIndex: Int) -> NativeImage? {
        NativeImage.make(size: imageBounds.size) {
            let bounds = CGRect(origin: .zero, size: imageBounds.size)
            color.set()
            bounds.fill()
        }
    }
    
    override func attachmentBounds(for textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
        let maxWidth = textContainer?.size.width ?? lineFrag.width
        return CGRect(x: lineFrag.minX, y: lineFrag.minY, width: min(maxWidth, lineFrag.width), height: thickness)
    }
}
