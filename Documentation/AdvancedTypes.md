# Advanced types

NativeMarkKit exposes a cluster of types that it uses to implement `NativeMarkLabel` on all platforms. These types are `NativeMarkString`, `NativeMarkStorage`, `NativeMarkLayoutManager`, and `NativeMarkTextContainer`. They roughly correspond to the Cocoa Text System types of `NSMutableAttributedString`, `NSTextStorage`, `NSLayoutManager`, and `NSTextContainer`. They can be used to implement custom views that want to render NativeMark directly. They are experimental, in that they've only been used to implement `NativeMarkLabel` so I'm unsure if they're sufficiently powerful to implement other kinds of views.

## NativeMarkString

To create this type, we need a raw string of NativeMark and a `StyleSheet`. This type will parse the raw NativeMark into an internal representation that can be rendered later.

`NativeMarkString` also provides convenience methods for drawing and measuring its contents. Under the hood, these convenience methods construct `NativeMarkStorage`, `NativeMarkLayoutManager`, and `NativeMarkTextContainer` in order to draw or measure the string. For that reason, they're not that performant, and should only be used for one-off cases.

## NativeMarkStorage

This mutable type wraps a `NativeMarkString`. It can be the data source for multiple `NativeMarkLayoutManager`s. It provides methods for iterating through link metadata in the `NativeMarkString`.

## NativeMarkLayoutManager

This type controls how the NativeMark layout and rendering is done. As such, it provides methods for drawing the various levels of the NativeMark string, as well as methods for converting screen location to indices into the text. It also maintains an array of `NativeMarkTextContainer`s, into which the NativeMark is laid out.

The layout manager also provides a delegate for images. Since images are loaded asynchronously, their frames need to be invalidated by any containing view once the image is loaded. The delegate method provides the necessary hook for the view to know when an area needs to be redrawn.

## NativeMarkTextContainer

Text containers describe the size of an area that the NativeMark will be drawn. Usually, this area corresponds to a view.
