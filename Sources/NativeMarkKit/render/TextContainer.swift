import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit

extension NSTextContainer {
    convenience init(containerSize: CGSize) {
        self.init(size: containerSize)
    }
}
#else
#error("Unsupported platform")
#endif

final class TextContainer: NSTextContainer {
    var origin: CGPoint = .zero
    
    init() {
        super.init(size: .zero)
        lineFragmentPadding = 0
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        lineFragmentPadding = 0
    }
    
    override func lineFragmentRect(forProposedRect proposedRect: CGRect, at characterIndex: Int, writingDirection baseWritingDirection: NSWritingDirection, remaining remainingRect: UnsafeMutablePointer<CGRect>?) -> CGRect {
        let returnValue = super.lineFragmentRect(forProposedRect: proposedRect, at: characterIndex, writingDirection: baseWritingDirection, remaining: remainingRect)
        
        let (leadingMargin, trailingMargin) = textContainerMarginsAt(characterIndex)
        return CGRect(x: returnValue.minX + leadingMargin,
                      y: returnValue.minY,
                      width: returnValue.width - leadingMargin - trailingMargin,
                      height: returnValue.height)
    }
    
    override var isSimpleRectangularTextContainer: Bool { false }
}

private extension TextContainer {
    var storage: NSTextStorage? {
        layoutManager?.textStorage
    }
    
    func marginsForBlockBackground(at characterIndex: Int) -> (leading: CGFloat, trailing: CGFloat) {
        guard let blockBackground = storage?.safeAttribute(.blockBackground, at: characterIndex, effectiveRange: nil) as? BackgroundValue else {
            return (leading: 0, trailing: 0)
        }
        
        let defaultFont = storage?.safeAttribute(.font, at: characterIndex, effectiveRange: nil) as? NativeFont ?? TextStyle.body.makeFont()
        return (leading: blockBackground.leftMargin.asRawPoints(for: defaultFont.pointSize),
                trailing: blockBackground.rightMargin.asRawPoints(for: defaultFont.pointSize))
    }
    
    func textContainerMarginsAt(_ characterIndex: Int) -> (leading: CGFloat, trailing: CGFloat) {
        let blockMargins = marginsForBlockBackground(at: characterIndex)
        
        return (leading: blockMargins.leading,
                trailing: blockMargins.trailing)
    }
    
}
