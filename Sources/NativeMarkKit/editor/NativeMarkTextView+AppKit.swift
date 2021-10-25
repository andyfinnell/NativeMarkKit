import Foundation
#if canImport(AppKit)
import AppKit

public final class NativeMarkTextView: NSTextView {
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
        if let manager = layoutManager {
            highlighterTextStorage.addLayoutManager(manager)
        }
    }
    
    required init?(coder: NSCoder) {
        highlighterTextStorage = HighlighterTextStorage(editableNativeMark: "", styleSheet: .sourceCode)
        super.init(frame: .zero)
        if let manager = layoutManager {
            highlighterTextStorage.addLayoutManager(manager)
        }
    }
}

#endif
