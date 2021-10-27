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
            ],
            .codeBlock: [
                .textStyle(.code),
            ],
            .blockQuote: [
            ],
            .list(isTight: true): [
            ],
            .list(isTight: false): [
            ],
            .thematicBreak: [
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
            ],
            .link: [
                .textColor(.adaptableLinkColor),
                .underline(.single)
            ]
        ]
    )
}
