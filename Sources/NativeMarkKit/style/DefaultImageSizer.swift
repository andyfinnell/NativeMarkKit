import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#else
#error("Unsupported platform")
#endif

public struct DefaultImageSizer: ImageSizer {
    public init() {}
    
    public func imageSize(_ urlString: String?, image: NativeImage, lineFragment: CGRect) -> CGSize {
        image.size
    }
}
