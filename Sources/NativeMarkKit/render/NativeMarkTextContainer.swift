import Foundation
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
    
    func leadingMarginForTab(at characterIndex: Int) -> CGFloat? {
        let desiredIndent = storage?.attribute(.leadingMarginIndent, at: characterIndex, effectiveRange: nil) as? Int
        return desiredIndent.flatMap { findPreviousTab(characterIndex, forIndent: $0) }
            .flatMap { layoutManager?.horizontalLocation(for: $0) }
    }
    
    func findPreviousTab(_ characterIndex: Int, forIndent indent: Int) -> Int? {
        var index = characterIndex - 1
        
        while index >= 0 && !isTab(index, forIndent: indent) {
            index -= 1
        }
        
        guard index >= 0 && (index + 1) < characterIndex else {
            return nil
        }

        return index + 1
    }

    func isTab(_ characterIndex: Int, forIndent indent: Int) -> Bool {
        let tabUnichar: unichar = 9
        let isTab = storage?.character(at: characterIndex) == tabUnichar
        let actualIndent = storage?.attribute(.leadingMarginIndent, at: characterIndex, effectiveRange: nil) as? Int
        return isTab && actualIndent == indent
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
        let tabLeadingMargin = leadingMarginForTab(at: characterIndex) ?? 0
        let blockMargins = marginsForBlockBackground(at: characterIndex)
        
        return (leading: tabLeadingMargin + blockMargins.leading,
                trailing: blockMargins.trailing)
    }
}
