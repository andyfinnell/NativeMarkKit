import Foundation

// TODO: create a default style sheet
// TODO: create an easy way for library users to override styles in default style sheet

public final class StyleSheet {
    private let blockStyles: [BlockStyleSelector: [BlockStyle]]
    private let inlineStyles: [InlineStyleSelector: [InlineStyle]]
    
    public init(_ blockStyles: [BlockStyleSelector: [BlockStyle]], _ inlineStyles: [InlineStyleSelector: [InlineStyle]]) {
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

public extension StyleSheet {
    static let `default` = StyleSheet(
        [
            .document: [
                .textStyle(.body),
                .backgroundColor(.white),
                .textColor(.black)
            ],
            .heading(level: 1): [.textStyle(.headline)],
            .heading(level: 2): [.textStyle(.subheadline)],
            .heading(level: 3): [.textStyle(.title1)],
            .heading(level: 4): [.textStyle(.title2)],
            .heading(level: 5): [.textStyle(.title3)],
            .heading(level: 6): [.textStyle(.title3)]
        ],
        [.emphasis: [
            .fontTraits(.italic)
            ],
         .strong: [
            .fontWeight(.bold)
            ]]
    )
}
