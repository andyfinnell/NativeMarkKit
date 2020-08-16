import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

@testable import NativeMarkKit

extension NativeImage {
    static func fixture(size: CGSize, color: NativeColor = .red) -> NativeImage {
        NativeImage.testImage(size: size) {
            color.set()
            CGRect(origin: .zero, size: size).fill()
        }
    }
}
