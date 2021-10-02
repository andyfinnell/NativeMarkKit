import Foundation

public struct AspectScaleDownByWidth: ImageSizer {
    public init() {}
    
    public func imageSize(_ urlString: String?, image: NativeImage, lineFragment: CGRect) -> CGSize {
        let aspectRatio = image.size.width / image.size.height
        let width = min(lineFragment.width, image.size.width)
        let height = width / aspectRatio

        return CGSize(width: width, height: height)
    }
}
