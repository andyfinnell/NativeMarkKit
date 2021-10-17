import Foundation
import XCTest
@testable import NativeMarkKit

final class TabsTest: XCTestCase {
    func testCase1() throws {
        // HTML: <pre><code>foo\tbaz\t\tbim\n</code></pre>\n
        /* Markdown
         foo	baz		bim
         
         */
        XCTAssertEqual(try compile("\tfoo\tbaz\t\tbim\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "", content: "foo\tbaz\t\tbim\n", range: (0, 1)-(1, 0)))
                       ]))
    }
    
    func testCase2() throws {
        // HTML: <pre><code>foo\tbaz\t\tbim\n</code></pre>\n
        /* Markdown
         foo	baz		bim
         
         */
        XCTAssertEqual(try compile("  \tfoo\tbaz\t\tbim\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "", content: "foo\tbaz\t\tbim\n", range: (0, 3)-(1, 0)))
                       ]))
    }
    
    func testCase3() throws {
        // HTML: <pre><code>a\ta\nὐ\ta\n</code></pre>\n
        /* Markdown
         a	a
         ὐ	a
         
         */
        XCTAssertEqual(try compile("    a\ta\n    ὐ\ta\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "", content: "a\ta\nὐ\ta\n", range: (0, 4)-(2, 0)))
                       ]))
    }
    
    func testCase4() throws {
        // HTML: <ul>\n<li>\n<p>foo</p>\n<p>bar</p>\n</li>\n</ul>\n
        /* Markdown
         - foo
         
         bar
         
         */
        XCTAssertEqual(try compile("  - foo\n\n\tbar\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: false, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "foo", range: (0,4)-(0,6)))
                                ],
                                range: (0, 4)-(0, 7))),
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "bar", range: (2,1)-(2,3)))
                                ],
                                range: (2, 1)-(2, 4)))
                            ])
                        ]))
                       ]))
    }
    
    func testCase5() throws {
        // HTML: <ul>\n<li>\n<p>foo</p>\n<pre><code>  bar\n</code></pre>\n</li>\n</ul>\n
        /* Markdown
         - foo
         
         bar
         
         */
        XCTAssertEqual(try compile("- foo\n\n\t\tbar\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: false, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "foo", range: (0,2)-(0,4)))
                                ],
                                range: (0, 2)-(0, 5))),
                                .codeBlock(CodeBlock(infoString: "", content: "  bar\n", range: (2, 1)-(3, 0)))
                            ])
                        ]))
                       ]))
    }
    
    func testCase6() throws {
        // HTML: <blockquote>\n<pre><code>  foo\n</code></pre>\n</blockquote>\n
        /* Markdown
         >		foo
         
         */
        XCTAssertEqual(try compile(">\t\tfoo\n"),
                       Document(elements: [
                        .blockQuote(BlockQuote(blocks: [
                            .codeBlock(CodeBlock(infoString: "", content: "  foo\n", range: (0, 2)-(0, 6)))
                        ],
                        range: (0, 0)-(0, 6)))
                       ]))
    }
    
    func testCase7() throws {
        // HTML: <ul>\n<li>\n<pre><code>  foo\n</code></pre>\n</li>\n</ul>\n
        /* Markdown
         -		foo
         
         */
        XCTAssertEqual(try compile("-\t\tfoo\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                            ListItem(elements: [
                                .codeBlock(CodeBlock(infoString: "", content: "  foo\n", range: (0, 2)-(1, 0)))
                            ])
                        ]))
                       ]))
    }
    
    func testCase8() throws {
        // HTML: <pre><code>foo\nbar\n</code></pre>\n
        /* Markdown
         foo
         bar
         
         */
        XCTAssertEqual(try compile("    foo\n\tbar\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "", content: "foo\nbar\n", range: (0, 4)-(2, 0)))
                       ]))
    }
    
    func testCase9() throws {
        // HTML: <ul>\n<li>foo\n<ul>\n<li>bar\n<ul>\n<li>baz</li>\n</ul>\n</li>\n</ul>\n</li>\n</ul>\n
        /* Markdown
         - foo
         - bar
         - baz
         
         */
        XCTAssertEqual(try compile(" - foo\n   - bar\n\t - baz\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "foo", range: (0,3)-(0,5)))
                                ],
                                range: (0, 3)-(0, 6))),
                                .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                                    ListItem(elements: [
                                        .paragraph(Paragraph(text: [
                                            .text(InlineString(text: "bar", range: (1,5)-(1,7)))
                                        ],
                                        range: (1, 5)-(1, 8))),
                                        .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                                            ListItem(elements: [
                                                .paragraph(Paragraph(text: [
                                                    .text(InlineString(text: "baz", range: (2,4)-(2,6)))
                                                ],
                                                range: (2, 4)-(2, 7)))
                                            ])
                                        ]))
                                    ])
                                ]))
                            ])
                        ]))
                       ]))
    }
    
    func testCase10() throws {
        // HTML: <h1>Foo</h1>\n
        /* Markdown
         #	Foo
         
         */
        XCTAssertEqual(try compile("#\tFoo\n"),
                       Document(elements: [
                        .heading(Heading(level: 1,
                                         text: [
                                            .text(InlineString(text: "Foo", range: (0,2)-(0,4)))
                                         ],
                                         range: (0, 0)-(0, 5)))
                       ]))
    }
    
    func testCase11() throws {
        // HTML: <hr />\n
        /* Markdown
         *	*	*	
         
         */
        XCTAssertEqual(try compile("*\t*\t*\t\n"),
                       Document(elements: [
                        .thematicBreak(ThematicBreak(range: (0, 0)-(0, 6)))
                       ]))
    }
    
    
}
