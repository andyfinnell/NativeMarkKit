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
        XCTAssert(testCase.isPassing(for: self, record: true))
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
}
