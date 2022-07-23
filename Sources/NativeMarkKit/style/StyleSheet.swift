import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#else
#error("Unsupported platform")
#endif

public final class StyleSheet {
    private var blockStyles: [BlockStyleSelector: [BlockStyle]]
    private var inlineStyles: [InlineStyleSelector: [InlineStyle]]
    
    public init(_ blockStyles: [BlockStyleSelector: [BlockStyle]],
                _ inlineStyles: [InlineStyleSelector: [InlineStyle]]) {
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
    
    public func mutate(block overrideBlockStyles: [BlockStyleSelector: [BlockStyle]] = [:],
                       inline overrideInlineStyles: [InlineStyleSelector: [InlineStyle]] = [:]) -> StyleSheet {
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
                .backgroundColor(.adaptableBackgroundColor),
                .textColor(.adaptableTextColor)
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
                .paragraphSpacingBefore(0.pt),
                .paragraphSpacingAfter(0.pt),
                .blockMargin(.zero),
                .blockBorder(Border(shape: .roundedRect(cornerRadius: 3), width: 1, color: .adaptableCodeBorderColor)),
                .blockPadding(Padding(left: 1.em, right: 1.em, top: 1.em, bottom: 1.em)),
                .blockBackground(.adaptableCodeBackgroundColor),
                .backgroundColor(.adaptableCodeBackgroundColor)
            ],
            .blockQuote: [
                .textColor(.adaptableBlockQuoteTextColor),
                .paragraphSpacingBefore(0.5.em),
                .paragraphSpacingAfter(0.5.em),
                .blockMargin(.zero),
                .blockBorder(Border(shape: .rectangle(sides: .left), width: 8, color: .adaptableBlockQuoteMarginColor)),
                .blockPadding(Padding(left: 1.35.em, right: 1.em, top: 0.em, bottom: 0.em)),
                .blockBackground(nil)
            ],
            .list(isTight: true): [
                .list(),
                .blockMargin(.zero),
                .blockBorder(.none),
                .blockPadding(Padding(left: 0.5.em, right: 0.em, top: 0.em, bottom: 0.em)),
                .blockBackground(nil),
                .orderedListMarker(.lowercaseRoman),
                .unorderedListMarker(.check),
                .paragraphSpacingBefore(0.0.em),
                .paragraphSpacingAfter(0.0.em),
            ],
            .list(isTight: false): [
                .list(),
                .blockMargin(.zero),
                .blockBorder(.none),
                .blockPadding(Padding(left: 0.5.em, right: 0.em, top: 0.em, bottom: 0.em)),
                .blockBackground(nil),
                .orderedListMarker(.lowercaseRoman),
                .unorderedListMarker(.check),
                .paragraphSpacingBefore(0.5.em),
                .paragraphSpacingAfter(0.5.em),
            ],
            .item: [
                .blockMargin(.zero),
                .blockBorder(.none),
                .blockPadding(Padding(left: 0.em, right: 0.em, top: 0.em, bottom: 0.em)),
                .blockBackground(nil),
            ],
            .thematicBreak: [
                .thematicBreak(thickness: 1, color: .adaptableSeparatorColor),
            ]
        ],
        [
            .emphasis: [
                .fontTraits(.italic)
            ],
            .strong: [
                .fontTraits(.bold)
            ],
            .strikethrough: [
                .strikethrough(.single)
            ],
            .code: [
                .textStyle(.code),
                .inlineBackground()
            ],
            .link: [
                .textColor(.adaptableLinkColor),
                .underline(.single)
            ]
        ]
    )
}
