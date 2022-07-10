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
#endif

public final class NativeMarkTextContainer {
    let container = TextContainer()
    weak var layoutManager: NativeMarkLayoutManager?
    
    public var size: CGSize {
        get { container.size }
        set { container.size = newValue }
    }
    
    public init() {
        container.lineFragmentPadding = 0
        container.delegate = self
    }
    
}

private extension NativeMarkTextContainer {
    var storage: NativeMarkStorage? {
        layoutManager?.storage
    }
    
    func marginsForBlockBackground(at characterIndex: Int) -> (leading: CGFloat, trailing: CGFloat) {
        guard let blockBackground = storage?.attribute(.blockBackground, at: characterIndex, effectiveRange: nil) as? BackgroundValue else {
            return (leading: 0, trailing: 0)
        }
        
        let defaultFont = storage?.attribute(.font, at: characterIndex, effectiveRange: nil) as? NativeFont ?? TextStyle.body.makeFont()
        return (leading: blockBackground.leftMargin.asRawPoints(for: defaultFont.pointSize),
                trailing: blockBackground.rightMargin.asRawPoints(for: defaultFont.pointSize))
    }
}

extension NativeMarkTextContainer: TextContainerDelegate {
    func textContainerMarginsAt(_ characterIndex: Int) -> (leading: CGFloat, trailing: CGFloat) {
        let blockMargins = marginsForBlockBackground(at: characterIndex)
        
        return (leading: blockMargins.leading,
                trailing: blockMargins.trailing)
    }
}
