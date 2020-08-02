import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

final class SpacerAttachment: NativeTextAttachment {
    private let lengthInPoints: CGFloat
    
    init(lengthInPoints: CGFloat) {
        self.lengthInPoints = lengthInPoints
        super.init()
    }
    
    override func lineFragment(for textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect) -> CGRect {
        CGRect(x: 0, y: 0, width: lengthInPoints, height: 1)
    }
}
