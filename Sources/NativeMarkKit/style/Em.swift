import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#else
#error("Unsupported platform")
#endif

public struct Em: Equatable {
    let value: CGFloat
    
    public init(value: CGFloat) {
        self.value = value
    }
    
    public func asPoints(for fontSize: CGFloat) -> Points {
        Points(value: value * fontSize)
    }
    
    public static prefix func -(rhs: Em) -> Em {
        Em(value: -rhs.value)
    }
}

public extension Int {
    var em: Length {
        .em(Em(value: CGFloat(self)))
    }
}

public extension Float {
    var em: Length {
        .em(Em(value: CGFloat(self)))
    }
}

public extension Double {
    var em: Length {
        .em(Em(value: CGFloat(self)))
    }
}
