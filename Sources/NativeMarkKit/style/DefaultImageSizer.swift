import Foundation

public struct DefaultImageSizer: ImageSizer {
    public init() {}
    
    public func imageSize(_ urlString: String?, image: NativeImage, lineFragment: CGRect) -> CGSize {
        image.size
    }
}
