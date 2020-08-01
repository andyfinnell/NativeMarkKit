import Foundation

public final class StyleSheet {
    private var blockStyles: [BlockStyleSelector: [BlockStyle]]
    private var inlineStyles: [InlineStyleSelector: [InlineStyle]]
    
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
    
    public func duplicate() -> StyleSheet {
        StyleSheet(blockStyles, inlineStyles)
    }
    
    public func mutate(_ overrideBlockStyles: [BlockStyleSelector: [BlockStyle]] = [:], _ overrideInlineStyles: [InlineStyleSelector: [InlineStyle]] = [:]) -> StyleSheet {
        for (blockSelector, blockStylesForSelector) in overrideBlockStyles {
            let existingStyles = blockStyles[blockSelector] ?? []
            blockStyles[blockSelector] = existingStyles + blockStylesForSelector
        }
        
        for (inlineSelector, inlineStylesForSelector) in overrideInlineStyles {
            let existingStyles = inlineStyles[inlineSelector] ?? []
            inlineStyles[inlineSelector] = existingStyles + inlineStylesForSelector
        }
        
        return self
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
            .heading(level: 1): [
                .textStyle(.largeTitle),
                .lineHeightMultiple(1.5)
            ],
            .heading(level: 2): [
                .textStyle(.title1),
                .lineHeightMultiple(1.5)
            ],
            .heading(level: 3): [
                .textStyle(.title2),
                .lineHeightMultiple(1.5)
            ],
            .heading(level: 4): [
                .textStyle(.title3),
                .lineHeightMultiple(1.5)
            ],
            .heading(level: 5): [
                .textStyle(.title3),
                .lineHeightMultiple(1.5)
            ],
            .heading(level: 6): [
                .textStyle(.title3),
                .lineHeightMultiple(1.5)
            ],
            .paragraph: [
                .firstLineHeadIndent(0.pt),
                .paragraphSpacingBefore(0.5.em),
                .paragraphSpacingAfter(0.5.em),
            ],
            .codeBlock: [
                .textStyle(.code),
                .headIndent(1.em),
                .backgroundColor(.lightGray)
            ],
            .blockQuote: [
                .textColor(.veryDarkGray),
                .paragraphSpacingBefore(0.5.em),
                .paragraphSpacingAfter(0.5.em),
                .tailIndent(-1.em),
                .backgroundBorder(width: 8, color: .lightGray, sides: .left)
            ],
            .list(isTight: true): [
                .firstLineHeadIndent(0.5.em),
                .orderedListMarker(.lowercaseRoman, separator: "."),
                .unorderedListMarker(.check),
                .paragraphSpacingBefore(0.0.em),
                .paragraphSpacingAfter(0.0.em),
            ],
            .list(isTight: false): [
                .firstLineHeadIndent(0.5.em),
                .orderedListMarker(.lowercaseRoman, separator: "."),
                .unorderedListMarker(.check),
                .paragraphSpacingBefore(0.5.em),
                .paragraphSpacingAfter(0.5.em),
            ],
            .thematicBreak: [
                .thematicBreak(thickness: 1, color: .veryLightGray),
            ]
        ],
        [
            .emphasis: [
                .fontTraits(.italic)
            ],
            .strong: [
                .fontWeight(.bold)
            ],
            .code: [
                .textStyle(.code),
                .backgroundColor(.lightGray)
            ]
        ]
    )
}
