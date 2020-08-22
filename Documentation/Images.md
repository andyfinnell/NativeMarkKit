# Loading images

NativeMarkKit can render inline images. By default, it provides a simple downloader to fetch these images. However, integrating apps might want to provide an alternative image downloader, either for testing purposes or to implement image caching.

The image downloader is attached to the `StyleSheet`, and can be overridden there. To provide a custom image loader, the app needs to implement the `ImageLoader` protocol, then mutate any `StyleSheet`s it wants to use its custom image loader.

```Swift
import NativeMarkKit // pulls in ImageLoader protocol

final class MyImageLoader: ImageLoader {
    func loadImage(_ urlString: String, completion: @escaping (NativeImage?) -> Void) {
        // Fetch the image at urlString. 
        //  If it fails, call completion with nil
        //  If it succeeds, call completion with the image
        // completion MUST BE called on the main thread
    }
}

// In app startup have our custom loader be used by default
StyleSheet.default.mutate(imageLoader: MyImageLoader())
```

The `ImageLoader` protocol only requires one method. The `completion` method must be invoked, even if the loading fails. It also must be invoked on the main thread.
