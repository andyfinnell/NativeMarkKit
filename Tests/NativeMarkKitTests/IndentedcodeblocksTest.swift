import Foundation
import XCTest
@testable import NativeMarkKit

final class IndentedcodeblocksTest: XCTestCase {
    func testCase77() throws {
        // HTML: <pre><code>a simple\n  indented code block\n</code></pre>\n
        /* Markdown
         a simple
         indented code block
         
         */
        XCTAssertEqual(try compile("    a simple\n      indented code block\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "",
                                             content: "a simple\n  indented code block\n",
                                             range: (0, 4)-(2, 0)))
                       ]))
    }
    
    func testCase78() throws {
        // HTML: <ul>\n<li>\n<p>foo</p>\n<p>bar</p>\n</li>\n</ul>\n
        /* Markdown
         - foo
         
         bar
         
         */
        XCTAssertEqual(try compile("  - foo\n\n    bar\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: false, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "foo", range: (0,4)-(0,6)))
                                ],
                                range: (0, 4)-(0, 7))),
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "bar", range: (2,4)-(2,6)))
                                ],
                                range: (2, 4)-(2, 7)))
                            ], range: (0, 2)-(2,7))
                        ]))
                       ]))
    }
    
    func testCase79() throws {
        // HTML: <ol>\n<li>\n<p>foo</p>\n<ul>\n<li>bar</li>\n</ul>\n</li>\n</ol>\n
        /* Markdown
         1.  foo
         
         - bar
         
         */
        XCTAssertEqual(try compile("1.  foo\n\n    - bar\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: false, kind: .ordered(start: 1)), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "foo", range: (0,4)-(0,6)))
                                ],
                                range: (0, 4)-(0, 7))),
                                .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                                    ListItem(elements: [
                                        .paragraph(Paragraph(text: [
                                            .text(InlineString(text: "bar", range: (2,6)-(2,8)))
                                        ],
                                        range: (2, 6)-(2, 9)))
                                    ], range: (2, 4)-(2,9))
                                ]))
                            ], range: (0, 0)-(2,9))
                        ]))
                       ]))
    }
    
    func testCase80() throws {
        // Input:     <a/>\n    *hi*\n\n    - one\n
        // HTML: <pre><code>&lt;a/&gt;\n*hi*\n\n- one\n</code></pre>\n
        XCTAssertEqual(try compile("    <a/>\n    *hi*\n\n    - one\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "",
                                             content: "<a/>\n*hi*\n\n- one\n",
                                             range: (0, 4)-(4, 0)))
                       ]))
    }
    
    func testCase81() throws {
        // HTML: <pre><code>chunk1\n\nchunk2\n\n\n\nchunk3\n</code></pre>\n
        /* Markdown
         chunk1
         
         chunk2
         
         
         
         chunk3
         
         */
        XCTAssertEqual(try compile("    chunk1\n\n    chunk2\n  \n \n \n    chunk3\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "",
                                             content: "chunk1\n\nchunk2\n\n\n\nchunk3\n",
                                             range: (0, 4)-(7, 0)))
                       ]))
    }
    
    func testCase82() throws {
        // HTML: <pre><code>chunk1\n  \n  chunk2\n</code></pre>\n
        /* Markdown
         chunk1
         
         chunk2
         
         */
        XCTAssertEqual(try compile("    chunk1\n      \n      chunk2\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "",
                                             content: "chunk1\n  \n  chunk2\n",
                                             range: (0, 4)-(3, 0)))
                       ]))
    }
    
    func testCase83() throws {
        // HTML: <p>Foo\nbar</p>\n
        /* Markdown
         Foo
         bar
         
         
         */
        XCTAssertEqual(try compile("Foo\n    bar\n\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "Foo", range: (0,0)-(0,2))),
                            .softbreak(InlineSoftbreak(range: (0, 3)-(1, 3))),
                            .text(InlineString(text: "bar", range: (1,4)-(1,6)))
                        ],
                        range: (0, 0)-(1, 7)))
                       ]))
    }
    
    func testCase84() throws {
        // HTML: <pre><code>foo\n</code></pre>\n<p>bar</p>\n
        /* Markdown
         foo
         bar
         
         */
        XCTAssertEqual(try compile("    foo\nbar\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "",
                                             content: "foo\n",
                                             range: (0, 4)-(0, 7))),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "bar", range: (1,0)-(1,2)))
                        ],
                        range: (1, 0)-(1, 3)))
                       ]))
    }
    
    func testCase85() throws {
        // HTML: <h1>Heading</h1>\n<pre><code>foo\n</code></pre>\n<h2>Heading</h2>\n<pre><code>foo\n</code></pre>\n<hr />\n
        /* Markdown
         # Heading
         foo
         Heading
         ------
         foo
         ----
         
         */
        XCTAssertEqual(try compile("# Heading\n    foo\nHeading\n------\n    foo\n----\n"),
                       Document(elements: [
                        .heading(Heading(level: 1,
                                         text: [
                                            .text(InlineString(text: "Heading", range: (0,2)-(0,8)))
                                         ],
                                         range: (0, 0)-(0, 9))),
                        .codeBlock(CodeBlock(infoString: "", content: "foo\n", range: (1, 4)-(1, 7))),
                        .heading(Heading(level: 2,
                                         text: [
                                            .text(InlineString(text: "Heading", range: (2,0)-(2,6)))
                                         ],
                                         range: (2, 0)-(3, 6))),
                        .codeBlock(CodeBlock(infoString: "", content: "foo\n", range: (4, 4)-(4, 7))),
                        .thematicBreak(ThematicBreak(range: (5, 0)-(5, 4)))
                       ]))
    }
    
    func testCase86() throws {
        // HTML: <pre><code>    foo\nbar\n</code></pre>\n
        /* Markdown
         foo
         bar
         
         */
        XCTAssertEqual(try compile("        foo\n    bar\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "",
                                             content: "    foo\nbar\n",
                                             range: (0, 4)-(2, 0)))
                       ]))
    }
    
    func testCase87() throws {
        // HTML: <pre><code>foo\n</code></pre>\n
        /* Markdown
         
         
         foo
         
         
         
         */
        XCTAssertEqual(try compile("\n    \n    foo\n    \n\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "",
                                             content: "foo\n",
                                             range: (2, 4)-(5, 0)))
                       ]))
    }
    
    func testCase88() throws {
        // HTML: <pre><code>foo  \n</code></pre>\n
        /* Markdown
         foo
         
         */
        XCTAssertEqual(try compile("    foo  \n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "",
                                             content: "foo  \n",
                                             range: (0, 4)-(1, 0)))
                       ]))
    }
    
    
}
