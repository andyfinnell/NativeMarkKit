import Foundation
import XCTest
@testable import NativeMarkKit

final class SetextheadingsTest: XCTestCase {
    func testCase50() throws {
        // HTML: <h1>Foo <em>bar</em></h1>\n<h2>Foo <em>bar</em></h2>\n
        /* Markdown
         Foo *bar*
         =========
         
         Foo *bar*
         ---------
         
         */
        XCTAssertEqual(try compile("Foo *bar*\n=========\n\nFoo *bar*\n---------\n"),
                       Document(elements: [
                        .heading(Heading(level: 1,
                                         text: [
                                            .text(InlineString(text: "Foo ", range: (0,0)-(0,3))),
                                            .emphasis(InlineEmphasis(text: [
                                                .text(InlineString(text: "bar", range: (0,5)-(0,7)))
                                            ],
                                            range:(0, 4)-(0, 8)))
                                         ],
                                         range: (0, 0)-(1, 9))),
                        .heading(Heading(level: 2,
                                         text: [
                                            .text(InlineString(text: "Foo ", range: (3,0)-(3,3))),
                                            .emphasis(InlineEmphasis(text: [
                                                .text(InlineString(text: "bar", range: (3,5)-(3,7)))
                                            ],
                                            range:(3, 4)-(3, 8)))
                                         ],
                                         range: (3, 0)-(4, 9)))
                       ]))
    }
    
    func testCase51() throws {
        // HTML: <h1>Foo <em>bar\nbaz</em></h1>\n
        /* Markdown
         Foo *bar
         baz*
         ====
         
         */
        XCTAssertEqual(try compile("Foo *bar\nbaz*\n====\n"),
                       Document(elements: [
                        .heading(Heading(level: 1,
                                         text: [
                                            .text(InlineString(text: "Foo ", range: (0,0)-(0,3))),
                                            .emphasis(InlineEmphasis(text: [
                                                .text(InlineString(text: "bar", range: (0,5)-(0,7))),
                                                .softbreak(InlineSoftbreak(range: (0, 8)-(0, 8))),
                                                .text(InlineString(text: "baz", range: (1,0)-(1,2)))
                                            ],
                                            range:(0, 4)-(1, 3)))
                                         ],
                                         range: (0, 0)-(2, 4)))
                       ]))
    }
    
    func testCase52() throws {
        // HTML: <h1>Foo <em>bar\nbaz</em></h1>\n
        /* Markdown
         Foo *bar
         baz*
         ====
         
         */
        XCTAssertEqual(try compile("  Foo *bar\nbaz*\t\n====\n"),
                       Document(elements: [
                        .heading(Heading(level: 1,
                                         text: [
                                            .text(InlineString(text: "Foo ", range: (0,2)-(0,5))),
                                            .emphasis(InlineEmphasis(text: [
                                                .text(InlineString(text: "bar", range: (0,7)-(0,9))),
                                                .softbreak(InlineSoftbreak(range: (0, 10)-(0, 10))),
                                                .text(InlineString(text: "baz", range: (1,0)-(1,2)))
                                            ],
                                            range:(0, 6)-(1, 3)))
                                         ],
                                         range: (0, 2)-(2, 4)))
                       ]))
    }
    
    func testCase53() throws {
        // HTML: <h2>Foo</h2>\n<h1>Foo</h1>\n
        /* Markdown
         Foo
         -------------------------
         
         Foo
         =
         
         */
        XCTAssertEqual(try compile("Foo\n-------------------------\n\nFoo\n=\n"),
                       Document(elements: [
                        .heading(Heading(level: 2,
                                         text: [
                                            .text(InlineString(text: "Foo", range: (0,0)-(0,2)))
                                         ],
                                         range: (0, 0)-(1, 25))),
                        .heading(Heading(level: 1,
                                         text: [
                                            .text(InlineString(text: "Foo", range: (3,0)-(3,2)))
                                         ],
                                         range: (3, 0)-(4, 1)))
                       ]))
    }
    
