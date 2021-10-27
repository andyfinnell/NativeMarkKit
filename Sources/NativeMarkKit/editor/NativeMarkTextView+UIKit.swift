import Foundation
#if canImport(UIKit)
import UIKit

public final class NativeMarkTextView: UITextView {
    private let editorTextStorage: HighlighterTextStorage
    private let editorLayoutManager: NSLayoutManager
    private let editorContainer: NSTextContainer
    private var keyboardShowObserver: AnyObject?
    private var keyboardHideObserver: AnyObject?
    private var savedContentInsets: UIEdgeInsets?
    
    public var styleSheet: StyleSheet {
        get { editorTextStorage.styleSheet }
        set { editorTextStorage.styleSheet = newValue }
    }
    
    public var nativeMark: String {
        editorTextStorage.string
    }
    
    public override var textStorage: NSTextStorage {
        editorTextStorage
    }

    public override var layoutManager: NSLayoutManager {
        editorLayoutManager
    }
    
    public init(nativeMark: String, styleSheet: StyleSheet = .sourceCode) {
        let (editorTextStorage, editorLayoutManager, editorContainer) = Self.makeTextSystem(nativeMark: nativeMark, styleSheet: styleSheet)

        self.editorTextStorage = editorTextStorage
        self.editorContainer = editorContainer
        self.editorLayoutManager = editorLayoutManager
        super.init(frame: .zero, textContainer: editorContainer)
        
        commonInit()
    }
        
    required init?(coder: NSCoder) {
        let (editorTextStorage, editorLayoutManager, editorContainer) = Self.makeTextSystem(nativeMark: "", styleSheet: .sourceCode)

        self.editorTextStorage = editorTextStorage
        self.editorContainer = editorContainer
        self.editorLayoutManager = editorLayoutManager

        super.init(frame: .zero, textContainer: editorContainer)
        
        commonInit()
    }
    
    deinit {
        if let observer = keyboardShowObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        if let observer = keyboardHideObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}

private extension NativeMarkTextView {
    static func makeTextSystem(nativeMark: String, styleSheet: StyleSheet) -> (HighlighterTextStorage, NSLayoutManager, NSTextContainer) {
        let editorTextStorage = HighlighterTextStorage(editableNativeMark: nativeMark, styleSheet: styleSheet)
        let editorLayoutManager = NSLayoutManager()
        let editorContainer = NSTextContainer()
        editorContainer.widthTracksTextView = true
        editorLayoutManager.addTextContainer(editorContainer)
        editorTextStorage.addLayoutManager(editorLayoutManager)
        return (editorTextStorage, editorLayoutManager, editorContainer)
    }
    
    func commonInit() {
        keyboardShowObserver = NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification,
                                               object: nil,
                                               queue: .main) { [weak self] notification in
            self?.keyboardDidShow(notification)
        }

        keyboardHideObserver = NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification,
                                               object: nil,
                                               queue: .main) { [weak self] notification in
            self?.keyboardDidHide(notification)
        }
    }
    
    func keyboardDidShow(_ notification: Notification) {
        guard let endFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        savedContentInsets = contentInset
        self.contentInset = UIEdgeInsets(top: contentInset.top,
                                         left: contentInset.left,
                                         bottom: contentInset.bottom + endFrame.height,
                                         right: contentInset.right)
    }
    
    func keyboardDidHide(_ notification: Notification) {
        guard let savedContentInsets = savedContentInsets else {
            return
        }
        contentInset = savedContentInsets
        self.savedContentInsets = nil
    }
}
#endif
