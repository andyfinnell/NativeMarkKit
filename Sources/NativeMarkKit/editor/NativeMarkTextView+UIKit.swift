import Foundation
#if canImport(UIKit)
import UIKit

public final class NativeMarkTextView: UITextView {
    private let highlighterTextStorage: HighlighterTextStorage
    
    public var styleSheet: StyleSheet {
        get { highlighterTextStorage.styleSheet }
        set { highlighterTextStorage.styleSheet = newValue }
    }
    
    public var nativeMark: String {
        highlighterTextStorage.string
    }
    
    public init(nativeMark: String, styleSheet: StyleSheet = .sourceCode) {
        highlighterTextStorage = HighlighterTextStorage(editableNativeMark: nativeMark, styleSheet: styleSheet)
        super.init(frame: .zero)
        highlighterTextStorage.addLayoutManager(layoutManager)
    }
    
    required init?(coder: NSCoder) {
        highlighterTextStorage = HighlighterTextStorage(editableNativeMark: "", styleSheet: .sourceCode)
        super.init(frame: .zero)
        highlighterTextStorage.addLayoutManager(layoutManager)
    }
}

#endif
