import Foundation
import NativeMarkKit

final class FakeImageLoader: ImageLoader {
    var loadImage_stub = [String: NativeImage]()
    
    func loadImage(_ urlString: String, completion: @escaping (NativeImage?) -> Void) {
        if let image = loadImage_stub[urlString] {
            completion(image)
        } else {
            completion(nil)
        }
    }
}
