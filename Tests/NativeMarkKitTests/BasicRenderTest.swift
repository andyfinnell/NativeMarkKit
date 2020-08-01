import Foundation
import XCTest
import NativeMarkKit

final class BasicRenderTest: XCTestCase {
    func testHelloWorld() {
        let testCase = RenderTestCase(name: "HelloWorld",
                                      nativeMark: "**Hello**, _world_!",
                                      styleSheet: .default,
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
        
        let styleSheet = StyleSheet.default.duplicate().mutate([
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

        let styleSheet = StyleSheet.default.duplicate().mutate([
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

        let styleSheet = StyleSheet.default.duplicate().mutate([
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

        let styleSheet = StyleSheet.default.duplicate().mutate([
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
        let styleSheet = StyleSheet.default.duplicate().mutate([:], [
            .emphasis: [
                .strikethrough(Strikethrough(style: .single, color: nil))
            ],
            .strong: [
                .underline(Underline(style: .single, color: .blue)),
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
}
