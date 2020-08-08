import Foundation

public final class DefaultImageLoader: ImageLoader {
    private let session = URLSession.shared
    
    public init() {
        
    }
    
    public func loadImage(_ urlString: String, completion: @escaping (NativeImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = session.dataTask(with: url) { maybeData, _, _ in
            guard let data = maybeData, let image = NativeImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            DispatchQueue.main.async {
                completion(image)
            }
        }
        task.resume()
    }
}
