import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#else
#error("Unsupported platform")
#endif

public struct AspectScaleDownByHeight: ImageSizer {
    public init() {}
    
    public func imageSize(_ urlString: String?, image: NativeImage, lineFragment: CGRect) -> CGSize {
        let aspectRatio = image.size.height / image.size.width
        let height = min(lineFragment.height, image.size.height)
        let width = height / aspectRatio

        return CGSize(width: width, height: height)
    }
}
