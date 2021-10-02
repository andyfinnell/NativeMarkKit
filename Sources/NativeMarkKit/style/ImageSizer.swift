import Foundation

public protocol ImageSizer {
    func imageSize(_ urlString: String?, image: NativeImage, lineFragment: CGRect) -> CGSize
}
