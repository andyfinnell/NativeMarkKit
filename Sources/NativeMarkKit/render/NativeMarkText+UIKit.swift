import Foundation
#if canImport(UIKit) && canImport(SwiftUI)
import UIKit
import SwiftUI

@available(iOS 13.0, *)
public struct NativeMarkText: View {
    @State private var intrinsicContentSize: CGSize = .zero
    let nativeMark: String
    let onOpenLink: ((URL) -> Void)?
    let styleSheet: StyleSheet

    public init(_ nativeMark: String, styleSheet: StyleSheet = .default, onOpenLink: ((URL) -> Void)? = URLOpener.open) {
        self.nativeMark = nativeMark
        self.onOpenLink = onOpenLink
        self.styleSheet = styleSheet
    }

    public var body: some View {
        NativeMarkViewRepresentable(nativeMark: nativeMark,
                                    onOpenLink: onOpenLink,
                                    styleSheet: styleSheet,
                                    intrinsicContentSize: $intrinsicContentSize)
            .frame(height: intrinsicContentSize.height)
    }
    
    private struct NativeMarkViewRepresentable: UIViewRepresentable {
        typealias UIViewType = NativeMarkLabel

        let nativeMark: String
        let onOpenLink: ((URL) -> Void)?
        let styleSheet: StyleSheet
        @Binding var intrinsicContentSize: CGSize
        
        func makeUIView(context: Context) -> NativeMarkLabel {
            let label = NativeMarkLabel(nativeMark: nativeMark, styleSheet: styleSheet)
            label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            label.onOpenLink = onOpenLink
            label.onIntrinsicSizeInvalidated = { [weak label] in
                guard let label = label else { return }
                self.intrinsicContentSize = label.intrinsicContentSize
            }
            updateHugging(label)
            return label
        }
        
        func updateUIView(_ label: NativeMarkLabel, context: Context) {
            label.nativeMark = nativeMark
            label.onOpenLink = onOpenLink
            updateHugging(label)
        }
        
        private func updateHugging(_ label: NativeMarkLabel) {
            let huggingPriority: UILayoutPriority = label.isMultiline ? .defaultLow : .required
            label.setContentHuggingPriority(huggingPriority, for: .horizontal)
        }
    }
}

#endif
