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
    private var imageLoader: ImageLoader
    private var imageSizer: ImageSizer
    
    public init(_ blockStyles: [BlockStyleSelector: [BlockStyle]],
                _ inlineStyles: [InlineStyleSelector: [InlineStyle]],
                imageLoader: ImageLoader = DefaultImageLoader(),
                imageSizer: ImageSizer = DefaultImageSizer()) {
        self.blockStyles = blockStyles
        self.inlineStyles = inlineStyles
        self.imageLoader = imageLoader
        self.imageSizer = imageSizer
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
    
    public func mutate(block overrideBlockStyles: [BlockStyleSelector: [BlockStyle]] = [:],
                       inline overrideInlineStyles: [InlineStyleSelector: [InlineStyle]] = [:],
                       imageLoader: ImageLoader? = nil,
                       imageSizer: ImageSizer? = nil) -> StyleSheet {
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
        
        if let imageSizer = imageSizer {
            self.imageSizer = imageSizer
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
                .orderedListMarker(.lowercaseRoman),
                .unorderedListMarker(.check),
                .paragraphSpacingBefore(0.0.em),
                .paragraphSpacingAfter(0.0.em),
            ],
            .list(isTight: false): [
                .firstLineHeadIndent(0.5.em),
                .orderedListMarker(.lowercaseRoman),
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
                .fontTraits(.bold)
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

extension StyleSheet: ImageTextAttachmentDelegate {
    func imageTextAttachmentResize(_ urlString: String?, image: NativeImage, lineFragment: CGRect) -> CGSize {
        imageSizer.imageSize(urlString, image: image, lineFragment: lineFragment)
    }
    
    func imageTextAttachmentLoadImage(_ urlString: String, completion: @escaping (NativeImage?) -> Void) {
        imageLoader.loadImage(urlString, completion: completion)
    }
}
