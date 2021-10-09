import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#else
#error("Unsupported platform")
#endif

public struct AspectScaleDownByWidth: ImageSizer {
    public init() {}
    
    public func imageSize(_ urlString: String?, image: NativeImage, lineFragment: CGRect) -> CGSize {
        let aspectRatio = image.size.width / image.size.height
        let width = min(lineFragment.width, image.size.width)
        let height = width / aspectRatio

        return CGSize(width: width, height: height)
    }
}
