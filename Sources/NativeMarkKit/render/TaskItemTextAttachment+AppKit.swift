import Foundation
#if canImport(AppKit)
import AppKit

final class TaskItemTextAttachmentCell: NSTextAttachmentCell {
    private lazy var checkbox: NSButton = {
        let button = NSButton(frame: .zero)
        button.setButtonType(.switch)
        button.title = ""
        button.isEnabled = false
        button.sizeToFit()
        return button
    }()
    
    init(isChecked: Bool) {
        super.init()
        checkbox.state = isChecked ? .on : .off
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(withFrame cellFrame: NSRect, in controlView: NSView?) {
        NSGraphicsContext.saveGraphicsState()
        if let context = NSGraphicsContext.current?.cgContext {
            context.translateBy(x: cellFrame.minX, y: cellFrame.minY)
        }
        checkbox.draw(checkbox.bounds)
        
        NSGraphicsContext.restoreGraphicsState()
    }
    
    override func cellFrame(for textContainer: NSTextContainer, proposedLineFragment lineFrag: NSRect, glyphPosition position: NSPoint, characterIndex charIndex: Int) -> NSRect {
        let checkboxSize = checkbox.sizeThatFits(lineFrag.size)
        return CGRect(x: 0, y: 0, width: checkboxSize.width, height: checkboxSize.height)
    }
}

final class TaskItemTextAttachment: NSTextAttachment {
    init(isChecked: Bool) {
        super.init(data: nil, ofType: nil)
        self.attachmentCell = TaskItemTextAttachmentCell(isChecked: isChecked)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
#endif
