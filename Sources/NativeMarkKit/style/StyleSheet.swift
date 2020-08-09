import Foundation

public final class StyleSheet {
    private var blockStyles: [BlockStyleSelector: [BlockStyle]]
    private var inlineStyles: [InlineStyleSelector: [InlineStyle]]
    private var imageLoader: ImageLoader
    
    public init(_ blockStyles: [BlockStyleSelector: [BlockStyle]], _ inlineStyles: [InlineStyleSelector: [InlineStyle]], imageLoader: ImageLoader = DefaultImageLoader()) {
        self.blockStyles = blockStyles
        self.inlineStyles = inlineStyles
        self.imageLoader = imageLoader
    }
    
    func styles(for blockSelector: BlockStyleSelector) -> [BlockStyle] {
        blockStyles[blockSelector] ?? []
    }
    
    func styles(for inlineSelector: InlineStyleSelector) -> [InlineStyle] {
        inlineStyles[inlineSelector] ?? []
    }
    
    public func duplicate() -> StyleSheet {
        StyleSheet(blockStyles, inlineStyles, imageLoader: imageLoader)
    }
    
    public func mutate(_ overrideBlockStyles: [BlockStyleSelector: [BlockStyle]] = [:], _ overrideInlineStyles: [InlineStyleSelector: [InlineStyle]] = [:], imageLoader: ImageLoader? = nil) -> StyleSheet {
        for (blockSelector, blockStylesForSelector) in overrideBlockStyles {
            let existingStyles = blockStyles[blockSelector] ?? []
            blockStyles[blockSelector] = existingStyles + blockStylesForSelector
        }
        
        for (inlineSelector, inlineStylesForSelector) in overrideInlineStyles {
            let existingStyles = inlineStyles[inlineSelector] ?? []
            inlineStyles[inlineSelector] = existingStyles + inlineStylesForSelector
        }
        
        if let imageLoader = imageLoader {
            self.imageLoader = imageLoader
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
                .blockBackground(fillColor: .adaptableCodeBackgroundColor, strokeColor: .adaptableCodeBorderColor, strokeWidth: 1, cornerRadius: 3)
            ],
            .blockQuote: [
                .textColor(.adaptableBlockQuoteTextColor),
                .paragraphSpacingBefore(0.5.em),
                .paragraphSpacingAfter(0.5.em),
                .tailIndent(-1.em),
                .backgroundBorder(width: 8, color: .adaptableBlockQuoteMarginColor, sides: .left)
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
                .thematicBreak(thickness: 1, color: .adaptableSeparatorColor),
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
                .inlineBackground()
            ],
            .link: [
                .textColor(.adaptableLinkColor),
                .underline(Underline(style: .single, color: nil))
            ]
        ]
    )
}

extension StyleSheet: ImageTextAttachmentDelegate {
    func imageTextAttachmentLoadImage(_ urlString: String, completion: @escaping (NativeImage?) -> Void) {
        imageLoader.loadImage(urlString, completion: completion)
    }
}
