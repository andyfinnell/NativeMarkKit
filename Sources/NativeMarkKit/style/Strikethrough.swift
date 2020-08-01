import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#else
#error("Unsupported platform")
#endif

public struct Strikethrough {
    public let style: NSUnderlineStyle
    public let color: NativeColor?
    
    public init(style: NSUnderlineStyle, color: NativeColor?) {
        self.style = style
        self.color = color
    }
}
