# NativeMarkKit
![Tests](https://github.com/andyfinnell/NativeMarkKit/workflows/Tests/badge.svg) [![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)

NativeMark is a flavor of Markdown designed to be rendered by native apps (i.e. it compiles down to native types, not HTML). Specifically, it implements the [CommonMark spec](https://spec.commonmark.org/0.29/) with the significant exception of raw HTML tags. NativeMark will treat raw HTML tags as plain text. It also supports some of Github Flavored Markdown's extensions, such as strikethrough.

The goal of NativeMark is to provide a simple, intuitive way to create styled text in native apps. NativeMarkKit is an implementation of NativeMark for macOS, iOS, and tvOS. NativeMarkKit supports dark mode, dynamic type, and SwiftUI where available.

## Requirements

- Swift 5.1 or greater
- iOS/tvOS 9 or greater OR macOS 10.11 or greater

## Installation

Currently, NativeMarkKit is only available as a Swift Package.

### ...using a Package.swift file

Open the Package.swift file and edit it:

1. Add NativeMarkKit repo to the `dependencies` array.
1. Add NativeMarkKit as a dependency of the target that will use it

```Swift
// swift-tools-version:5.1

import PackageDescription

let package = Package(
  // ...snip...
  dependencies: [
    .package(url: "https://github.com/andyfinnell/NativeMarkKit.git", from: "2.0.0")
  ],
  targets: [
    .target(name: "MyTarget", dependencies: ["NativeMarkKit"])
  ]
)
```

Then build to pull down the dependencies:

```Bash
$ swift build
```

### ...using Xcode

Use the Swift Packages tab on the project to add NativeMarkKit:

1. Open the Xcode workspace or project that you want to add NativeMarkKit to
1. In the file browser, select the project to show the list of projects/targets on the right
1. In the list of projects/targets on the right, select the project
1. Select the "Swift Packages" tab
1. Click on the "+" button to add a package
1. In the "Choose Package Repository" sheet, search for  "https://github.com/andyfinnell/NativeMarkKit.git"
1. Click "Next"
1. Choose the version rule you want
1. Click "Next"
1. Choose the target you want to add NativeMarkKit to
1. Click "Finish"

## Usage 

### ...with views

The easiest way to use NativeMarkKit is to use `NativeMarkLabel`:

```Swift
import NativeMarkKit

let label = NativeMarkLabel(nativeMark: "**Hello**, _world_!")

// Assuming myView is an NSView or UIView
myView.addSubview(label)
```

### ...with SwiftUI

NativeMarkKit has a basic SwiftUI wrapper around `NativeMarkLabel` called `NativeMarkText`:

```Swift
import SwiftUI
import NativeMarkKit

struct ContentView: View {
    var body: some View {
         NativeMarkText("**Hello**, _world_!")
    }
}
```

### ...styling

NativeMarkKit provides a style sheet data structure so NativeMark can be customized to match the styling of the app. By default, `NativeMarkLabel` and `NativeMarkText` use the `.default` `StyleSheet` to control how NativeMark is rendered. You can modify `.default` to create a global, default style sheet, or you can `.duplicate()` `.default` to create a one off style sheet for a specific use case.

For example, if you wanted links to use a brand color, you could mutate the `.default` `StyleSheet`:

```Swift
StyleSheet.default.mutate(inline: [
    .link: [
        .textColor(.purple)
    ]
])
```

The above code would cause all NativeMark text using the `.default` style sheet to render links in purple.

If you only wanted to do this for a specific `NativeMarkLabel` (or `NativeMarkText`) you can `.duplicate()` `.default` and pass in the new style sheet to the labels that want it.

```Swift
let purpleLinksStyleSheet = StyleSheet.default.duplicate().mutate(inline: [
    .link: [
        .textColor(.purple)
    ]
])
```

Then when the `NativeMarkLabel` is created:

```Swift
import NativeMarkKit

let label = NativeMarkLabel(nativeMark: "**Hello**, [Apple](https://www.apple.com)!", styleSheet: purpleLinksStyleSheet)

```

### ...links

By default NativeMarkKit will open links in the default browser when they are clicked/tapped on. If you want to provide custom behavior instead, you can provide a closure to the `NativeMarkLabel`.

```Swift
import NativeMarkKit

let label = NativeMarkLabel(nativeMark: "**Hello**, [Apple](https://www.apple.com)!")
label.onOpenLink = { url in
    // your custom code here
    print("Opening \(url)")
}
```

## Documentation

More [documentation](Documentation).

## Acknowledgements

The NativeMarkKit project would like to acknowledge the work of the [CommonMark](https://commonmark.org/) project to document a standardized flavor of Markdown. NativeMarkKit's front end parsing is based on [CommonMark's parsing strategy](https://spec.commonmark.org/0.29/#appendix-a-parsing-strategy) and the reference implementation [CommonMark.js](https://github.com/commonmark/commonmark.js). Additionally, this project derives its suite of parsing tests from [CommonMark's specs](https://spec.commonmark.org/0.29/spec.json).

For Github Flavored Markdown extensions the [Github Flavored Markdown Spec](https://github.github.com/gfm/) was used.
