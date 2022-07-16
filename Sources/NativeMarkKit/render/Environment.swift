import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public struct Environment {
    let imageLoader: ImageLoader
    let imageSizer: ImageSizer
    
    public init(imageLoader: ImageLoader = DefaultImageLoader(),
                imageSizer: ImageSizer = DefaultImageSizer()) {
        self.imageLoader = imageLoader
        self.imageSizer = imageSizer
    }
}