    func testCase54() throws {
        // HTML: <h2>Foo</h2>\n<h2>Foo</h2>\n<h1>Foo</h1>\n
        /* Markdown
         Foo
         ---
         
         Foo
         -----
         
         Foo
         ===
         
         */
        XCTAssertEqual(try compile("   Foo\n---\n\n  Foo\n-----\n\n  Foo\n  ===\n"),
                       Document(elements: [
                        .heading(Heading(level: 2,
                                         text: [
                                            .text(InlineString(text: "Foo", range: (0,3)-(0,5)))
                                         ],
                                         range: (0, 3)-(1, 3))),
                        .heading(Heading(level: 2,
                                         text: [
                                            .text(InlineString(text: "Foo", range: (3,2)-(3,4)))
                                         ],
                                         range: (3, 2)-(4, 5))),
                        .heading(Heading(level: 1,
                                         text: [
                                            .text(InlineString(text: "Foo", range: (6,2)-(6,4)))
                                         ],
                                         range: (6, 2)-(7, 5)))
                       ]))
    }
    
    func testCase55() throws {
        // HTML: <pre><code>Foo\n---\n\nFoo\n</code></pre>\n<hr />\n
        /* Markdown
         Foo
         ---
         
         Foo
         ---
         
         */
        XCTAssertEqual(try compile("    Foo\n    ---\n\n    Foo\n---\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "", content: "Foo\n---\n\nFoo\n", range: (0, 4)-(3, 7))),
                        .thematicBreak(ThematicBreak(range: (4, 0)-(4, 3)))
                       ]))
    }
    
    func testCase56() throws {
        // HTML: <h2>Foo</h2>\n
        /* Markdown
         Foo
         ----
         
         */
        XCTAssertEqual(try compile("Foo\n   ----      \n"),
                       Document(elements: [
                        .heading(Heading(level: 2,
                                         text: [
                                            .text(InlineString(text: "Foo", range: (0,0)-(0,2)))
                                         ],
                                         range: (0, 0)-(1, 13)))
                       ]))
    }
    
    func testCase57() throws {
        // HTML: <p>Foo\n---</p>\n
        /* Markdown
         Foo
         ---
         
         */
        XCTAssertEqual(try compile("Foo\n    ---\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "Foo", range: (0,0)-(0,2))),
                            .softbreak(InlineSoftbreak(range: (0, 3)-(1, 3))),
                            .text(InlineString(text: "—", range: (1, 4)-(1, 6)))
                        ],
                        range: (0, 0)-(1, 7)))
                       ]))
    }
    
    func testCase58() throws {
        // HTML: <p>Foo\n= =</p>\n<p>Foo</p>\n<hr />\n
        /* Markdown
         Foo
         = =
         
         Foo
         --- -
         
         */
        XCTAssertEqual(try compile("Foo\n= =\n\nFoo\n--- -\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "Foo", range: (0,0)-(0,2))),
                            .softbreak(InlineSoftbreak(range: (0, 3)-(0, 3))),
                            .text(InlineString(text: "= =", range: (1,0)-(1,2)))
                        ],
                        range: (0, 0)-(1, 3))),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "Foo", range: (3,0)-(3,2)))
                        ],
                        range: (3, 0)-(3, 3))),
                        .thematicBreak(ThematicBreak(range: (4, 0)-(4, 5)))
                       ]))
    }
    
    func testCase59() throws {
        // HTML: <h2>Foo</h2>\n
        /* Markdown
         Foo
         -----
         
         */
        XCTAssertEqual(try compile("Foo  \n-----\n"),
                       Document(elements: [
                        .heading(Heading(level: 2,
                                         text: [
                                            .text(InlineString(text: "Foo", range: (0,0)-(0,2)))
                                         ],
                                         range: (0, 0)-(1, 5)))
                       ]))
    }
    
    func testCase60() throws {
        // HTML: <h2>Foo\\</h2>\n
        /* Markdown
         Foo\
         ----
         
         */
        XCTAssertEqual(try compile("Foo\\\n----\n"),
                       Document(elements: [
                        .heading(Heading(level: 2,
                                         text: [
                                            .text(InlineString(text: "Foo\\", range: (0,0)-(0,3)))
                                         ],
                                         range: (0, 0)-(1, 4)))
                       ]))
    }
    
    func testCase61() throws {
        // Input: `Foo\n----\n`\n\n<a title=\"a lot\n---\nof dashes\"/>\n
        // HTML: <h2>`Foo</h2>\n<p>`</p>\n<h2>&lt;a title=&quot;a lot</h2>\n<p>of dashes&quot;/&gt;</p>\n
        XCTAssertEqual(try compile("`Foo\n----\n`\n\n<a title=\"a lot\n---\nof dashes\"/>\n"),
                       Document(elements: [
                        .heading(Heading(level: 2,
                                         text: [
                                            .text(InlineString(text: "`Foo", range: (0,0)-(0,3)))
                                         ],
                                         range: (0, 0)-(1, 4))),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "`", range: (2,0)-(2,0)))
                        ],
                        range: (2, 0)-(2, 1))),
                        .heading(Heading(level: 2,
                                         text: [
                                            .text(InlineString(text: "<a title=”a lot", range: (4, 0)-(4, 14)))
                                         ],
                                         range: (4, 0)-(5, 3))),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "of dashes”/>", range: (6, 0)-(6, 11)))
                        ],
                        range: (6, 0)-(6, 12)))
                       ]))
    }
    
    func testCase62() throws {
        // HTML: <blockquote>\n<p>Foo</p>\n</blockquote>\n<hr />\n
        /* Markdown
         > Foo
         ---
         
         */
        XCTAssertEqual(try compile("> Foo\n---\n"),
                       Document(elements: [
                        .blockQuote(BlockQuote(blocks: [
                            .paragraph(Paragraph(text: [
                                .text(InlineString(text: "Foo", range: (0,2)-(0,4)))
                            ],
                            range: (0, 2)-(0, 5)))
                        ],
                        range: (0, 0)-(0, 5))),
                        .thematicBreak(ThematicBreak(range: (1, 0)-(1, 3)))
                       ]))
    }
    
    func testCase63() throws {
        // HTML: <blockquote>\n<p>foo\nbar\n===</p>\n</blockquote>\n
        /* Markdown
         > foo
         bar
         ===
         
         */
        XCTAssertEqual(try compile("> foo\nbar\n===\n"),
                       Document(elements: [
                        .blockQuote(BlockQuote(blocks: [
                            .paragraph(Paragraph(text: [
                                .text(InlineString(text: "foo", range: (0,2)-(0,4))),
                                .softbreak(InlineSoftbreak(range: (0, 5)-(0, 5))),
                                .text(InlineString(text: "bar", range: (1,0)-(1,2))),
                                .softbreak(InlineSoftbreak(range: (1, 3)-(1, 3))),
                                .text(InlineString(text: "===", range: (2,0)-(2,2)))
                            ],
                            range: (0, 2)-(2, 3)))
                        ],
                        range: (0, 0)-(2, 3)))
                       ]))
    }
    
    func testCase64() throws {
        // HTML: <ul>\n<li>Foo</li>\n</ul>\n<hr />\n
        /* Markdown
         - Foo
         ---
         
         */
        XCTAssertEqual(try compile("- Foo\n---\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "Foo", range: (0,2)-(0,4)))
                                ],
                                range: (0, 2)-(0, 5)))
                            ], range: (0, 0)-(0,5))
                        ])),
                        .thematicBreak(ThematicBreak(range: (1, 0)-(1, 3)))
                       ]))
    }
    
    func testCase65() throws {
        // HTML: <h2>Foo\nBar</h2>\n
        /* Markdown
         Foo
         Bar
         ---
         
         */
        XCTAssertEqual(try compile("Foo\nBar\n---\n"),
                       Document(elements: [
                        .heading(Heading(level: 2,
                                         text: [
                                            .text(InlineString(text: "Foo", range: (0,0)-(0,2))),
                                            .softbreak(InlineSoftbreak(range: (0, 3)-(0, 3))),
                                            .text(InlineString(text: "Bar", range: (1,0)-(1,2)))
                                         ],
                                         range: (0, 0)-(2, 3)))
                       ]))
    }
    
    func testCase66() throws {
        // HTML: <hr />\n<h2>Foo</h2>\n<h2>Bar</h2>\n<p>Baz</p>\n
        /* Markdown
         ---
         Foo
         ---
         Bar
         ---
         Baz
         
         */
        XCTAssertEqual(try compile("---\nFoo\n---\nBar\n---\nBaz\n"),
                       Document(elements: [
                        .thematicBreak(ThematicBreak(range: (0, 0)-(0, 3))),
                        .heading(Heading(level: 2,
                                         text: [
                                            .text(InlineString(text: "Foo", range: (1,0)-(1,2)))
                                         ],
                                         range: (1, 0)-(2, 3))),
                        .heading(Heading(level: 2,
                                         text: [
                                            .text(InlineString(text: "Bar", range: (3,0)-(3,2)))
                                         ],
                                         range: (3, 0)-(4, 3))),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "Baz", range: (5,0)-(5,2)))
                        ],
                        range: (5, 0)-(5, 3)))
                       ]))
    }
    
    func testCase67() throws {
        // HTML: <p>====</p>\n
        /* Markdown
         
         ====
         
         */
        XCTAssertEqual(try compile("\n====\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "====", range: (1,0)-(1,3)))
                        ],
                        range: (1, 0)-(1, 4)))
                       ]))
    }
    
    func testCase68() throws {
        // HTML: <hr />\n<hr />\n
        /* Markdown
         ---
         ---
         
         */
        XCTAssertEqual(try compile("---\n---\n"),
                       Document(elements: [
                        .thematicBreak(ThematicBreak(range: (0, 0)-(0, 3))),
                        .thematicBreak(ThematicBreak(range: (1, 0)-(1, 3)))
                       ]))
    }
    
    func testCase69() throws {
        // HTML: <ul>\n<li>foo</li>\n</ul>\n<hr />\n
        /* Markdown
         - foo
         -----
         
         */
        XCTAssertEqual(try compile("- foo\n-----\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "foo", range: (0,2)-(0,4)))
                                ],
                                range: (0, 2)-(0, 5)))
                            ], range: (0, 0)-(0,5))
                        ])),
                        .thematicBreak(ThematicBreak(range: (1, 0)-(1, 5)))
                       ]))
    }
    
    func testCase70() throws {
        // HTML: <pre><code>foo\n</code></pre>\n<hr />\n
        /* Markdown
         foo
         ---
         
         */
        XCTAssertEqual(try compile("    foo\n---\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "", content: "foo\n", range: (0, 4)-(0, 7))),
                        .thematicBreak(ThematicBreak(range: (1, 0)-(1, 3)))
                       ]))
    }
    
    func testCase71() throws {
        // HTML: <blockquote>\n<p>foo</p>\n</blockquote>\n<hr />\n
        /* Markdown
         > foo
         -----
         
         */
        XCTAssertEqual(try compile("> foo\n-----\n"),
                       Document(elements: [
                        .blockQuote(BlockQuote(blocks: [
                            .paragraph(Paragraph(text: [
                                .text(InlineString(text: "foo", range: (0,2)-(0,4)))
                            ],
                            range: (0, 2)-(0, 5)))
                        ],
                        range: (0, 0)-(0, 5))),
                        .thematicBreak(ThematicBreak(range: (1, 0)-(1, 5)))
                       ]))
    }
    
    func testCase72() throws {
        // HTML: <h2>&gt; foo</h2>\n
        /* Markdown
         \> foo
         ------
         
         */
        XCTAssertEqual(try compile("\\> foo\n------\n"),
                       Document(elements: [
                        .heading(Heading(level: 2,
                                         text: [
                                            .text(InlineString(text: "> foo", range: (0,0)-(0,5)))
                                         ],
                                         range: (0, 0)-(1, 6)))
                       ]))
    }
    
    func testCase73() throws {
        // HTML: <p>Foo</p>\n<h2>bar</h2>\n<p>baz</p>\n
        /* Markdown
         Foo
         
         bar
         ---
         baz
         
         */
        XCTAssertEqual(try compile("Foo\n\nbar\n---\nbaz\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "Foo", range: (0,0)-(0,2)))
                        ],
                        range: (0, 0)-(0, 3))),
                        .heading(Heading(level: 2,
                                         text: [
                                            .text(InlineString(text: "bar", range: (2,0)-(2,2)))
                                         ],
                                         range: (2, 0)-(3, 3))),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "baz", range: (4,0)-(4,2)))
                        ],
                        range: (4, 0)-(4, 3)))
                       ]))
    }
    
    func testCase74() throws {
        // HTML: <p>Foo\nbar</p>\n<hr />\n<p>baz</p>\n
        /* Markdown
         Foo
         bar
         
         ---
         
         baz
         
         */
        XCTAssertEqual(try compile("Foo\nbar\n\n---\n\nbaz\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "Foo", range: (0,0)-(0,2))),
                            .softbreak(InlineSoftbreak(range: (0, 3)-(0, 3))),
                            .text(InlineString(text: "bar", range: (1,0)-(1,2)))
                        ],
                        range: (0, 0)-(1, 3))),
                        .thematicBreak(ThematicBreak(range: (3, 0)-(3, 3))),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "baz", range: (5,0)-(5,2)))
                        ],
                        range: (5, 0)-(5, 3)))
                       ]))
    }
    
    func testCase75() throws {
        // HTML: <p>Foo\nbar</p>\n<hr />\n<p>baz</p>\n
        /* Markdown
         Foo
         bar
         * * *
         baz
         
         */
        XCTAssertEqual(try compile("Foo\nbar\n* * *\nbaz\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "Foo", range: (0,0)-(0,2))),
                            .softbreak(InlineSoftbreak(range: (0, 3)-(0, 3))),
                            .text(InlineString(text: "bar", range: (1,0)-(1,2)))
                        ],
                        range: (0, 0)-(1, 3))),
                        .thematicBreak(ThematicBreak(range: (2, 0)-(2, 5))),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "baz", range: (3,0)-(3,2)))
                        ],
                        range: (3, 0)-(3, 3)))
                       ]))
    }
    
    func testCase76() throws {
        // HTML: <p>Foo\nbar\n---\nbaz</p>\n
        /* Markdown
         Foo
         bar
         \---
         baz
         
         */
        XCTAssertEqual(try compile("Foo\nbar\n\\---\nbaz\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "Foo", range: (0,0)-(0,2))),
                            .softbreak(InlineSoftbreak(range: (0, 3)-(0, 3))),
                            .text(InlineString(text: "bar", range: (1,0)-(1,2))),
                            .softbreak(InlineSoftbreak(range: (1, 3)-(1, 3))),
                            .text(InlineString(text: "-–", range: (2, 0)-(2, 3))),
                            .softbreak(InlineSoftbreak(range: (2, 4)-(2, 4))),
                            .text(InlineString(text: "baz", range: (3,0)-(3,2)))
                        ],
                        range: (0, 0)-(3, 3)))
                       ]))
    }
    
    
}
