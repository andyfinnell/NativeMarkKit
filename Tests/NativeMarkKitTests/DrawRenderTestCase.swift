import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif
@testable import NativeMarkKit

final class DrawRenderTestCase: BaseRenderTestCase {
    let draw: () -> Void
    let size: CGSize
    
    init(name: String, size: CGSize, draw: @escaping () -> Void) {
        self.size = size
        self.draw = draw
        super.init(name: name)
    }
    
    override func render() -> NativeImage {
        NativeImage.testImage(size: size, draw: draw)
    }
}
