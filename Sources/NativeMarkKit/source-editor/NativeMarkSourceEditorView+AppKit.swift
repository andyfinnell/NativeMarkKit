import Foundation
#if canImport(AppKit)
import AppKit

// TODO: need to implement newline insertion, auto-indent
// TODO: implement bold/italic (others?) to use nativemark
// TODO: verify find, etc work. turn off things that don't
// TODO: implement copy/paste in terms of nativemark
// TODO: drap & drop, particularly urls/files

public final class NativeMarkSourceEditorView: NSTextView {
    private let editorTextStorage: SourceEditorTextStorage
    private let editorLayoutManager = NSLayoutManager()
    private let editorContainer = NSTextContainer()

    public var styleSheet: StyleSheet {
        get { editorTextStorage.styleSheet }
        set { editorTextStorage.styleSheet = newValue }
    }
    
    public var nativeMark: String {
        editorTextStorage.string
    }
    
    public override var textStorage: NSTextStorage? {
        editorTextStorage
    }
    
    public override var layoutManager: NSLayoutManager? {
        editorLayoutManager
    }
    
    public init(nativeMark: String, styleSheet: StyleSheet = .sourceCode) {
        editorTextStorage = SourceEditorTextStorage(editableNativeMark: nativeMark, styleSheet: styleSheet)
        super.init(frame: .zero, textContainer: editorContainer)
        editorLayoutManager.addTextContainer(editorContainer)
        editorTextStorage.addLayoutManager(editorLayoutManager)
        isAutomaticQuoteSubstitutionEnabled = false
    }
        
    required init?(coder: NSCoder) {
        editorTextStorage = SourceEditorTextStorage(editableNativeMark: "", styleSheet: .sourceCode)
        super.init(frame: .zero, textContainer: editorContainer)
        editorLayoutManager.addTextContainer(editorContainer)
        editorTextStorage.addLayoutManager(editorLayoutManager)
        isAutomaticQuoteSubstitutionEnabled = false
    }
    
    public override var intrinsicContentSize: NSSize {
        _ = editorLayoutManager.glyphRange(for: editorContainer)
        let usedRect = editorLayoutManager.usedRect(for: editorContainer).integral.size
        
        return NSSize(width: bounds.width,
                      height: usedRect.height)
    }
    
    public override func didChangeText() {
        super.didChangeText()
        invalidateIntrinsicContentSize()
    }
}

#endif
