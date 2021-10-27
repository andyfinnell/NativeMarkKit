import Foundation

public extension StyleSheet {
    static let sourceCode = StyleSheet(
        [
            .document: [
                .textStyle(.body),
                .backgroundColor(.adaptableBackgroundColor),
                .textColor(.adaptableTextColor)
            ],
            .heading(level: 1): [
                .textStyle(.largeTitle),
                .lineHeightMultiple(1.5),
                .textColor(.adaptableHeadingTextColor)
            ],
            .heading(level: 2): [
                .textStyle(.title1),
                .lineHeightMultiple(1.5),
                .textColor(.adaptableHeadingTextColor)
            ],
            .heading(level: 3): [
                .textStyle(.title2),
                .lineHeightMultiple(1.5),
                .textColor(.adaptableHeadingTextColor)
            ],
            .heading(level: 4): [
                .textStyle(.title3),
                .lineHeightMultiple(1.5),
                .textColor(.adaptableHeadingTextColor)
            ],
            .heading(level: 5): [
                .textStyle(.title3),
                .lineHeightMultiple(1.5),
                .textColor(.adaptableHeadingTextColor)
            ],
            .heading(level: 6): [
                .textStyle(.title3),
                .lineHeightMultiple(1.5),
                .textColor(.adaptableHeadingTextColor)
            ],
            .paragraph: [
                .firstLineHeadIndent(0.pt),
            ],
            .codeBlock: [
                .textStyle(.code),
                .textColor(.adaptableCodeTextColor)
            ],
            .blockQuote: [
                .textColor(.adaptableBlockQuoteTextColor)
            ],
            .list(isTight: true): [
            ],
            .list(isTight: false): [
            ],
            .thematicBreak: [
                .textColor(.adaptableSeparatorColor)
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
                .textColor(.adaptableCodeTextColor)
            ],
            .image: [
                .textColor(.adaptableLinkDecorationTextColor),
            ],
            .link: [
                .textColor(.adaptableLinkDecorationTextColor),
            ],
            .linkAlt: [
                .textColor(.adaptableLinkAltTextColor)
            ],
            .linkTitle: [
                .textColor(.adaptableLinkTitleTextColor)
            ],
            .linkUrl: [
                .textColor(.adaptableLinkColor),
                .underline(.single)
            ],
            .linebreak: [
                .textColor(.adaptableLinebreakTextColor)
            ]
        ]
    )
}
