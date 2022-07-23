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
        
    override var isSimpleRectangularTextContainer: Bool { false }
}
