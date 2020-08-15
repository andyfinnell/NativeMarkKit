import Foundation
#if canImport(UIKit) && canImport(SwiftUI)
import UIKit
import SwiftUI

public struct NativeMarkText: UIViewRepresentable {
    public typealias UIViewType = NativeMarkLabel

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
    
    public func makeUIView(context: Context) -> NativeMarkLabel {
        let label = NativeMarkLabel(nativeMark: nativeMark, styleSheet: styleSheet)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.onOpenLink = onOpenLink
        return label
    }
    
    public func updateUIView(_ nsView: NativeMarkLabel, context: Context) {
        nsView.nativeMark = nativeMark
        nsView.onOpenLink = onOpenLink
    }
}

#endif
