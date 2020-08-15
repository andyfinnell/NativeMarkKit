import Foundation
import XCTest
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#else
#error("Unsupported platform")
#endif
@testable import NativeMarkKit

final class RenderTestCase: BaseRenderTestCase {
    let nativeMark: String
    let styleSheet: StyleSheet
    let width: CGFloat
    
    init(name: String, nativeMark: String, styleSheet: StyleSheet, width: CGFloat) {
        self.nativeMark = nativeMark
        self.styleSheet = styleSheet
        self.width = width
        super.init(name: name)
    }
    
    override func render() -> NativeImage {
        let view = AbstractView(nativeMark: nativeMark, styleSheet: styleSheet)
        _ = view.intrinsicSize() // it'll assume it has infinite width
        view.bounds = CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude)
        let sizeWithRealHeight = view.intrinsicSize()
        view.bounds = CGRect(x: 0, y: 0, width: width, height: sizeWithRealHeight.height)
        
        return view.makeImage()
    }
}
