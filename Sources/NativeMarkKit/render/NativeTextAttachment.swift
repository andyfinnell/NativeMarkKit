import Foundation
#if canImport(AppKit)
import AppKit

final class NativeTextAttachmentCell: NSTextAttachmentCell {
    private var nativeTextAttachment: NativeTextAttachment? { attachment as? NativeTextAttachment }
    
    override func draw(withFrame cellFrame: NSRect, in controlView: NSView?) {
        nativeTextAttachment?.draw(in: cellFrame)
    }

    override func cellFrame(for textContainer: NSTextContainer, proposedLineFragment lineFrag: NSRect, glyphPosition position: NSPoint, characterIndex charIndex: Int) -> NSRect {
        nativeTextAttachment?.characterIndex = charIndex
        return nativeTextAttachment?.lineFragment(for: textContainer, proposedLineFragment: lineFrag) ?? .zero
    }
}

#elseif canImport(UIKit)
import UIKit
#else
#error("Unsupported platform")
#endif

class NativeTextAttachment: NSTextAttachment {
    var characterIndex: Int?
    
    init() {
        super.init(data: nil, ofType: nil)
        #if canImport(AppKit)
        self.attachmentCell = NativeTextAttachmentCell()
        #endif
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func draw(in rect: CGRect) {
        // override point
    }
    
    func lineFragment(for textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect) -> CGRect {
        // override point
        return .zero
    }
        
    // These are used by iOS. They exist for macOS, but aren't called.
    override func image(forBounds imageBounds: CGRect, textContainer: NSTextContainer?, characterIndex charIndex: Int) -> NativeImage? {
        NativeImage.make(size: imageBounds.size) {
            let bounds = CGRect(origin: .zero, size: imageBounds.size)
            draw(in: bounds)
        }
    }
    
    override func attachmentBounds(for textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
        self.characterIndex = charIndex
        return lineFragment(for: textContainer, proposedLineFragment: lineFrag)
    }
}
