# Loading images

NativeMarkKit can render inline images. By default, it provides a simple downloader to fetch these images. However, integrating apps might want to provide an alternative image downloader, either for testing purposes or to implement image caching.

The image downloader is contained in the `Environment` type,  and can be overridden there. To provide a custom image loader, the app needs to implement the `ImageLoader` protocol, then inject that into a `Environment`. From there, the app can either overwrite the `default` `Environment` global, or it can pass the `Environment` into each `NativeMarkLabel` or `NativeMarkText` it wants to use the environment.

Both options start by defining the image loader:

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
```

To effect the entire app, overwrite the global default during app startup:

```Swift
import NativeMarkKit

// ...in applicationDidFinishLaunching or the like...
Environment.default = Environment(imageLoader: MyImageLoader(), imageSizer: DefaultImageSizer())
```

If you want to specify which views use the new image loader, or are averse to mutating globals, you can pass the `Environment` into the `init` method of `NativeMarkLabel` or `NativeMarkText`:

```Swift
let label = NativeMarkLabel(nativeMark: "Here's a tiny kitten: ![Tiny kitten](http://placekitten.com/g/20/20)", 
                            environment: Environment(imageLoader: MyImageLoader(), imageSizer: DefaultImageSizer()))
```

The `ImageLoader` protocol only requires one method. The `completion` method must be invoked, even if the loading fails. It also must be invoked on the main thread.

# Scaling images

By default, NativeMarkKit will not resize the images it downloads, but render them at their natural size. This isn't always desirable, so NativeMarkKit provides a customization point to allow whatever kind of scaling the app wants.

The image sizing behavior is contained in the `Environment`, and can be overridden there. To provide a custom image sizer, the app needs to implement the `ImageSizer` protocol (or use a built-in implementation), then inject that into a `Environment`. From there, the app can either overwrite the `default` `Environment` global, or it can pass the `Environment` into each `NativeMarkLabel` or `NativeMarkText` it wants to use the environment.

Start by defining the custom image sizer:

```Swift
import NativeMarkKit

struct MyImageSizer: ImageSizer {
    func imageSize(_ urlString: String?, image: NativeImage, lineFragment: CGRect) -> CGSize {
        // Implement whatever scaling you wish here. Return the new image size
    }
}
```

To effect the entire app, overwrite the global default during app startup:

```Swift
import NativeMarkKit

// ...in applicationDidFinishLaunching or the like...
Environment.default = Environment(imageLoader: DefaultImageLoader(), imageSizer: MyImageSizer())
```

If you want to specify which views use the new image sizer, or are averse to mutating globals, you can pass the `Environment` into the `init` method of `NativeMarkLabel` or `NativeMarkText`:

```Swift
let label = NativeMarkLabel(nativeMark: "Here's a tiny kitten: ![Tiny kitten](http://placekitten.com/g/20/20)", 
                            environment: Environment(imageLoader: DefaultImageLoader(), imageSizer: MyImageSizer()))
```

## Built-in image sizers

NativeMarkKit provides a few `ImageSizer`s out of the box:

- `AspectScaleDownByWidth`: This image sizer will scale the image down to fit the line width, preserving the aspect ratio
- `AspectScaleDownByHeight`: This image sizer will scale the image down to the fit the line height, preserving the aspect ration of the image
- `DefaultImageSizer`: This image sizer does nothing, and passes through the natural image size

