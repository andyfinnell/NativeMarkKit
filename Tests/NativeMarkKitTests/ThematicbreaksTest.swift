import Foundation
import XCTest
@testable import NativeMarkKit

final class ThematicbreaksTest: XCTestCase {
    func testCase13() throws {
        // HTML: <hr />\n<hr />\n<hr />\n
        /* Markdown
         ***
         ---
         ___
         
         */
        XCTAssertEqual(try compile("***\n---\n___\n"),
                       Document(elements: [
                        .thematicBreak(ThematicBreak(range: (0, 0)-(0, 3))),
                        .thematicBreak(ThematicBreak(range: (1, 0)-(1, 3))),
                        .thematicBreak(ThematicBreak(range: (2, 0)-(2, 3)))
                       ]))
    }
    
    func testCase14() throws {
        // HTML: <p>+++</p>\n
        /* Markdown
         +++
         
         */
        XCTAssertEqual(try compile("+++\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "+++", range: (0,0)-(0,2)))
                        ],
                        range: (0, 0)-(0, 3)))
                       ]))
    }
    
    func testCase15() throws {
        // HTML: <p>===</p>\n
        /* Markdown
         ===
         
         */
        XCTAssertEqual(try compile("===\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "===", range: (0,0)-(0,2)))
                        ],
                        range: (0, 0)-(0, 3)))
                       ]))
    }
    
    func testCase16() throws {
        // HTML: <p>--\n**\n__</p>\n
        /* Markdown
         --
         **
         __
         
         */
        XCTAssertEqual(try compile("--\n**\n__\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "–", range: (0, 0)-(0, 1))),
                            .softbreak(InlineSoftbreak(range: (0, 2)-(0, 2))),
                            .text(InlineString(text: "**", range: (1,0)-(1,1))),
                            .softbreak(InlineSoftbreak(range: (1, 2)-(1, 2))),
                            .text(InlineString(text: "__", range: (2,0)-(2,1)))
                        ],
                        range: (0, 0)-(2, 2)))
                       ]))
    }
    
    func testCase17() throws {
        // HTML: <hr />\n<hr />\n<hr />\n
        /* Markdown
         ***
         ***
         ***
         
         */
        XCTAssertEqual(try compile(" ***\n  ***\n   ***\n"),
                       Document(elements: [
                        .thematicBreak(ThematicBreak(range: (0, 0)-(0, 4))),
                        .thematicBreak(ThematicBreak(range: (1, 0)-(1, 5))),
                        .thematicBreak(ThematicBreak(range: (2, 0)-(2, 6)))
                       ]))
    }
    
    func testCase18() throws {
        // HTML: <pre><code>***\n</code></pre>\n
        /* Markdown
         ***
         
         */
        XCTAssertEqual(try compile("    ***\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "", content: "***\n", range: (0, 4)-(1, 0)))
                       ]))
    }
    
    func testCase19() throws {
        // HTML: <p>Foo\n***</p>\n
        /* Markdown
         Foo
         ***
         
         */
        XCTAssertEqual(try compile("Foo\n    ***\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "Foo", range: (0,0)-(0,2))),
                            .softbreak(InlineSoftbreak(range: (0, 3)-(1, 3))),
                            .text(InlineString(text: "***", range: (1,4)-(1,6)))
                        ],
                        range: (0, 0)-(1, 7)))
                       ]))
    }
    
    func testCase20() throws {
        // HTML: <hr />\n
        /* Markdown
         _____________________________________
         
         */
        XCTAssertEqual(try compile("_____________________________________\n"),
                       Document(elements: [
                        .thematicBreak(ThematicBreak(range: (0, 0)-(0, 37)))
                       ]))
    }
    
    func testCase21() throws {
        // HTML: <hr />\n
        /* Markdown
         - - -
         
         */
        XCTAssertEqual(try compile(" - - -\n"),
                       Document(elements: [
                        .thematicBreak(ThematicBreak(range: (0, 0)-(0, 6)))
                       ]))
    }
    
    func testCase22() throws {
        // HTML: <hr />\n
        /* Markdown
         **  * ** * ** * **
         
         */
        XCTAssertEqual(try compile(" **  * ** * ** * **\n"),
                       Document(elements: [
                        .thematicBreak(ThematicBreak(range: (0, 0)-(0, 19)))
                       ]))
    }
    
    func testCase23() throws {
        // HTML: <hr />\n
        /* Markdown
         -     -      -      -
         
         */
        XCTAssertEqual(try compile("-     -      -      -\n"),
                       Document(elements: [
                        .thematicBreak(ThematicBreak(range: (0, 0)-(0, 21)))
                       ]))
    }
    
    func testCase24() throws {
        // HTML: <hr />\n
        /* Markdown
         - - - -
         
         */
        XCTAssertEqual(try compile("- - - -    \n"),
                       Document(elements: [
                        .thematicBreak(ThematicBreak(range: (0, 0)-(0, 11)))
                       ]))
    }
    
    func testCase25() throws {
        // HTML: <p>_ _ _ _ a</p>\n<p>a------</p>\n<p>---a---</p>\n
        /* Markdown
         _ _ _ _ a
         
         a------
         
         ---a---
         
         */
        XCTAssertEqual(try compile("_ _ _ _ a\n\na------\n\n---a---\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "_ _ _ _ a", range: (0,0)-(0,8)))
                        ],
                        range: (0, 0)-(0, 9))),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "a——", range: (2, 0)-(2, 6)))
                        ],
                        range: (2, 0)-(2, 7))),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "—a—", range: (4, 0)-(4, 6)))
                        ],
                        range: (4, 0)-(4, 7)))
                       ]))
    }
    
    func testCase26() throws {
        // HTML: <p><em>-</em></p>\n
        /* Markdown
         *-*
         
         */
        XCTAssertEqual(try compile(" *-*\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "-", range: (0,2)-(0,2)))
                            ],
                            range:(0, 1)-(0, 3)))
                        ],
                        range: (0, 1)-(0, 4)))
                       ]))
    }
    
    func testCase27() throws {
        // HTML: <ul>\n<li>foo</li>\n</ul>\n<hr />\n<ul>\n<li>bar</li>\n</ul>\n
        /* Markdown
         - foo
         ***
         - bar
         
         */
        XCTAssertEqual(try compile("- foo\n***\n- bar\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "foo", range: (0,2)-(0,4)))
                                ],
                                range: (0, 2)-(0, 5)))
                            ])
                        ])),
                        .thematicBreak(ThematicBreak(range: (1, 0)-(1, 3))),
                        .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "bar", range: (2,2)-(2,4)))
                                ],
                                range: (2, 2)-(2, 5)))
                            ])
                        ]))
                       ]))
    }
    
    func testCase28() throws {
        // HTML: <p>Foo</p>\n<hr />\n<p>bar</p>\n
        /* Markdown
         Foo
         ***
         bar
         
         */
        XCTAssertEqual(try compile("Foo\n***\nbar\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "Foo", range: (0,0)-(0,2)))
                        ],
                        range: (0, 0)-(0, 3))),
                        .thematicBreak(ThematicBreak(range: (1, 0)-(1, 3))),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "bar", range: (2,0)-(2,2)))
                        ],
                        range: (2, 0)-(2, 3)))
                       ]))
    }
    
    func testCase29() throws {
        // HTML: <h2>Foo</h2>\n<p>bar</p>\n
        /* Markdown
         Foo
         ---
         bar
         
         */
        XCTAssertEqual(try compile("Foo\n---\nbar\n"),
                       Document(elements: [
                        .heading(Heading(level: 2,
                                         text: [
                                            .text(InlineString(text: "Foo", range: (0,0)-(0,2)))
                                         ],
                                         range: (0, 0)-(1, 3))),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "bar", range: (2,0)-(2,2)))
                        ],
                        range: (2, 0)-(2, 3)))
                       ]))
    }
    
    func testCase30() throws {
        // HTML: <ul>\n<li>Foo</li>\n</ul>\n<hr />\n<ul>\n<li>Bar</li>\n</ul>\n
        /* Markdown
         * Foo
         * * *
         * Bar
         
         */
        XCTAssertEqual(try compile("* Foo\n* * *\n* Bar\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "Foo", range: (0,2)-(0,4)))
                                ],
                                range: (0, 2)-(0, 5)))
                            ])
                        ])),
                        .thematicBreak(ThematicBreak(range: (1, 0)-(1, 5))),
                        .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "Bar", range: (2,2)-(2,4)))
                                ],
                                range: (2, 2)-(2, 5)))
                            ])
                        ]))
                       ]))
    }
    
    func testCase31() throws {
        // HTML: <ul>\n<li>Foo</li>\n<li>\n<hr />\n</li>\n</ul>\n
        /* Markdown
         - Foo
         - * * *
         
         */
        XCTAssertEqual(try compile("- Foo\n- * * *\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "Foo", range: (0,2)-(0,4)))
                                ],
                                range: (0, 2)-(0, 5)))
                            ]),
                            ListItem(elements: [
                                .thematicBreak(ThematicBreak(range: (1, 2)-(1, 7)))
                            ])
                        ]))
                       ]))
    }
    
    
}
