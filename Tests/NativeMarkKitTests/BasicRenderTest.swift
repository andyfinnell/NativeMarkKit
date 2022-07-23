import Foundation
import XCTest
import NativeMarkKit
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

#if false // TODO: have to turn these off because GitHub actions are stuck on Catalina
final class BasicRenderTest: XCTestCase {
    override func setUp() {
        super.setUp()
        
        // Force rendering to happen in light mode
        if #available(OSX 10.14, *) {
            #if canImport(AppKit)
            NSApplication.shared.appearance = NSAppearance(named: .aqua)
            #endif
        }
        
        if #available(iOS 13.0, tvOS 13.0, *) {
            #if canImport(UIKit)
            for window in UIApplication.shared.windows {
                window.overrideUserInterfaceStyle = .light
            }
            #endif
        }
    }
    
    func testHelloWorld() {
        let testCase = RenderTestCase(name: "HelloWorld",
                                      nativeMark: "**Hello**, _world_!",
                                      styleSheet: .default,
                                      width: 320)
        XCTAssert(testCase.isPassing(for: self))
    }

    func testHelloUniverse() {
        let testCase = RenderTestCase(name: "HelloUniverse",
                                      nativeMark: "**Hello**, ~~world~~_universe_!",
                                      styleSheet: .default,
                                      width: 320)
        XCTAssert(testCase.isPassing(for: self))
    }

    func testSimpleTaskList() {
        let style = StyleSheet.default.duplicate().mutate(
                block: [
                    .document: [
                        .textStyle(.body),
                    ],
                ])

        let testCase = RenderTestCase(name: "SimpleTaskList",
                                      nativeMark: "- [ ] absolutely\n- [x] bananas\n- [X] cream\n",
                                      styleSheet: style,
                                      width: 320)
        XCTAssert(testCase.isPassing(for: self))
    }

    func testHelloWorldWithCustomFont() {
        let style = StyleSheet.default.duplicate().mutate(
                block: [
                    .document: [
                        .textStyle(.custom(name: .custom("Avenir-Medium"), size: .fixed(18))),
                        .backgroundColor(.white),
                        .textColor(.black)
                    ],
                ])
        let testCase = RenderTestCase(name: "HelloWorldWithCustomFont",
                                      nativeMark: "**Hello**, _world_!",
                                      styleSheet: style,
                                      width: 320)
        XCTAssert(testCase.isPassing(for: self))
    }

    func testHelloWorldWithCustomFontTake2() {
        let style = StyleSheet.default.duplicate().mutate(
                block: [
                    .document: [
                        .textStyle(.custom(name: .custom("Avenir-Roman"), size: .fixed(19))),
                        .backgroundColor(.white),
                        .textColor(.black)
                    ],
                ])
        let testCase = RenderTestCase(name: "HelloWorldWithCustomFontTakeTwo",
                                      nativeMark: "Avenir Avenir Avenir Avenir",
                                      styleSheet: style,
                                      width: 320)
        XCTAssert(testCase.isPassing(for: self))
    }

    func testCustomFontsWithBoldAndItalic() {
        let style = StyleSheet.default.duplicate().mutate(
                block: [
                    .document: [
                        .textStyle(.custom(name: .custom("Avenir-Medium"), size: .fixed(19))),
                        .backgroundColor(.white),
                        .textColor(.black)
                    ],
                ])
        let nativeMark = """
            1 -- normal
            
            2 -- *italic*
            
            3 -- **bold**
            
            4 -- ***bold & italic***
            
            5 -- **bold -- *bold & italic***
            
            6 -- *italic -- **italic & bold***
            """

        let testCase = RenderTestCase(name: "CustomFontsWithBoldAndItalic",
                                      nativeMark: nativeMark,
                                      styleSheet: style,
                                      width: 320)
        XCTAssert(testCase.isPassing(for: self))
    }
    
    func testParagraphs() {
        let nativeMark = """
This is the first
paragraph. It should continue
to wrap naturally despite this
soft line breaks. I wish I could
spell. This needs to be long
enough it's going to wrap during
the test render.

This is the next paragraph. It is
not as good as the first, but it's
trying its best. It will surely get
better with time. This one needs to
be long enough to wrap lines as well.

I'll also add a third paragraph for
good measure. I wonder what it'll say?
Who knows. It just needs to wrap a bit
to have the desired effect.
"""
        
        let testCase = RenderTestCase(name: "Paragraphs",
                                      nativeMark: nativeMark,
                                      styleSheet: .default,
                                      width: 320)
        XCTAssert(testCase.isPassing(for: self))
    }
    
    func testRightAlignment() {
        let nativeMark = """
This is the first
paragraph. It should continue
to wrap naturally despite this
soft line breaks. I wish I could
spell. This needs to be long
enough it's going to wrap during
the test render.
"""
        
        let styleSheet = StyleSheet.default.duplicate().mutate(block: [
            .paragraph: [
                .alignment(.right)
            ]
        ])
        let testCase = RenderTestCase(name: "RightAlignment",
                                      nativeMark: nativeMark,
                                      styleSheet: styleSheet,
                                      width: 320)
        XCTAssert(testCase.isPassing(for: self))
    }
    
    func testLineHeight() {
        let nativeMark = """
This is the first
paragraph. It should continue
to wrap naturally despite this
soft line breaks. I wish I could
spell. This needs to be long
enough it's going to wrap during
the test render.

This is the next paragraph. It is
not as good as the first, but it's
trying its best. It will surely get
better with time. This one needs to
be long enough to wrap lines as well.

I'll also add a third paragraph for
good measure. I wonder what it'll say?
Who knows. It just needs to wrap a bit
to have the desired effect.
"""

        let styleSheet = StyleSheet.default.duplicate().mutate(block: [
            .paragraph: [
                .lineHeightMultiple(1.5)
            ]
        ])
        let testCase = RenderTestCase(name: "LineHeight",
                                      nativeMark: nativeMark,
                                      styleSheet: styleSheet,
                                      width: 320)
        XCTAssert(testCase.isPassing(for: self))
    }

    func testLineSpacing() {
        let nativeMark = """
This is the first
paragraph. It should continue
to wrap naturally despite this
soft line breaks. I wish I could
spell. This needs to be long
enough it's going to wrap during
the test render.

This is the next paragraph. It is
not as good as the first, but it's
trying its best. It will surely get
better with time. This one needs to
be long enough to wrap lines as well.

I'll also add a third paragraph for
good measure. I wonder what it'll say?
Who knows. It just needs to wrap a bit
to have the desired effect.
"""

        let styleSheet = StyleSheet.default.duplicate().mutate(block: [
            .paragraph: [
                .lineSpacing(0.5.em)
            ]
        ])
        let testCase = RenderTestCase(name: "LineSpacing",
                                      nativeMark: nativeMark,
                                      styleSheet: styleSheet,
                                      width: 320)
        XCTAssert(testCase.isPassing(for: self))
    }

    func testParagraphIndents() {
        let nativeMark = """
This is the first
paragraph. It should continue
to wrap naturally despite this
soft line breaks. I wish I could
spell. This needs to be long
enough it's going to wrap during
the test render.

This is the next paragraph. It is
not as good as the first, but it's
trying its best. It will surely get
better with time. This one needs to
be long enough to wrap lines as well.

I'll also add a third paragraph for
good measure. I wonder what it'll say?
Who knows. It just needs to wrap a bit
to have the desired effect.
"""

        let styleSheet = StyleSheet.default.duplicate().mutate(block: [
            .paragraph: [
                .firstLineHeadIndent(1.em),
                .headIndent(0.5.em),
                .tailIndent(-0.5.em)
            ]
        ])
        let testCase = RenderTestCase(name: "ParagraphIndents",
                                      nativeMark: nativeMark,
                                      styleSheet: styleSheet,
                                      width: 320)
        XCTAssert(testCase.isPassing(for: self))
    }

    func testBasicInlineStyles() {
        let styleSheet = StyleSheet.default.duplicate().mutate(inline: [
            .emphasis: [
                .strikethrough(.single)
            ],
            .strong: [
                .underline(.single, color: .blue),
                .kerning(0.2.em)
            ],
            .code: [
                .backgroundColor(.lightGray),
                .textColor(.purple)
            ]
        ])

        let testCase = RenderTestCase(name: "BasicInlineStyles",
                                      nativeMark: "**Hello**, _world_ from `NativeMarkKit`",
                                      styleSheet: styleSheet,
                                      width: 320)
        XCTAssert(testCase.isPassing(for: self))
    }
    
    
    func testHeadersAndParagraphs() {
        let nativeMark = """
# My Document

This is the _beginning_ of the document. It's
a paragraph, because reasons. It's not yet the
**end** of the document, but maybe only of the
paragraph.

## Subheading 1

The heading above this is smaller for reasons. Those reasons
should not be confused with these other reasons that I don't
know about.

I should probably have at least one section with more than
one paragraph. That might be a better test case that just
a single paragraph section. Words, words, words.

### Headings get smaller with time

And now for something completely different.

#### Out of ideas

I need more paragraphs of text to work with.
This isn't as easy as I thought it would be.
I need more coffee.

"""
        
        let testCase = RenderTestCase(name: "HeadingsAndParagraphs",
                                      nativeMark: nativeMark,
                                      styleSheet: .default,
                                      width: 320)
        XCTAssert(testCase.isPassing(for: self))
    }
    
    func testTightOrderedList() {
        let nativeMark = """
# Ordered lists

Let's see if we can make tight ordered lists
look correct.

1. First things, first
1. Then the second
1. Third should be here, and I need one that will wrap lines so I can see how that looks.
Can I make this wrap even more? The world may never know. I'm not sure how to make
tab stops work cross lines.
    - One
    - Two
    - The third one is always the longest. I don't know why, but there you have it
    - Four
1. And done.

Add a paragraph after the list just to see
what it looks like.
"""
        
        let testCase = RenderTestCase(name: "TightOrderedList",
                                      nativeMark: nativeMark,
                                      styleSheet: .default,
                                      width: 320)
        XCTAssert(testCase.isPassing(for: self))

    }
    
    func testTightOrderedListWithCustomStyling() {
        let nativeMark = """
# Ordered lists

Let's see if we can make tight ordered lists
look correct.

1. First things, first
1. Then the second
1. Third should be here, and I need one that will wrap lines so I can see how that looks.
Can I make this wrap even more? The world may never know. I'm not sure how to make
tab stops work cross lines.
    - One
    - Two
    - The third one is always the longest. I don't know why, but there you have it
    - Four
1. And done.

Add a paragraph after the list just to see
what it looks like.
"""
        let styleSheet = StyleSheet.default.duplicate().mutate(block: [
            .list(isTight: true): [
                .blockMargin(Margin(left: 0.25.em, right: 0.25.em, top: 0.25.em, bottom: 0.25.em)),
                .blockPadding(Padding(left: 0.5.em, right: 0.5.em, top: 0.5.em, bottom: 0.5.em)),
                .blockBorder(Border(shape: .roundedRect(cornerRadius: 3), width: 1, color: .adaptableTextColor)),
                .blockBackground(.adaptableCodeBackgroundColor),
                .backgroundColor(.adaptableCodeBackgroundColor)
            ]
        ])
        let testCase = RenderTestCase(name: "TightOrderedListWithCustomStyling",
                                      nativeMark: nativeMark,
                                      styleSheet: styleSheet,
                                      width: 320)
        XCTAssert(testCase.isPassing(for: self))
    }

    func testTightOrderedListWithCustomItemStyling() {
        let nativeMark = """
# Ordered lists

Let's see if we can make tight ordered lists
look correct.

1. First things, first
1. Then the second
1. Third should be here, and I need one that will wrap lines so I can see how that looks.
Can I make this wrap even more? The world may never know. I'm not sure how to make
tab stops work cross lines.
    - One
    - Two
    - The third one is always the longest. I don't know why, but there you have it
    - Four
1. And done.

Add a paragraph after the list just to see
what it looks like.
"""
        let styleSheet = StyleSheet.default.duplicate().mutate(block: [
            .item: [
                .blockMargin(Margin(left: 0.25.em, right: 0.25.em, top: 0.25.em, bottom: 0.25.em)),
                .blockPadding(Padding(left: 0.5.em, right: 0.5.em, top: 0.5.em, bottom: 0.5.em)),
                .blockBorder(Border(shape: .roundedRect(cornerRadius: 3), width: 1, color: .adaptableTextColor)),
                .blockBackground(.adaptableCodeBackgroundColor),
                .backgroundColor(.adaptableCodeBackgroundColor)
            ]
        ])
        let testCase = RenderTestCase(name: "TightOrderedListWithCustomItemStyling",
                                      nativeMark: nativeMark,
                                      styleSheet: styleSheet,
                                      width: 320)
        XCTAssert(testCase.isPassing(for: self))
    }

    func testLowercaseAlphaOrderedList() {
        let nativeMark = """
Let's see if we can make ordered lists
look correct.

1. First things, first
1. Then the second
1. Third should be here, and I need one that will wrap lines so I can see how that looks.
1. And done.
"""
        let styleSheet = StyleSheet.default.duplicate().mutate(block: [
            .list(isTight: true): [
                .orderedListMarker(.lowercaseAlpha, suffix: ")")
            ]
        ])
        let testCase = RenderTestCase(name: "LowercaseAlphaOrderedList",
                                      nativeMark: nativeMark,
                                      styleSheet: styleSheet,
                                      width: 320)
        XCTAssert(testCase.isPassing(for: self))
    }

    func testLowercaseHexadecimalOrderedList() {
        let nativeMark = """
Let's see if we can make ordered lists
look correct.

1. First things, first
1. Then the second
1. Third should be here, and I need one that will wrap lines so I can see how that looks.
1. four
1. five
1. six
1. seven
1. eight
1. nine
1. ten
1. eleven
1. twelve
1. thirteen
1. fourteen
1. fifteen
1. sixteen
1. seventeen
"""
        let styleSheet = StyleSheet.default.duplicate().mutate(block: [
            .list(isTight: true): [
                .orderedListMarker(.lowercaseHexadecimal, suffix: ")")
            ]
        ])
        let testCase = RenderTestCase(name: "LowercaseHexadecimalOrderedList",
                                      nativeMark: nativeMark,
                                      styleSheet: styleSheet,
                                      width: 320)
        XCTAssert(testCase.isPassing(for: self))
    }

    func testLowercaseRomanOrderedList() {
        let nativeMark = """
Let's see if we can make ordered lists
look correct.

1. First things, first
1. Then the second
1. Third should be here, and I need one that will wrap lines so I can see how that looks.
1. four
1. five
1. six
1. seven
1. eight
1. nine
1. ten
"""
        let styleSheet = StyleSheet.default.duplicate().mutate(block: [
            .list(isTight: true): [
                .orderedListMarker(.lowercaseRoman, suffix: ".")
            ]
        ])
        let testCase = RenderTestCase(name: "LowercaseRomanOrderedList",
                                      nativeMark: nativeMark,
                                      styleSheet: styleSheet,
                                      width: 320)
        XCTAssert(testCase.isPassing(for: self))
    }

    func testOctalOrderedList() {
        let nativeMark = """
Let's see if we can make ordered lists
look correct.

1. First things, first
1. Then the second
1. Third should be here, and I need one that will wrap lines so I can see how that looks.
1. four
1. five
1. six
1. seven
1. eight
1. nine
1. ten
"""
        let styleSheet = StyleSheet.default.duplicate().mutate(block: [
            .list(isTight: true): [
                .orderedListMarker(.octal, prefix: "(", suffix: ")")
            ]
        ])
        let testCase = RenderTestCase(name: "OctalOrderedList",
                                      nativeMark: nativeMark,
                                      styleSheet: styleSheet,
                                      width: 320)
        XCTAssert(testCase.isPassing(for: self))
    }

    func testUppercaseAlphaOrderedList() {
        let nativeMark = """
Let's see if we can make ordered lists
look correct.

1. First things, first
1. Then the second
1. Third should be here, and I need one that will wrap lines so I can see how that looks.
1. And done.
"""
        let styleSheet = StyleSheet.default.duplicate().mutate(block: [
            .list(isTight: true): [
                .orderedListMarker(.uppercaseAlpha, suffix: ")")
            ]
        ])
        let testCase = RenderTestCase(name: "UppercaseAlphaOrderedList",
                                      nativeMark: nativeMark,
                                      styleSheet: styleSheet,
                                      width: 320)
        XCTAssert(testCase.isPassing(for: self))
    }

    func testUppercaseHexadecimalOrderedList() {
        let nativeMark = """
Let's see if we can make ordered lists
look correct.

1. First things, first
1. Then the second
1. Third should be here, and I need one that will wrap lines so I can see how that looks.
1. four
1. five
1. six
1. seven
1. eight
1. nine
1. ten
1. eleven
1. twelve
1. thirteen
1. fourteen
1. fifteen
1. sixteen
1. seventeen
"""
        let styleSheet = StyleSheet.default.duplicate().mutate(block: [
            .list(isTight: true): [
                .orderedListMarker(.uppercaseHexadecimal, suffix: ")")
            ]
        ])
        let testCase = RenderTestCase(name: "UppercaseHexadecimalOrderedList",
                                      nativeMark: nativeMark,
                                      styleSheet: styleSheet,
                                      width: 320)
        XCTAssert(testCase.isPassing(for: self))
    }

    func testUppercaseRomanOrderedList() {
        let nativeMark = """
Let's see if we can make ordered lists
look correct.

1. First things, first
1. Then the second
1. Third should be here, and I need one that will wrap lines so I can see how that looks.
1. four
1. five
1. six
1. seven
1. eight
1. nine
1. ten
"""
        let styleSheet = StyleSheet.default.duplicate().mutate(block: [
            .list(isTight: true): [
                .orderedListMarker(.uppercaseRoman, suffix: ".")
            ]
        ])
        let testCase = RenderTestCase(name: "UppercaseRomanOrderedList",
                                      nativeMark: nativeMark,
                                      styleSheet: styleSheet,
                                      width: 320)
        XCTAssert(testCase.isPassing(for: self))
    }

    func testLooseOrderedList() {
        let nativeMark = """
# Ordered lists

Let's see if we can make tight ordered lists
look correct.

1. First things, first

1. Then the second

1. Third should be here, and I need one that will wrap lines so I can see how that looks.
Can I make this wrap even more? The world may never know. I'm not sure how to make
tab stops work cross lines.

    - One

    - Two

    - The third one is always the longest. I don't know why, but there you have it

    - Four

1. And done.

Add a paragraph after the list just to see
what it looks like.
"""
        
        let testCase = RenderTestCase(name: "LooseOrderedList",
                                      nativeMark: nativeMark,
                                      styleSheet: .default,
                                      width: 320)
        XCTAssert(testCase.isPassing(for: self))
    }

    func testBoxUnorderedList() {
        let nativeMark = """
Let's see if we can make unordered lists
look correct.

- One
- Two
- Three
- Four
"""
        let styleSheet = StyleSheet.default.duplicate().mutate(block: [
            .list(isTight: true): [
                .unorderedListMarker(.box)
            ]
        ])

        let testCase = RenderTestCase(name: "BoxUnorderedList",
                                      nativeMark: nativeMark,
                                      styleSheet: styleSheet,
                                      width: 320)
        XCTAssert(testCase.isPassing(for: self))
    }

    func testBulletUnorderedList() {
        let nativeMark = """
Let's see if we can make unordered lists
look correct.

* One
* Two
* Three
* Four
"""
        let styleSheet = StyleSheet.default.duplicate().mutate(block: [
            .list(isTight: true): [
                .unorderedListMarker(.bullet)
            ]
        ])

        let testCase = RenderTestCase(name: "BulletedUnorderedList",
                                      nativeMark: nativeMark,
                                      styleSheet: styleSheet,
                                      width: 320)
        XCTAssert(testCase.isPassing(for: self))
    }

    func testCheckUnorderedList() {
        let nativeMark = """
Let's see if we can make unordered lists
look correct.

* One
* Two
* Three
* Four
"""
        let styleSheet = StyleSheet.default.duplicate().mutate(block: [
            .list(isTight: true): [
                .unorderedListMarker(.check)
            ]
        ])

        let testCase = RenderTestCase(name: "CheckUnorderedList",
                                      nativeMark: nativeMark,
                                      styleSheet: styleSheet,
                                      width: 320)
        XCTAssert(testCase.isPassing(for: self))
    }

    func testCircleUnorderedList() {
        let nativeMark = """
Let's see if we can make unordered lists
look correct.

* One
* Two
* Three
* Four
"""
        let styleSheet = StyleSheet.default.duplicate().mutate(block: [
            .list(isTight: true): [
                .unorderedListMarker(.circle)
            ]
        ])

        let testCase = RenderTestCase(name: "CircleUnorderedList",
                                      nativeMark: nativeMark,
                                      styleSheet: styleSheet,
                                      width: 320)
        XCTAssert(testCase.isPassing(for: self))
    }

    func testDiamondUnorderedList() {
        let nativeMark = """
Let's see if we can make unordered lists
look correct.

* One
* Two
* Three
* Four
"""
        let styleSheet = StyleSheet.default.duplicate().mutate(block: [
            .list(isTight: true): [
                .unorderedListMarker(.diamond)
            ]
        ])

        let testCase = RenderTestCase(name: "DiamondUnorderedList",
                                      nativeMark: nativeMark,
                                      styleSheet: styleSheet,
                                      width: 320)
        XCTAssert(testCase.isPassing(for: self))
    }
    
    func testHyphenUnorderedList() {
        let nativeMark = """
Let's see if we can make unordered lists
look correct.

* One
* Two
* Three
* Four
"""
        let styleSheet = StyleSheet.default.duplicate().mutate(block: [
            .list(isTight: true): [
                .unorderedListMarker(.hyphen)
            ]
        ])

        let testCase = RenderTestCase(name: "HyphenUnorderedList",
                                      nativeMark: nativeMark,
                                      styleSheet: styleSheet,
                                      width: 320)
        XCTAssert(testCase.isPassing(for: self))
    }

    func testSquareUnorderedList() {
        let nativeMark = """
Let's see if we can make unordered lists
look correct.

* One
* Two
* Three
* Four
"""
        let styleSheet = StyleSheet.default.duplicate().mutate(block: [
            .list(isTight: true): [
                .unorderedListMarker(.square)
            ]
        ])

        let testCase = RenderTestCase(name: "SquareUnorderedList",
                                      nativeMark: nativeMark,
                                      styleSheet: styleSheet,
                                      width: 320)
        XCTAssert(testCase.isPassing(for: self))
    }

    func testHorizontalRules() {
        let nativeMark = """
I need a break.

---

After the break.
"""

        let testCase = RenderTestCase(name: "HorizontalRules",
                                      nativeMark: nativeMark,
                                      styleSheet: .default,
                                      width: 320)
        XCTAssert(testCase.isPassing(for: self))
    }

    func testBlockQuotes() {
        let nativeMark = """
And now for something completely different.

> This is the place for the best quotes I can think of.
> Which is apparently nothing.
>
> \\- me, just now
>
> List of things
>
> 1. One thing
> 1. Two thing
> 1. Red thing
> 1. Blue thing

And done.
"""
        
        let testCase = RenderTestCase(name: "BlockQuotes",
                                      nativeMark: nativeMark,
                                      styleSheet: .default,
                                      width: 320)
        XCTAssert(testCase.isPassing(for: self))
    }
    
    func testCodes() {
        let nativeMark = """
Let's write some `code` since that's what's next on the list.

```Swift
let shouldI = shouldDoTheThing()

if shouldI {
    doTheThing()
}
```

This is the end of the document. Let's add some code that
has ascenders and descenders: `Legumes`.
"""
        let testCase = RenderTestCase(name: "Codes",
                                      nativeMark: nativeMark,
                                      styleSheet: .default,
                                      width: 320)
        XCTAssert(testCase.isPassing(for: self))
    }
    
    func testImagesAndLinks() {
        let nativeMark = """
#### Headline

Here's a tiny kitten: ![Tiny kitten](http://placekitten.com/g/20/20). It can be
found at [placekitten.com](https://placekitten.com/) which is on the internet.\\
This is a hard break.
"""
        let imageLoader = FakeImageLoader()
        imageLoader.loadImage_stub["http://placekitten.com/g/20/20"] = NativeImage.fixture(size: CGSize(width: 22, height: 22))
        let environment = Environment(imageLoader: imageLoader, imageSizer: DefaultImageSizer())
        let testCase = RenderTestCase(name: "ImagesAndLinks",
                                      nativeMark: nativeMark,
                                      styleSheet: .default,
                                      environment: environment,
                                      width: 320)
        XCTAssert(testCase.isPassing(for: self))

    }
    
    func testTextStyles1() {
        let nativeMark = """
# Body

## Callout

### Caption 1

#### Caption 2

##### Code

###### Footnote

Headline.
"""
        
        let styleSheet = StyleSheet.default.duplicate().mutate(block: [
            .heading(level: 1): [
                .textStyle(.body)
            ],
            .heading(level: 2): [
                .textStyle(.callout)
            ],
            .heading(level: 3): [
                .textStyle(.caption1)
            ],
            .heading(level: 4): [
                .textStyle(.caption2)
            ],
            .heading(level: 5): [
                .textStyle(.code)
            ],
            .heading(level: 6): [
                .textStyle(.footnote)
            ],
            .paragraph: [
                .textStyle(.headline)
            ]
        ])
        let testCase = RenderTestCase(name: "TextStyles1",
                                      nativeMark: nativeMark,
                                      styleSheet: styleSheet,
                                      width: 320)
        XCTAssert(testCase.isPassing(for: self))
    }
    
    func testTextStyles2() {
        let nativeMark = """
# Large Title

## Subheadline

### Title 1

#### Title 2

##### Title 3

###### Helvetica headline

This is a paragraph in 12pt Helvetica.
"""
        
        let styleSheet = StyleSheet.default.duplicate().mutate(block: [
            .heading(level: 1): [
                .textStyle(.largeTitle)
            ],
            .heading(level: 2): [
                .textStyle(.subheadline)
            ],
            .heading(level: 3): [
                .textStyle(.title1)
            ],
            .heading(level: 4): [
                .textStyle(.title2)
            ],
            .heading(level: 5): [
                .textStyle(.title3)
            ],
            .heading(level: 6): [
                .textStyle(.custom(name: .custom("Helvetica"), size: .scaled(to: .headline), traits: .unspecified))
            ],
            .paragraph: [
                .textStyle(.custom(name: .custom("Helvetica"), size: .fixed(12), traits: .bold))
            ]
        ])
        let testCase = RenderTestCase(name: "TextStyles2",
                                      nativeMark: nativeMark,
                                      styleSheet: styleSheet,
                                      width: 320)
        XCTAssert(testCase.isPassing(for: self))
    }
}
#endif
