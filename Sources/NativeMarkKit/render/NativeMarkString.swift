import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public final class NativeMarkString {
    private(set) var attributedString: NSAttributedString
    public let styleSheet: StyleSheet
    public var nativeMark: String {
        didSet {
            nativeMarkDidChange()
        }
    }
        
    public init(nativeMark: String, styleSheet: StyleSheet) {
        self.styleSheet = styleSheet
        self.nativeMark = nativeMark
        self.attributedString = (try? NSAttributedString(nativeMark: nativeMark, styleSheet: styleSheet))
            ?? NSAttributedString(string: nativeMark)
    }
}

extension NativeMarkString {
    func accessibleText() -> String {
        attributedString.string
    }
    
    var isMultiline: Bool {
        attributedString.string.contains(where: { $0 == "\r" || $0 == "\n" })
    }
}

private extension NativeMarkString {
    func nativeMarkDidChange() {
        do {
            attributedString = try NSAttributedString(nativeMark: nativeMark, styleSheet: styleSheet)
        } catch {
            // do nothing if it's not valid NativeMark
        }
    }
}
