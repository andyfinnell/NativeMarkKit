import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

final class BlockQuoteValue: NSObject {
    let leftPadding: CGFloat
    let rightPadding: CGFloat
    let topPadding: CGFloat
    let bottomPadding: CGFloat
    let borderWidth: CGFloat
    let borderColor: NativeColor
    let borderSides: BorderSides
    
    init(leftPadding: CGFloat = 0,
         rightPadding: CGFloat = 0,
         topPadding: CGFloat = 0,
         bottomPadding: CGFloat = 0,
         borderWidth: CGFloat = 0,
         borderColor: NativeColor = .adaptableBlockQuoteMarginColor,
         borderSides: BorderSides = .left) {
        self.leftPadding = leftPadding
        self.rightPadding = rightPadding
        self.topPadding = topPadding
        self.bottomPadding = bottomPadding
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.borderSides = borderSides
        super.init()
    }
}
