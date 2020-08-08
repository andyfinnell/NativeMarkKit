import Foundation

public protocol ImageLoader {
    func loadImage(_ urlString: String, completion: @escaping (NativeImage?) -> Void)
}
