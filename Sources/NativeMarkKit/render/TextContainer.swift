import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#else
#error("Unsupported platform")
#endif

protocol TextContainerDelegate: AnyObject {
    func textContainerMarginsAt(_ characterIndex: Int) -> (leading: CGFloat, trailing: CGFloat)
}

final class TextContainer: NSTextContainer {
    weak var delegate: TextContainerDelegate?
    
    override func lineFragmentRect(forProposedRect proposedRect: CGRect, at characterIndex: Int, writingDirection baseWritingDirection: NSWritingDirection, remaining remainingRect: UnsafeMutablePointer<CGRect>?) -> CGRect {
        var returnValue = super.lineFragmentRect(forProposedRect: proposedRect, at: characterIndex, writingDirection: baseWritingDirection, remaining: remainingRect)
        
        if let (leadingMargin, trailingMargin) = delegate?.textContainerMarginsAt(characterIndex) {
            returnValue = CGRect(x: returnValue.minX + leadingMargin,
                                 y: returnValue.minY,
                                 width: returnValue.width - leadingMargin - trailingMargin,
                                 height: returnValue.height)

        }
                        
        return returnValue
    }

    override var isSimpleRectangularTextContainer: Bool { false }
}
