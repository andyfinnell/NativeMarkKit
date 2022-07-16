import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public struct Environment {
    let imageLoader: ImageLoader
    let imageSizer: ImageSizer
    
    public init(imageLoader: ImageLoader,
                imageSizer: ImageSizer) {
        self.imageLoader = imageLoader
        self.imageSizer = imageSizer
    }
    
    public static var `default` = Environment(imageLoader: DefaultImageLoader(),
                                              imageSizer: DefaultImageSizer())
}
