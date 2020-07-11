import Foundation

final class StyleSheet {
    private let blockStyles: [BlockStyleSelector: [BlockStyle]]
    private let inlineStyles: [InlineStyleSelector: [InlineStyle]]
    
    init(_ blockStyles: [BlockStyleSelector: [BlockStyle]], _ inlineStyles: [InlineStyleSelector: [InlineStyle]]) {
        self.blockStyles = blockStyles
        self.inlineStyles = inlineStyles
    }
    
    func styles(for blockSelector: BlockStyleSelector) -> [BlockStyle] {
        blockStyles[blockSelector] ?? []
    }
    
    func styles(for inlineSelector: InlineStyleSelector) -> [InlineStyle] {
        inlineStyles[inlineSelector] ?? []
    }
}
