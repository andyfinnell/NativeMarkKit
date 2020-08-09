import Foundation
#if canImport(AppKit) && canImport(SwiftUI)
import AppKit
import SwiftUI

public struct NativeMarkText: NSViewRepresentable {
    public typealias NSViewType = NativeMarkLabel

    // TODO: make sure style sheet is customizable
    // TODO: figure out how to make this thing size correctly in SwiftUI
    let nativeMark: String
    let onOpenLink: ((URL) -> Void)?
    let styleSheet: StyleSheet
    
    public init(_ nativeMark: String, styleSheet: StyleSheet = .default, onOpenLink: ((URL) -> Void)? = URLOpener.open) {
        self.nativeMark = nativeMark
        self.onOpenLink = onOpenLink
        self.styleSheet = styleSheet
    }
    
    public func makeNSView(context: Context) -> NativeMarkLabel {
        let label = NativeMarkLabel(nativeMark: nativeMark, styleSheet: styleSheet)
        label.onOpenLink = onOpenLink
        return label
    }
    
    public func updateNSView(_ nsView: NativeMarkLabel, context: Context) {
        nsView.nativeMark = nativeMark
        nsView.onOpenLink = onOpenLink
    }
}

#endif
