import Foundation
import XCTest
@testable import NativeMarkKit

final class ListsTest: XCTestCase {
    func testCase271() throws {
        // HTML: <ul>\n<li>foo</li>\n<li>bar</li>\n</ul>\n<ul>\n<li>baz</li>\n</ul>\n
        /* Markdown
         - foo
         - bar
         + baz
         
         */
        XCTAssertEqual(try compile("- foo\n- bar\n+ baz\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "foo", range: (0,2)-(0,4)))
                                ],
                                range: (0, 2)-(0, 5)))
                            ], range: (0, 0)-(0,5)),
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "bar", range: (1,2)-(1,4)))
                                ],
                                range: (1, 2)-(1, 5)))
                            ], range: (1, 0)-(1,5))
                        ])),
                        .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "baz", range: (2,2)-(2,4)))
                                ],
                                range: (2, 2)-(2, 5)))
                            ], range: (2, 0)-(2,5))
                        ]))
                       ]))
    }
    
    func testCase272() throws {
        // HTML: <ol>\n<li>foo</li>\n<li>bar</li>\n</ol>\n<ol start=\"3\">\n<li>baz</li>\n</ol>\n
        /* Markdown
         1. foo
         2. bar
         3) baz
         
         */
        XCTAssertEqual(try compile("1. foo\n2. bar\n3) baz\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: true, kind: .ordered(start: 1)), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "foo", range: (0,3)-(0,5)))
                                ],
                                range: (0, 3)-(0, 6)))
                            ], range: (0, 0)-(0,6)),
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "bar", range: (1,3)-(1,5)))
                                ],
                                range: (1, 3)-(1, 6)))
                            ], range: (1, 0)-(1,6))
                        ])),
                        .list(List(info: ListInfo(isTight: true, kind: .ordered(start: 3)), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "baz", range: (2,3)-(2,5)))
                                ],
                                range: (2, 3)-(2, 6)))
                            ], range: (2, 0)-(2,6))
                        ]))
                       ]))
    }
    
    func testCase273() throws {
        // HTML: <p>Foo</p>\n<ul>\n<li>bar</li>\n<li>baz</li>\n</ul>\n
        /* Markdown
         Foo
         - bar
         - baz
         
         */
        XCTAssertEqual(try compile("Foo\n- bar\n- baz\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "Foo", range: (0,0)-(0,2)))
                        ],
                        range: (0, 0)-(0, 3))),
                        .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "bar", range: (1,2)-(1,4)))
                                ],
                                range: (1, 2)-(1, 5)))
                            ], range: (1, 0)-(1,5)),
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "baz", range: (2,2)-(2,4)))
                                ],
                                range: (2, 2)-(2, 5)))
                            ], range: (2, 0)-(2,5))
                        ]))
                       ]))
    }
    
    func testCase274() throws {
        // HTML: <p>The number of windows in my house is\n14.  The number of doors is 6.</p>\n
        /* Markdown
         The number of windows in my house is
         14.  The number of doors is 6.
         
         */
        XCTAssertEqual(try compile("The number of windows in my house is\n14.  The number of doors is 6.\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "The number of windows in my house is", range: (0,0)-(0,35))),
                            .softbreak(InlineSoftbreak(range: (0, 36)-(0, 36))),
                            .text(InlineString(text: "14.  The number of doors is 6.", range: (1,0)-(1,29)))
                        ],
                        range: (0, 0)-(1, 30)))
                       ]))
    }
    
    func testCase275() throws {
        // HTML: <p>The number of windows in my house is</p>\n<ol>\n<li>The number of doors is 6.</li>\n</ol>\n
        /* Markdown
         The number of windows in my house is
         1.  The number of doors is 6.
         
         */
        XCTAssertEqual(try compile("The number of windows in my house is\n1.  The number of doors is 6.\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "The number of windows in my house is", range: (0,0)-(0,35)))
                        ],
                        range: (0, 0)-(0, 36))),
                        .list(List(info: ListInfo(isTight: true, kind: .ordered(start: 1)), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "The number of doors is 6.", range: (1,4)-(1,28)))
                                ],
                                range: (1, 4)-(1, 29)))
                            ], range: (1, 0)-(1,29))
                        ]))
                       ]))
    }
    
    func testCase276() throws {
        // HTML: <ul>\n<li>\n<p>foo</p>\n</li>\n<li>\n<p>bar</p>\n</li>\n<li>\n<p>baz</p>\n</li>\n</ul>\n
        /* Markdown
         - foo
         
         - bar
         
         
         - baz
         
         */
        XCTAssertEqual(try compile("- foo\n\n- bar\n\n\n- baz\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: false, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "foo", range: (0,2)-(0,4)))
                                ],
                                range: (0, 2)-(0, 5)))
                            ], range: (0, 0)-(0,5)),
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "bar", range: (2,2)-(2,4)))
                                ],
                                range: (2, 2)-(2, 5)))
                            ], range: (2, 0)-(2,5)),
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "baz", range: (5,2)-(5,4)))
                                ],
                                range: (5, 2)-(5, 5)))
                            ], range: (5, 0)-(5,5))
                        ]))
                       ]))
    }
    
    func testCase277() throws {
        // HTML: <ul>\n<li>foo\n<ul>\n<li>bar\n<ul>\n<li>\n<p>baz</p>\n<p>bim</p>\n</li>\n</ul>\n</li>\n</ul>\n</li>\n</ul>\n
        /* Markdown
         - foo
         - bar
         - baz
         
         
         bim
         
         */
        XCTAssertEqual(try compile("- foo\n  - bar\n    - baz\n\n\n      bim\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "foo", range: (0,2)-(0,4)))
                                ],
                                range: (0, 2)-(0, 5))),
                                .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                                    ListItem(elements: [
                                        .paragraph(Paragraph(text: [
                                            .text(InlineString(text: "bar", range: (1,4)-(1,6)))
                                        ],
                                        range: (1, 4)-(1, 7))),
                                        .list(List(info: ListInfo(isTight: false, kind: .bulleted), items: [
                                            ListItem(elements: [
                                                .paragraph(Paragraph(text: [
                                                    .text(InlineString(text: "baz", range: (2,6)-(2,8)))
                                                ],
                                                range: (2, 6)-(2, 9))),
                                                .paragraph(Paragraph(text: [
                                                    .text(InlineString(text: "bim", range: (5,6)-(5,8)))
                                                ],
                                                range: (5, 6)-(5, 9)))
                                            ], range: (2, 4)-(5,9))
                                        ]))
                                    ], range: (1, 2)-(5,9))
                                ]))
                            ], range: (0, 0)-(5,9))
                        ]))
                       ]))
    }
    
    func testCase278() throws {
        // HTML: <ul>\n<li>foo</li>\n<li>bar</li>\n</ul>\n<!-- -->\n<ul>\n<li>baz</li>\n<li>bim</li>\n</ul>\n
        /* Markdown
         - foo
         - bar
         
         <!-- -->
         
         - baz
         - bim
         
         */
        XCTAssertEqual(try compile("- foo\n- bar\n\n<!-- -->\n\n- baz\n- bim\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "foo", range: (0,2)-(0,4)))
                                ],
                                range: (0, 2)-(0, 5)))
                            ], range: (0, 0)-(0,5)),
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "bar", range: (1,2)-(1,4)))
                                ],
                                range: (1, 2)-(1, 5)))
                            ], range: (1, 0)-(1,5))
                        ])),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "<!– –>", range: (3, 0)-(3, 7)))
                        ],
                        range: (3, 0)-(3, 8))),
                        .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "baz", range: (5,2)-(5,4)))
                                ],
                                range: (5, 2)-(5, 5)))
                            ], range: (5, 0)-(5,5)),
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "bim", range: (6,2)-(6,4)))
                                ],
                                range: (6, 2)-(6, 5)))
                            ], range: (6, 0)-(6,5))
                        ]))
                       ]))
    }
    
    func testCase279() throws {
        // HTML: <ul>\n<li>\n<p>foo</p>\n<p>notcode</p>\n</li>\n<li>\n<p>foo</p>\n</li>\n</ul>\n<!-- -->\n<pre><code>code\n</code></pre>\n
        /* Markdown
         -   foo
         
         notcode
         
         -   foo
         
         <!-- -->
         
         code
         
         */
        XCTAssertEqual(try compile("-   foo\n\n    notcode\n\n-   foo\n\n<!-- -->\n\n    code\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: false, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "foo", range: (0,4)-(0,6)))
                                ],
                                range: (0, 4)-(0, 7))),
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "notcode", range: (2,4)-(2,10)))
                                ],
                                range: (2, 4)-(2, 11)))
                            ], range: (0, 0)-(2,11)),
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "foo", range: (4,4)-(4,6)))
                                ],
                                range: (4, 4)-(4, 7)))
                            ], range: (4, 0)-(4,7))
                        ])),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "<!– –>", range: (6, 0)-(6, 7)))
                        ],
                        range: (6, 0)-(6, 8))),
                        .codeBlock(CodeBlock(infoString: "", content: "code\n", range: (8, 4)-(9, 0)))
                       ]))
    }
    
    func testCase280() throws {
        // HTML: <ul>\n<li>a</li>\n<li>b</li>\n<li>c</li>\n<li>d</li>\n<li>e</li>\n<li>f</li>\n<li>g</li>\n</ul>\n
        /* Markdown
         - a
         - b
         - c
         - d
         - e
         - f
         - g
         
         */
        XCTAssertEqual(try compile("- a\n - b\n  - c\n   - d\n  - e\n - f\n- g\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "a", range: (0,2)-(0,2)))
                                ],
                                range: (0, 2)-(0, 3)))
                            ], range: (0, 0)-(0,3)),
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "b", range: (1,3)-(1,3)))
                                ],
                                range: (1, 3)-(1, 4)))
                            ], range: (1, 1)-(1,4)),
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "c", range: (2,4)-(2,4)))
                                ],
                                range: (2, 4)-(2, 5)))
                            ], range: (2, 2)-(2,5)),
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "d", range: (3,5)-(3,5)))
                                ],
                                range: (3, 5)-(3, 6)))
                            ], range: (3, 3)-(3,6)),
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "e", range: (4,4)-(4,4)))
                                ],
                                range: (4, 4)-(4, 5)))
                            ], range: (4, 2)-(4,5)),
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "f", range: (5,3)-(5,3)))
                                ],
                                range: (5, 3)-(5, 4)))
                            ], range: (5, 1)-(5,4)),
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "g", range: (6,2)-(6,2)))
                                ],
                                range: (6, 2)-(6, 3)))
                            ], range: (6, 0)-(6,3))
                        ]))
                       ]))
    }
    
    func testCase281() throws {
        // HTML: <ol>\n<li>\n<p>a</p>\n</li>\n<li>\n<p>b</p>\n</li>\n<li>\n<p>c</p>\n</li>\n</ol>\n
        /* Markdown
         1. a
         
         2. b
         
         3. c
         
         */
        XCTAssertEqual(try compile("1. a\n\n  2. b\n\n   3. c\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: false, kind: .ordered(start: 1)), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "a", range: (0,3)-(0,3)))
                                ],
                                range: (0, 3)-(0, 4)))
                            ], range: (0, 0)-(0,4)),
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "b", range: (2,5)-(2,5)))
                                ],
                                range: (2, 5)-(2, 6)))
                            ], range: (2, 2)-(2,6)),
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "c", range: (4,6)-(4,6)))
                                ],
                                range: (4, 6)-(4, 7)))
                            ], range: (4, 3)-(4,7))
                        ]))
                       ]))
    }
    
    func testCase282() throws {
        // HTML: <ul>\n<li>a</li>\n<li>b</li>\n<li>c</li>\n<li>d\n- e</li>\n</ul>\n
        /* Markdown
         - a
         - b
         - c
         - d
         - e
         
         */
        XCTAssertEqual(try compile("- a\n - b\n  - c\n   - d\n    - e\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "a", range: (0,2)-(0,2)))
                                ],
                                range: (0, 2)-(0, 3)))
                            ], range: (0, 0)-(0,3)),
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "b", range: (1,3)-(1,3)))
                                ],
                                range: (1, 3)-(1, 4)))
                            ], range: (1, 1)-(1,4)),
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "c", range: (2,4)-(2,4)))
                                ],
                                range: (2, 4)-(2, 5)))
                            ], range: (2, 2)-(2,5)),
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "d", range: (3,5)-(3,5))),
                                    .softbreak(InlineSoftbreak(range: (3, 6)-(4, 3))),
                                    .text(InlineString(text: "- e", range: (4,4)-(4,6)))
                                ],
                                range: (3, 5)-(4, 7)))
                            ], range: (3, 3)-(4,7))
                        ]))
                       ]))
    }
    
    func testCase283() throws {
        // HTML: <ol>\n<li>\n<p>a</p>\n</li>\n<li>\n<p>b</p>\n</li>\n</ol>\n<pre><code>3. c\n</code></pre>\n
        /* Markdown
         1. a
         
         2. b
         
         3. c
         
         */
        XCTAssertEqual(try compile("1. a\n\n  2. b\n\n    3. c\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: false, kind: .ordered(start: 1)), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "a", range: (0,3)-(0,3)))
                                ],
                                range: (0, 3)-(0, 4)))
                            ], range: (0, 0)-(0,4)),
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "b", range: (2,5)-(2,5)))
                                ],
                                range: (2, 5)-(2, 6)))
                            ], range: (2, 2)-(2,6))
                        ])),
                        .codeBlock(CodeBlock(infoString: "", content: "3. c\n", range: (4, 4)-(5, 0)))
                       ]))
    }
    
    func testCase284() throws {
        // HTML: <ul>\n<li>\n<p>a</p>\n</li>\n<li>\n<p>b</p>\n</li>\n<li>\n<p>c</p>\n</li>\n</ul>\n
        /* Markdown
         - a
         - b
         
         - c
         
         */
        XCTAssertEqual(try compile("- a\n- b\n\n- c\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: false, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "a", range: (0,2)-(0,2)))
                                ],
                                range: (0, 2)-(0, 3)))
                            ], range: (0, 0)-(0,3)),
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "b", range: (1,2)-(1,2)))
                                ],
                                range: (1, 2)-(1, 3)))
                            ], range: (1, 0)-(1,3)),
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "c", range: (3,2)-(3,2)))
                                ],
                                range: (3, 2)-(3, 3)))
                            ], range: (3, 0)-(3,3))
                        ]))
                       ]))
    }
    
    func testCase285() throws {
        // HTML: <ul>\n<li>\n<p>a</p>\n</li>\n<li></li>\n<li>\n<p>c</p>\n</li>\n</ul>\n
        /* Markdown
         * a
         *
         
         * c
         
         */
        XCTAssertEqual(try compile("* a\n*\n\n* c\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: false, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "a", range: (0,2)-(0,2)))
                                ],
                                range: (0, 2)-(0, 3)))
                            ], range: (0, 0)-(0,3)),
                            ListItem(elements: [
                                
                            ], range: (1, 0)-(1,1)),
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "c", range: (3,2)-(3,2)))
                                ],
                                range: (3, 2)-(3, 3)))
                            ], range: (3, 0)-(3,3))
                        ]))
                       ]))
    }
    
    func testCase286() throws {
        // HTML: <ul>\n<li>\n<p>a</p>\n</li>\n<li>\n<p>b</p>\n<p>c</p>\n</li>\n<li>\n<p>d</p>\n</li>\n</ul>\n
        /* Markdown
         - a
         - b
         
         c
         - d
         
         */
        XCTAssertEqual(try compile("- a\n- b\n\n  c\n- d\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: false, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "a", range: (0,2)-(0,2)))
                                ],
                                range: (0, 2)-(0, 3)))
                            ], range: (0, 0)-(0,3)),
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "b", range: (1,2)-(1,2)))
                                ],
                                range: (1, 2)-(1, 3))),
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "c", range: (3,2)-(3,2)))
                                ],
                                range: (3, 2)-(3, 3)))
                            ], range: (1, 0)-(3,3)),
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "d", range: (4,2)-(4,2)))
                                ],
                                range: (4, 2)-(4, 3)))
                            ], range: (4, 0)-(4,3))
                        ]))
                       ]))
    }
    
    func testCase287() throws {
        // HTML: <ul>\n<li>\n<p>a</p>\n</li>\n<li>\n<p>b</p>\n</li>\n<li>\n<p>d</p>\n</li>\n</ul>\n
        /* Markdown
         - a
         - b
         
         [ref]: /url
         - d
         
         */
        XCTAssertEqual(try compile("- a\n- b\n\n  [ref]: /url\n- d\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: false, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "a", range: (0,2)-(0,2)))
                                ],
                                range: (0, 2)-(0, 3)))
                            ], range: (0, 0)-(0,3)),
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "b", range: (1,2)-(1,2)))
                                ],
                                range: (1, 2)-(1, 3)))
                            ], range: (1, 0)-(1,3)),
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "d", range: (4,2)-(4,2)))
                                ],
                                range: (4, 2)-(4,3)))
                            ], range: (4, 0)-(4,3))
                        ]))
                       ]))
    }
    
    func testCase288() throws {
        // HTML: <ul>\n<li>a</li>\n<li>\n<pre><code>b\n\n\n</code></pre>\n</li>\n<li>c</li>\n</ul>\n
        /* Markdown
         - a
         - ```
         b
         
         
         ```
         - c
         
         */
        XCTAssertEqual(try compile("- a\n- ```\n  b\n\n\n  ```\n- c\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "a", range: (0,2)-(0,2)))
                                ],
                                range: (0, 2)-(0, 3)))
                            ], range: (0, 0)-(0,3)),
                            ListItem(elements: [
                                .codeBlock(CodeBlock(infoString: "", content: "b\n\n\n", range: (1, 2)-(5, 5)))
                            ], range: (1, 0)-(5,5)),
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "c", range: (6,2)-(6,2)))
                                ],
                                range: (6, 2)-(6, 3)))
                            ], range: (6, 0)-(6,3))
                        ]))
                       ]))
    }
    
    func testCase289() throws {
        // HTML: <ul>\n<li>a\n<ul>\n<li>\n<p>b</p>\n<p>c</p>\n</li>\n</ul>\n</li>\n<li>d</li>\n</ul>\n
        /* Markdown
         - a
         - b
         
         c
         - d
         
         */
        XCTAssertEqual(try compile("- a\n  - b\n\n    c\n- d\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "a", range: (0,2)-(0,2)))
                                ],
                                range: (0, 2)-(0, 3))),
                                .list(List(info: ListInfo(isTight: false, kind: .bulleted), items: [
                                    ListItem(elements: [
                                        .paragraph(Paragraph(text: [
                                            .text(InlineString(text: "b", range: (1,4)-(1,4)))
                                        ],
                                        range: (1, 4)-(1, 5))),
                                        .paragraph(Paragraph(text: [
                                            .text(InlineString(text: "c", range: (3,4)-(3,4)))
                                        ],
                                        range: (3, 4)-(3, 5)))
                                    ], range: (1, 2)-(3,5))
                                ]))
                            ], range: (0, 0)-(3,5)),
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "d", range: (4,2)-(4,2)))
                                ],
                                range: (4, 2)-(4, 3)))
                            ], range: (4, 0)-(4,3))
                        ]))
                       ]))
    }
    
    func testCase290() throws {
        // HTML: <ul>\n<li>a\n<blockquote>\n<p>b</p>\n</blockquote>\n</li>\n<li>c</li>\n</ul>\n
        /* Markdown
         * a
         > b
         >
         * c
         
         */
        XCTAssertEqual(try compile("* a\n  > b\n  >\n* c\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "a", range: (0,2)-(0,2)))
                                ],
                                range: (0, 2)-(0, 3))),
                                .blockQuote(BlockQuote(blocks: [
                                    .paragraph(Paragraph(text: [
                                        .text(InlineString(text: "b", range: (1,4)-(1,4)))
                                    ],
                                    range: (1, 4)-(1, 5)))
                                ],
                                range: (1, 2)-(2, 3)))
                            ], range: (0, 0)-(2,3)),
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "c", range: (3,2)-(3,2)))
                                ],
                                range: (3, 2)-(3, 3)))
                            ], range: (3, 0)-(3,3))
                        ]))
                       ]))
    }
    
    func testCase291() throws {
        // HTML: <ul>\n<li>a\n<blockquote>\n<p>b</p>\n</blockquote>\n<pre><code>c\n</code></pre>\n</li>\n<li>d</li>\n</ul>\n
        /* Markdown
         - a
         > b
         ```
         c
         ```
         - d
         
         */
        XCTAssertEqual(try compile("- a\n  > b\n  ```\n  c\n  ```\n- d\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "a", range: (0,2)-(0,2)))
                                ],
                                range: (0, 2)-(0, 3))),
                                .blockQuote(BlockQuote(blocks: [
                                    .paragraph(Paragraph(text: [
                                        .text(InlineString(text: "b", range: (1,4)-(1,4)))
                                    ],
                                    range: (1, 4)-(1, 5)))
                                ],
                                range: (1, 2)-(1, 5))),
                                .codeBlock(CodeBlock(infoString: "", content: "c\n", range: (2, 2)-(4, 5)))
                            ], range: (0, 0)-(4,5)),
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "d", range: (5,2)-(5,2)))
                                ],
                                range: (5, 2)-(5, 3)))
                            ], range: (5, 0)-(5,3))
                        ]))
                       ]))
    }
    
    func testCase292() throws {
        // HTML: <ul>\n<li>a</li>\n</ul>\n
        /* Markdown
         - a
         
         */
        XCTAssertEqual(try compile("- a\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "a", range: (0,2)-(0,2)))
                                ],
                                range: (0, 2)-(0, 3)))
                            ], range: (0, 0)-(0,3))
                        ]))
                       ]))
    }
    
    func testCase293() throws {
        // HTML: <ul>\n<li>a\n<ul>\n<li>b</li>\n</ul>\n</li>\n</ul>\n
        /* Markdown
         - a
         - b
         
         */
        XCTAssertEqual(try compile("- a\n  - b\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "a", range: (0,2)-(0,2)))
                                ],
                                range: (0, 2)-(0, 3))),
                                .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                                    ListItem(elements: [
                                        .paragraph(Paragraph(text: [
                                            .text(InlineString(text: "b", range: (1,4)-(1,4)))
                                        ],
                                        range: (1, 4)-(1, 5)))
                                    ], range: (1, 2)-(1,5))
                                ]))
                            ], range: (0, 0)-(1,5))
                        ]))
                       ]))
    }
    
    func testCase294() throws {
        // HTML: <ol>\n<li>\n<pre><code>foo\n</code></pre>\n<p>bar</p>\n</li>\n</ol>\n
        /* Markdown
         1. ```
         foo
         ```
         
         bar
         
         */
        XCTAssertEqual(try compile("1. ```\n   foo\n   ```\n\n   bar\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: true, kind: .ordered(start: 1)), items: [
                            ListItem(elements: [
                                .codeBlock(CodeBlock(infoString: "", content: "foo\n", range: (0, 3)-(2, 6))),
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "bar", range: (4,3)-(4,5)))
                                ],
                                range: (4, 3)-(4, 6)))
                            ], range: (0, 0)-(4,6))
                        ]))
                       ]))
    }
    
    func testCase295() throws {
        // HTML: <ul>\n<li>\n<p>foo</p>\n<ul>\n<li>bar</li>\n</ul>\n<p>baz</p>\n</li>\n</ul>\n
        /* Markdown
         * foo
         * bar
         
         baz
         
         */
        XCTAssertEqual(try compile("* foo\n  * bar\n\n  baz\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: false, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "foo", range: (0,2)-(0,4)))
                                ],
                                range: (0, 2)-(0, 5))),
                                .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                                    ListItem(elements: [
                                        .paragraph(Paragraph(text: [
                                            .text(InlineString(text: "bar", range: (1,4)-(1,6)))
                                        ],
                                        range: (1, 4)-(1, 7)))
                                    ], range: (1, 2)-(1,7))
                                ])),
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "baz", range: (3,2)-(3,4)))
                                ],
                                range: (3, 2)-(3, 5)))
                            ], range: (0, 0)-(3,5))
                        ]))
                       ]))
    }
    
    func testCase296() throws {
        // HTML: <ul>\n<li>\n<p>a</p>\n<ul>\n<li>b</li>\n<li>c</li>\n</ul>\n</li>\n<li>\n<p>d</p>\n<ul>\n<li>e</li>\n<li>f</li>\n</ul>\n</li>\n</ul>\n
        /* Markdown
         - a
         - b
         - c
         
         - d
         - e
         - f
         
         */
        XCTAssertEqual(try compile("- a\n  - b\n  - c\n\n- d\n  - e\n  - f\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: false, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "a", range: (0,2)-(0,2)))
                                ],
                                range: (0, 2)-(0, 3))),
                                .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                                    ListItem(elements: [
                                        .paragraph(Paragraph(text: [
                                            .text(InlineString(text: "b", range: (1,4)-(1,4)))
                                        ],
                                        range: (1, 4)-(1, 5)))
                                    ], range: (1, 2)-(1,5)),
                                    ListItem(elements: [
                                        .paragraph(Paragraph(text: [
                                            .text(InlineString(text: "c", range: (2,4)-(2,4)))
                                        ],
                                        range: (2, 4)-(2, 5)))
                                    ], range: (2, 2)-(2,5))
                                ]))
                            ], range: (0, 0)-(2,5)),
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "d", range: (4,2)-(4,2)))
                                ],
                                range: (4, 2)-(4, 3))),
                                .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                                    ListItem(elements: [
                                        .paragraph(Paragraph(text: [
                                            .text(InlineString(text: "e", range: (5,4)-(5,4)))
                                        ],
                                        range: (5, 4)-(5, 5)))
                                    ], range: (5, 2)-(5,5)),
                                    ListItem(elements: [
                                        .paragraph(Paragraph(text: [
                                            .text(InlineString(text: "f", range: (6,4)-(6,4)))
                                        ],
                                        range: (6, 4)-(6, 5)))
                                    ], range: (6, 2)-(6,5))
                                ]))
                            ], range: (4, 0)-(6,5))
                        ]))
                       ]))
    }
    
    
}
