import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#else
#error("Unsupported platform")
#endif

public struct FourSidedValue<Value> {
    public let left: Value
    public let right: Value
    public let top: Value
    public let bottom: Value
    
    public init(left: Value,
                right: Value,
                top: Value,
                bottom: Value) {
        self.left = left
        self.right = right
        self.top = top
        self.bottom = bottom
    }
}

extension FourSidedValue where Value == Length {
    static let zero = FourSidedValue(left: 0.pt, right: 0.pt, top: 0.pt, bottom: 0.pt)
    
    func asRawPoints(for fontSize: CGFloat) -> FourSidedValue<CGFloat> {
        FourSidedValue<CGFloat>(left: left.asRawPoints(for: fontSize),
                                right: right.asRawPoints(for: fontSize),
                                top: top.asRawPoints(for: fontSize),
                                bottom: bottom.asRawPoints(for: fontSize))
    }
}

extension FourSidedValue: Equatable where Value: Equatable {}
