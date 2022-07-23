import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

final class InlineContainerStyleValue: NSObject {
    let style: TextContainerStyle
    
    init(style: TextContainerStyle) {
        self.style = style
        super.init()
    }
    
    var leftOffset: CGFloat { style.leftOffset }
    var rightOffset: CGFloat { style.rightOffset }

    func draw(in contentFrame: CGRect) {
        // We get passed the text content frame, and need to convert it to
        //  the full marging/border/padding frame
        let fullFrame = CGRect(x: contentFrame.minX - style.leftOffset,
                               y: contentFrame.minY - style.topOffset,
                               width: contentFrame.width + style.leftOffset + style.rightOffset,
                               height: contentFrame.height + style.topOffset + style.bottomOffset)
        style.draw(in: fullFrame)
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? InlineContainerStyleValue else {
            return false
        }
        return style == other.style
    }
}
