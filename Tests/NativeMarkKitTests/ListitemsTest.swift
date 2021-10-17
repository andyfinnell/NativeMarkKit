import Foundation
import XCTest
@testable import NativeMarkKit

final class ListitemsTest: XCTestCase {
    func testCase223() throws {
        // HTML: <p>A paragraph\nwith two lines.</p>\n<pre><code>indented code\n</code></pre>\n<blockquote>\n<p>A block quote.</p>\n</blockquote>\n
        /* Markdown
         A paragraph
         with two lines.
         
         indented code
         
         > A block quote.
         
         */
        XCTAssertEqual(try compile("A paragraph\nwith two lines.\n\n    indented code\n\n> A block quote.\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "A paragraph", range: (0,0)-(0,10))),
                            .softbreak(InlineSoftbreak(range: (0, 11)-(0, 11))),
                            .text(InlineString(text: "with two lines.", range: (1,0)-(1,14)))
                        ],
                        range: (0, 0)-(1, 15))),
                        .codeBlock(CodeBlock(infoString: "", content: "indented code\n", range: (3, 4)-(4, 0))),
                        .blockQuote(BlockQuote(blocks: [
                            .paragraph(Paragraph(text: [
                                .text(InlineString(text: "A block quote.", range: (5,2)-(5,15)))
                            ],
                            range: (5, 2)-(5, 16)))
                        ],
                        range: (5, 0)-(5, 16)))
                       ]))
    }
    
    func testCase224() throws {
        // HTML: <ol>\n<li>\n<p>A paragraph\nwith two lines.</p>\n<pre><code>indented code\n</code></pre>\n<blockquote>\n<p>A block quote.</p>\n</blockquote>\n</li>\n</ol>\n
        /* Markdown
         1.  A paragraph
         with two lines.
         
         indented code
         
         > A block quote.
         
         */
        XCTAssertEqual(try compile("1.  A paragraph\n    with two lines.\n\n        indented code\n\n    > A block quote.\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: false, kind: .ordered(start: 1)), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "A paragraph", range: (0,4)-(0,14))),
                                    .softbreak(InlineSoftbreak(range: (0, 15)-(0, 15))),
                                    .text(InlineString(text: "with two lines.", range: (1,4)-(1,18)))
                                ],
                                range: (0, 4)-(1, 19))),
                                .codeBlock(CodeBlock(infoString: "", content: "indented code\n", range: (3, 8)-(4, 0))),
                                .blockQuote(BlockQuote(blocks: [
                                    .paragraph(Paragraph(text: [
                                        .text(InlineString(text: "A block quote.", range: (5,6)-(5,19)))
                                    ],
                                    range: (5, 6)-(5, 20)))
                                ],
                                range: (5, 4)-(5, 20)))
                            ])
                        ]))
                       ]))
    }
    
    func testCase225() throws {
        // HTML: <ul>\n<li>one</li>\n</ul>\n<p>two</p>\n
        /* Markdown
         - one
         
         two
         
         */
        XCTAssertEqual(try compile("- one\n\n two\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "one", range: (0,2)-(0,4)))
                                ],
                                range: (0, 2)-(0, 5)))
                            ])
                        ])),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "two", range: (2,1)-(2,3)))
                        ],
                        range: (2, 1)-(2, 4)))
                       ]))
    }
    
    func testCase226() throws {
        // HTML: <ul>\n<li>\n<p>one</p>\n<p>two</p>\n</li>\n</ul>\n
        /* Markdown
         - one
         
         two
         
         */
        XCTAssertEqual(try compile("- one\n\n  two\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: false, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "one", range: (0,2)-(0,4)))
                                ],
                                range: (0, 2)-(0, 5))),
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "two", range: (2,2)-(2,4)))
                                ],
                                range: (2, 2)-(2, 5)))
                            ])
                        ]))
                       ]))
    }
    
    func testCase227() throws {
        // HTML: <ul>\n<li>one</li>\n</ul>\n<pre><code> two\n</code></pre>\n
        /* Markdown
         -    one
         
         two
         
         */
        XCTAssertEqual(try compile(" -    one\n\n     two\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "one", range: (0,6)-(0,8)))
                                ],
                                range: (0, 6)-(0, 9)))
                            ])
                        ])),
                        .codeBlock(CodeBlock(infoString: "", content: " two\n", range: (2, 4)-(3, 0)))
                       ]))
    }
    
    func testCase228() throws {
        // HTML: <ul>\n<li>\n<p>one</p>\n<p>two</p>\n</li>\n</ul>\n
        /* Markdown
         -    one
         
         two
         
         */
        XCTAssertEqual(try compile(" -    one\n\n      two\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: false, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "one", range: (0,6)-(0,8)))
                                ],
                                range: (0, 6)-(0, 9))),
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "two", range: (2,6)-(2,8)))
                                ],
                                range: (2, 6)-(2, 9)))
                            ])
                        ]))
                       ]))
    }
    
    func testCase229() throws {
        // HTML: <blockquote>\n<blockquote>\n<ol>\n<li>\n<p>one</p>\n<p>two</p>\n</li>\n</ol>\n</blockquote>\n</blockquote>\n
        /* Markdown
         > > 1.  one
         >>
         >>     two
         
         */
        XCTAssertEqual(try compile("   > > 1.  one\n>>\n>>     two\n"),
                       Document(elements: [
                        .blockQuote(BlockQuote(blocks: [
                            .blockQuote(BlockQuote(blocks: [
                                .list(List(info: ListInfo(isTight: false, kind: .ordered(start: 1)), items: [
                                    ListItem(elements: [
                                        .paragraph(Paragraph(text: [
                                            .text(InlineString(text: "one", range: (0,11)-(0,13)))
                                        ],
                                        range: (0, 11)-(0, 14))),
                                        .paragraph(Paragraph(text: [
                                            .text(InlineString(text: "two", range: (2,7)-(2,9)))
                                        ],
                                        range: (2, 7)-(2, 10)))
                                    ])
                                ]))
                            ],
                            range: (0, 5)-(2, 10)))
                        ],
                        range: (0, 3)-(2, 10)))
                       ]))
    }
    
    func testCase230() throws {
        // HTML: <blockquote>\n<blockquote>\n<ul>\n<li>one</li>\n</ul>\n<p>two</p>\n</blockquote>\n</blockquote>\n
        /* Markdown
         >>- one
         >>
         >  > two
         
         */
        XCTAssertEqual(try compile(">>- one\n>>\n  >  > two\n"),
                       Document(elements: [
                        .blockQuote(BlockQuote(blocks: [
                            .blockQuote(BlockQuote(blocks: [
                                .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                                    ListItem(elements: [
                                        .paragraph(Paragraph(text: [
                                            .text(InlineString(text: "one", range: (0,4)-(0,6)))
                                        ],
                                        range: (0, 4)-(0, 7)))
                                    ])
                                ])),
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "two", range: (2,7)-(2,9)))
                                ],
                                range: (2, 7)-(2, 10)))
                            ],
                            range: (0, 1)-(2, 10)))
                        ],
                        range: (0, 0)-(2, 10)))
                       ]))
    }
    
    func testCase231() throws {
        // HTML: <p>-one</p>\n<p>2.two</p>\n
        /* Markdown
         -one
         
         2.two
         
         */
        XCTAssertEqual(try compile("-one\n\n2.two\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "-one", range: (0,0)-(0,3)))
                        ],
                        range: (0, 0)-(0, 4))),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "2.two", range: (2,0)-(2,4)))
                        ],
                        range: (2, 0)-(2, 5)))
                       ]))
    }
    
    func testCase232() throws {
        // HTML: <ul>\n<li>\n<p>foo</p>\n<p>bar</p>\n</li>\n</ul>\n
        /* Markdown
         - foo
         
         
         bar
         
         */
        XCTAssertEqual(try compile("- foo\n\n\n  bar\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: false, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "foo", range: (0,2)-(0,4)))
                                ],
                                range: (0, 2)-(0, 5))),
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "bar", range: (3,2)-(3,4)))
                                ],
                                range: (3, 2)-(3, 5)))
                            ])
                        ]))
                       ]))
    }
    
    func testCase233() throws {
        // HTML: <ol>\n<li>\n<p>foo</p>\n<pre><code>bar\n</code></pre>\n<p>baz</p>\n<blockquote>\n<p>bam</p>\n</blockquote>\n</li>\n</ol>\n
        /* Markdown
         1.  foo
         
         ```
         bar
         ```
         
         baz
         
         > bam
         
         */
        XCTAssertEqual(try compile("1.  foo\n\n    ```\n    bar\n    ```\n\n    baz\n\n    > bam\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: false, kind: .ordered(start: 1)), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "foo", range: (0,4)-(0,6)))
                                ],
                                range: (0, 4)-(0, 7))),
                                .codeBlock(CodeBlock(infoString: "", content: "bar\n", range: (2, 4)-(4, 7))),
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "baz", range: (6,4)-(6,6)))
                                ],
                                range: (6, 4)-(6, 7))),
                                .blockQuote(BlockQuote(blocks: [
                                    .paragraph(Paragraph(text: [
                                        .text(InlineString(text: "bam", range: (8,6)-(8,8)))
                                    ],
                                    range: (8, 6)-(8, 9)))
                                ],
                                range: (8, 4)-(8, 9)))
                            ])
                        ]))
                       ]))
    }
    
    func testCase234() throws {
        // HTML: <ul>\n<li>\n<p>Foo</p>\n<pre><code>bar\n\n\nbaz\n</code></pre>\n</li>\n</ul>\n
        /* Markdown
         - Foo
         
         bar
         
         
         baz
         
         */
        XCTAssertEqual(try compile("- Foo\n\n      bar\n\n\n      baz\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: false, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "Foo", range: (0,2)-(0,4)))
                                ],
                                range: (0, 2)-(0, 5))),
                                .codeBlock(CodeBlock(infoString: "", content: "bar\n\n\nbaz\n", range: (2, 6)-(6, 0)))
                            ])
                        ]))
                       ]))
    }
    
    func testCase235() throws {
        // HTML: <ol start=\"123456789\">\n<li>ok</li>\n</ol>\n
        /* Markdown
         123456789. ok
         
         */
        XCTAssertEqual(try compile("123456789. ok\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: true, kind: .ordered(start: 123456789)), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "ok", range: (0,11)-(0,12)))
                                ],
                                range: (0, 11)-(0, 13)))
                            ])
                        ]))
                       ]))
    }
    
    func testCase236() throws {
        // HTML: <p>1234567890. not ok</p>\n
        /* Markdown
         1234567890. not ok
         
         */
        XCTAssertEqual(try compile("1234567890. not ok\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "1234567890. not ok", range: (0,0)-(0,17)))
                        ],
                        range: (0, 0)-(0, 18)))
                       ]))
    }
    
    func testCase237() throws {
        // HTML: <ol start=\"0\">\n<li>ok</li>\n</ol>\n
        /* Markdown
         0. ok
         
         */
        XCTAssertEqual(try compile("0. ok\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: true, kind: .ordered(start: 0)), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "ok", range: (0,3)-(0,4)))
                                ],
                                range: (0, 3)-(0, 5)))
                            ])
                        ]))
                       ]))
    }
    
    func testCase238() throws {
        // HTML: <ol start=\"3\">\n<li>ok</li>\n</ol>\n
        /* Markdown
         003. ok
         
         */
        XCTAssertEqual(try compile("003. ok\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: true, kind: .ordered(start: 3)), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "ok", range: (0,5)-(0,6)))
                                ],
                                range: (0, 5)-(0, 7)))
                            ])
                        ]))
                       ]))
    }
    
    func testCase239() throws {
        // HTML: <p>-1. not ok</p>\n
        /* Markdown
         -1. not ok
         
         */
        XCTAssertEqual(try compile("-1. not ok\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "-1. not ok", range: (0,0)-(0,9)))
                        ],
                        range: (0, 0)-(0, 10)))
                       ]))
    }
    
    func testCase240() throws {
        // HTML: <ul>\n<li>\n<p>foo</p>\n<pre><code>bar\n</code></pre>\n</li>\n</ul>\n
        /* Markdown
         - foo
         
         bar
         
         */
        XCTAssertEqual(try compile("- foo\n\n      bar\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: false, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "foo", range: (0,2)-(0,4)))
                                ],
                                range: (0, 2)-(0, 5))),
                                .codeBlock(CodeBlock(infoString: "", content: "bar\n", range: (2, 6)-(3, 0)))
                            ])
                        ]))
                       ]))
    }
    
    func testCase241() throws {
        // HTML: <ol start=\"10\">\n<li>\n<p>foo</p>\n<pre><code>bar\n</code></pre>\n</li>\n</ol>\n
        /* Markdown
         10.  foo
         
         bar
         
         */
        XCTAssertEqual(try compile("  10.  foo\n\n           bar\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: false, kind: .ordered(start: 10)), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "foo", range: (0,7)-(0,9)))
                                ],
                                range: (0, 7)-(0, 10))),
                                .codeBlock(CodeBlock(infoString: "", content: "bar\n", range: (2, 11)-(3, 0)))
                            ])
                        ]))
                       ]))
    }
    
    func testCase242() throws {
        // HTML: <pre><code>indented code\n</code></pre>\n<p>paragraph</p>\n<pre><code>more code\n</code></pre>\n
        /* Markdown
         indented code
         
         paragraph
         
         more code
         
         */
        XCTAssertEqual(try compile("    indented code\n\nparagraph\n\n    more code\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "", content: "indented code\n", range: (0, 4)-(1, 0))),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "paragraph", range: (2,0)-(2,8)))
                        ],
                        range: (2, 0)-(2, 9))),
                        .codeBlock(CodeBlock(infoString: "", content: "more code\n", range: (4, 4)-(5, 0)))
                       ]))
    }
    
    func testCase243() throws {
        // HTML: <ol>\n<li>\n<pre><code>indented code\n</code></pre>\n<p>paragraph</p>\n<pre><code>more code\n</code></pre>\n</li>\n</ol>\n
        /* Markdown
         1.     indented code
         
         paragraph
         
         more code
         
         */
        XCTAssertEqual(try compile("1.     indented code\n\n   paragraph\n\n       more code\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: false, kind: .ordered(start: 1)), items: [
                            ListItem(elements: [
                                .codeBlock(CodeBlock(infoString: "", content: "indented code\n", range: (0, 7)-(1, 0))),
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "paragraph", range: (2,3)-(2,11)))
                                ],
                                range: (2, 3)-(2, 12))),
                                .codeBlock(CodeBlock(infoString: "", content: "more code\n", range: (4, 7)-(5, 0)))
                            ])
                        ]))
                       ]))
    }
    
    func testCase244() throws {
        // HTML: <ol>\n<li>\n<pre><code> indented code\n</code></pre>\n<p>paragraph</p>\n<pre><code>more code\n</code></pre>\n</li>\n</ol>\n
        /* Markdown
         1.      indented code
         
         paragraph
         
         more code
         
         */
        XCTAssertEqual(try compile("1.      indented code\n\n   paragraph\n\n       more code\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: false, kind: .ordered(start: 1)), items: [
                            ListItem(elements: [
                                .codeBlock(CodeBlock(infoString: "", content: " indented code\n", range: (0, 7)-(1, 0))),
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "paragraph", range: (2,3)-(2,11)))
                                ],
                                range: (2, 3)-(2, 12))),
                                .codeBlock(CodeBlock(infoString: "", content: "more code\n", range: (4, 7)-(5, 0)))
                            ])
                        ]))
                       ]))
    }
    
    func testCase245() throws {
        // HTML: <p>foo</p>\n<p>bar</p>\n
        /* Markdown
         foo
         
         bar
         
         */
        XCTAssertEqual(try compile("   foo\n\nbar\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo", range: (0,3)-(0,5)))
                        ],
                        range: (0, 3)-(0, 6))),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "bar", range: (2,0)-(2,2)))
                        ],
                        range: (2, 0)-(2, 3)))
                       ]))
    }
    
    func testCase246() throws {
        // HTML: <ul>\n<li>foo</li>\n</ul>\n<p>bar</p>\n
        /* Markdown
         -    foo
         
         bar
         
         */
        XCTAssertEqual(try compile("-    foo\n\n  bar\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "foo", range: (0,5)-(0,7)))
                                ],
                                range: (0, 5)-(0, 8)))
                            ])
                        ])),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "bar", range: (2,2)-(2,4)))
                        ],
                        range: (2, 2)-(2, 5)))
                       ]))
    }
    
    func testCase247() throws {
        // HTML: <ul>\n<li>\n<p>foo</p>\n<p>bar</p>\n</li>\n</ul>\n
        /* Markdown
         -  foo
         
         bar
         
         */
        XCTAssertEqual(try compile("-  foo\n\n   bar\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: false, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "foo", range: (0,3)-(0,5)))
                                ],
                                range: (0, 3)-(0, 6))),
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "bar", range: (2,3)-(2,5)))
                                ],
                                range: (2, 3)-(2, 6)))
                            ])
                        ]))
                       ]))
    }
    
    func testCase248() throws {
        // HTML: <ul>\n<li>foo</li>\n<li>\n<pre><code>bar\n</code></pre>\n</li>\n<li>\n<pre><code>baz\n</code></pre>\n</li>\n</ul>\n
        /* Markdown
         -
         foo
         -
         ```
         bar
         ```
         -
         baz
         
         */
        XCTAssertEqual(try compile("-\n  foo\n-\n  ```\n  bar\n  ```\n-\n      baz\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "foo", range: (1,2)-(1,4)))
                                ],
                                range: (1, 2)-(1, 5)))
                            ]),
                            ListItem(elements: [
                                .codeBlock(CodeBlock(infoString: "", content: "bar\n", range: (3, 2)-(5, 5)))
                            ]),
                            ListItem(elements: [
                                .codeBlock(CodeBlock(infoString: "", content: "baz\n", range: (7, 6)-(8, 0)))
                            ])
                        ]))
                       ]))
    }
    
    func testCase249() throws {
        // HTML: <ul>\n<li>foo</li>\n</ul>\n
        /* Markdown
         -   
         foo
         
         */
        XCTAssertEqual(try compile("-   \n  foo\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "foo", range: (1,2)-(1,4)))
                                ],
                                range: (1, 2)-(1, 5)))
                            ])
                        ]))
                       ]))
    }
    
    func testCase250() throws {
        // HTML: <ul>\n<li></li>\n</ul>\n<p>foo</p>\n
        /* Markdown
         -
         
         foo
         
         */
        XCTAssertEqual(try compile("-\n\n  foo\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                            ListItem(elements: [
                                
                            ])
                        ])),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo", range: (2,2)-(2,4)))
                        ],
                        range: (2, 2)-(2, 5)))
                       ]))
    }
    
    func testCase251() throws {
        // HTML: <ul>\n<li>foo</li>\n<li></li>\n<li>bar</li>\n</ul>\n
        /* Markdown
         - foo
         -
         - bar
         
         */
        XCTAssertEqual(try compile("- foo\n-\n- bar\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "foo", range: (0,2)-(0,4)))
                                ],
                                range: (0, 2)-(0, 5)))
                            ]),
                            ListItem(elements: [
                                
                            ]),
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "bar", range: (2,2)-(2,4)))
                                ],
                                range: (2, 2)-(2, 5)))
                            ])
                        ]))
                       ]))
    }
    
    func testCase252() throws {
        // HTML: <ul>\n<li>foo</li>\n<li></li>\n<li>bar</li>\n</ul>\n
        /* Markdown
         - foo
         -   
         - bar
         
         */
        XCTAssertEqual(try compile("- foo\n-   \n- bar\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "foo", range: (0,2)-(0,4)))
                                ],
                                range: (0, 2)-(0, 5)))
                            ]),
                            ListItem(elements: [
                                
                            ]),
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "bar", range: (2,2)-(2,4)))
                                ],
                                range: (2, 2)-(2, 5)))
                            ])
                        ]))
                       ]))
    }
    
    func testCase253() throws {
        // HTML: <ol>\n<li>foo</li>\n<li></li>\n<li>bar</li>\n</ol>\n
        /* Markdown
         1. foo
         2.
         3. bar
         
         */
        XCTAssertEqual(try compile("1. foo\n2.\n3. bar\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: true, kind: .ordered(start: 1)), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "foo", range: (0,3)-(0,5)))
                                ],
                                range: (0, 3)-(0, 6)))
                            ]),
                            ListItem(elements: [
                                
                            ]),
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "bar", range: (2,3)-(2,5)))
                                ],
                                range: (2, 3)-(2, 6)))
                            ])
                        ]))
                       ]))
    }
    
    func testCase254() throws {
        // HTML: <ul>\n<li></li>\n</ul>\n
        /* Markdown
         *
         
         */
        XCTAssertEqual(try compile("*\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                            ListItem(elements: [
                                
                            ])
                        ]))
                       ]))
    }
    
    func testCase255() throws {
        // HTML: <p>foo\n*</p>\n<p>foo\n1.</p>\n
        /* Markdown
         foo
         *
         
         foo
         1.
         
         */
        XCTAssertEqual(try compile("foo\n*\n\nfoo\n1.\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo", range: (0,0)-(0,2))),
                            .softbreak(InlineSoftbreak(range: (0, 3)-(0, 3))),
                            .text(InlineString(text: "*", range: (1,0)-(1,0)))
                        ],
                        range: (0, 0)-(1, 1))),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo", range: (3,0)-(3,2))),
                            .softbreak(InlineSoftbreak(range: (3, 3)-(3, 3))),
                            .text(InlineString(text: "1.", range: (4,0)-(4,1)))
                        ],
                        range: (3, 0)-(4, 2)))
                       ]))
    }
    
    func testCase256() throws {
        // HTML: <ol>\n<li>\n<p>A paragraph\nwith two lines.</p>\n<pre><code>indented code\n</code></pre>\n<blockquote>\n<p>A block quote.</p>\n</blockquote>\n</li>\n</ol>\n
        /* Markdown
         1.  A paragraph
         with two lines.
         
         indented code
         
         > A block quote.
         
         */
        XCTAssertEqual(try compile(" 1.  A paragraph\n     with two lines.\n\n         indented code\n\n     > A block quote.\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: false, kind: .ordered(start: 1)), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "A paragraph", range: (0,5)-(0,15))),
                                    .softbreak(InlineSoftbreak(range: (0, 16)-(0, 16))),
                                    .text(InlineString(text: "with two lines.", range: (1,5)-(1,19)))
                                ],
                                range: (0, 5)-(1, 20))),
                                .codeBlock(CodeBlock(infoString: "", content: "indented code\n", range: (3, 9)-(4, 0))),
                                .blockQuote(BlockQuote(blocks: [
                                    .paragraph(Paragraph(text: [
                                        .text(InlineString(text: "A block quote.", range: (5,7)-(5,20)))
                                    ],
                                    range: (5, 7)-(5, 21)))
                                ],
                                range: (5, 5)-(5, 21)))
                            ])
                        ]))
                       ]))
    }
    
    func testCase257() throws {
        // HTML: <ol>\n<li>\n<p>A paragraph\nwith two lines.</p>\n<pre><code>indented code\n</code></pre>\n<blockquote>\n<p>A block quote.</p>\n</blockquote>\n</li>\n</ol>\n
        /* Markdown
         1.  A paragraph
         with two lines.
         
         indented code
         
         > A block quote.
         
         */
        XCTAssertEqual(try compile("  1.  A paragraph\n      with two lines.\n\n          indented code\n\n      > A block quote.\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: false, kind: .ordered(start: 1)), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "A paragraph", range: (0,6)-(0,16))),
                                    .softbreak(InlineSoftbreak(range: (0, 17)-(0, 17))),
                                    .text(InlineString(text: "with two lines.", range: (1,6)-(1,20)))
                                ],
                                range: (0, 6)-(1, 21))),
                                .codeBlock(CodeBlock(infoString: "", content: "indented code\n", range: (3, 10)-(4, 0))),
                                .blockQuote(BlockQuote(blocks: [
                                    .paragraph(Paragraph(text: [
                                        .text(InlineString(text: "A block quote.", range: (5,8)-(5,21)))
                                    ],
                                    range: (5, 8)-(5, 22)))
                                ],
                                range: (5, 6)-(5, 22)))
                            ])
                        ]))
                       ]))
    }
    
    func testCase258() throws {
        // HTML: <ol>\n<li>\n<p>A paragraph\nwith two lines.</p>\n<pre><code>indented code\n</code></pre>\n<blockquote>\n<p>A block quote.</p>\n</blockquote>\n</li>\n</ol>\n
        /* Markdown
         1.  A paragraph
         with two lines.
         
         indented code
         
         > A block quote.
         
         */
        XCTAssertEqual(try compile("   1.  A paragraph\n       with two lines.\n\n           indented code\n\n       > A block quote.\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: false, kind: .ordered(start: 1)), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "A paragraph", range: (0,7)-(0,17))),
                                    .softbreak(InlineSoftbreak(range: (0, 18)-(0, 18))),
                                    .text(InlineString(text: "with two lines.", range: (1,7)-(1,21)))
                                ],
                                range: (0, 7)-(1, 22))),
                                .codeBlock(CodeBlock(infoString: "", content: "indented code\n", range: (3, 11)-(4, 0))),
                                .blockQuote(BlockQuote(blocks: [
                                    .paragraph(Paragraph(text: [
                                        .text(InlineString(text: "A block quote.", range: (5,9)-(5,22)))
                                    ],
                                    range: (5, 9)-(5, 23)))
                                ],
                                range: (5, 7)-(5, 23)))
                            ])
                        ]))
                       ]))
    }
    
    func testCase259() throws {
        // HTML: <pre><code>1.  A paragraph\n    with two lines.\n\n        indented code\n\n    &gt; A block quote.\n</code></pre>\n
        /* Markdown
         1.  A paragraph
         with two lines.
         
         indented code
         
         > A block quote.
         
         */
        XCTAssertEqual(try compile("    1.  A paragraph\n        with two lines.\n\n            indented code\n\n        > A block quote.\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "", content: "1.  A paragraph\n    with two lines.\n\n        indented code\n\n    > A block quote.\n", range: (0, 4)-(6, 0)))
                       ]))
    }
    
    func testCase260() throws {
        // HTML: <ol>\n<li>\n<p>A paragraph\nwith two lines.</p>\n<pre><code>indented code\n</code></pre>\n<blockquote>\n<p>A block quote.</p>\n</blockquote>\n</li>\n</ol>\n
        /* Markdown
         1.  A paragraph
         with two lines.
         
         indented code
         
         > A block quote.
         
         */
        XCTAssertEqual(try compile("  1.  A paragraph\nwith two lines.\n\n          indented code\n\n      > A block quote.\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: false, kind: .ordered(start: 1)), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "A paragraph", range: (0,6)-(0,16))),
                                    .softbreak(InlineSoftbreak(range: (0, 17)-(0, 17))),
                                    .text(InlineString(text: "with two lines.", range: (1,0)-(1,14)))
                                ],
                                range: (0, 6)-(1, 15))),
                                .codeBlock(CodeBlock(infoString: "", content: "indented code\n", range: (3, 10)-(4, 0))),
                                .blockQuote(BlockQuote(blocks: [
                                    .paragraph(Paragraph(text: [
                                        .text(InlineString(text: "A block quote.", range: (5,8)-(5,21)))
                                    ],
                                    range: (5, 8)-(5, 22)))
                                ],
                                range: (5, 6)-(5, 22)))
                            ])
                        ]))
                       ]))
    }
    
    func testCase261() throws {
        // HTML: <ol>\n<li>A paragraph\nwith two lines.</li>\n</ol>\n
        /* Markdown
         1.  A paragraph
         with two lines.
         
         */
        XCTAssertEqual(try compile("  1.  A paragraph\n    with two lines.\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: true, kind: .ordered(start: 1)), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "A paragraph", range: (0,6)-(0,16))),
                                    .softbreak(InlineSoftbreak(range: (0, 17)-(1, 3))),
                                    .text(InlineString(text: "with two lines.", range: (1,4)-(1,18)))
                                ],
                                range: (0, 6)-(1, 19)))
                            ])
                        ]))
                       ]))
    }
    
    func testCase262() throws {
        // HTML: <blockquote>\n<ol>\n<li>\n<blockquote>\n<p>Blockquote\ncontinued here.</p>\n</blockquote>\n</li>\n</ol>\n</blockquote>\n
        /* Markdown
         > 1. > Blockquote
         continued here.
         
         */
        XCTAssertEqual(try compile("> 1. > Blockquote\ncontinued here.\n"),
                       Document(elements: [
                        .blockQuote(BlockQuote(blocks: [
                            .list(List(info: ListInfo(isTight: true, kind: .ordered(start: 1)), items: [
                                ListItem(elements: [
                                    .blockQuote(BlockQuote(blocks: [
                                        .paragraph(Paragraph(text: [
                                            .text(InlineString(text: "Blockquote", range: (0,7)-(0,16))),
                                            .softbreak(InlineSoftbreak(range: (0, 17)-(0, 17))),
                                            .text(InlineString(text: "continued here.", range: (1,0)-(1,14)))
                                        ],
                                        range: (0, 7)-(1, 15)))
                                    ],
                                    range: (0, 5)-(1, 15)))
                                ])
                            ]))
                        ],
                        range: (0, 0)-(1, 15)))
                       ]))
    }
    
    func testCase263() throws {
        // HTML: <blockquote>\n<ol>\n<li>\n<blockquote>\n<p>Blockquote\ncontinued here.</p>\n</blockquote>\n</li>\n</ol>\n</blockquote>\n
        /* Markdown
         > 1. > Blockquote
         > continued here.
         
         */
        XCTAssertEqual(try compile("> 1. > Blockquote\n> continued here.\n"),
                       Document(elements: [
                        .blockQuote(BlockQuote(blocks: [
                            .list(List(info: ListInfo(isTight: true, kind: .ordered(start: 1)), items: [
                                ListItem(elements: [
                                    .blockQuote(BlockQuote(blocks: [
                                        .paragraph(Paragraph(text: [
                                            .text(InlineString(text: "Blockquote", range: (0,7)-(0,16))),
                                            .softbreak(InlineSoftbreak(range: (0, 17)-(0, 17))),
                                            .text(InlineString(text: "continued here.", range: (1,2)-(1,16)))
                                        ],
                                        range: (0, 7)-(1, 17)))
                                    ],
                                    range: (0, 5)-(1, 17)))
                                ])
                            ]))
                        ],
                        range: (0, 0)-(1, 17)))
                       ]))
    }
    
    func testCase264() throws {
        // HTML: <ul>\n<li>foo\n<ul>\n<li>bar\n<ul>\n<li>baz\n<ul>\n<li>boo</li>\n</ul>\n</li>\n</ul>\n</li>\n</ul>\n</li>\n</ul>\n
        /* Markdown
         - foo
         - bar
         - baz
         - boo
         
         */
        XCTAssertEqual(try compile("- foo\n  - bar\n    - baz\n      - boo\n"),
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
                                        .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                                            ListItem(elements: [
                                                .paragraph(Paragraph(text: [
                                                    .text(InlineString(text: "baz", range: (2,6)-(2,8)))
                                                ],
                                                range: (2, 6)-(2, 9))),
                                                .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                                                    ListItem(elements: [
                                                        .paragraph(Paragraph(text: [
                                                            .text(InlineString(text: "boo", range: (3,8)-(3,10)))
                                                        ],
                                                        range: (3, 8)-(3, 11)))
                                                    ])
                                                ]))
                                            ])
                                        ]))
                                    ])
                                ]))
                            ])
                        ]))
                       ]))
    }
    
    func testCase265() throws {
        // HTML: <ul>\n<li>foo</li>\n<li>bar</li>\n<li>baz</li>\n<li>boo</li>\n</ul>\n
        /* Markdown
         - foo
         - bar
         - baz
         - boo
         
         */
        XCTAssertEqual(try compile("- foo\n - bar\n  - baz\n   - boo\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "foo", range: (0,2)-(0,4)))
                                ],
                                range: (0, 2)-(0, 5)))
                            ]),
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "bar", range: (1,3)-(1,5)))
                                ],
                                range: (1, 3)-(1, 6)))
                            ]),
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "baz", range: (2,4)-(2,6)))
                                ],
                                range: (2, 4)-(2, 7)))
                            ]),
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "boo", range: (3,5)-(3,7)))
                                ],
                                range: (3, 5)-(3, 8)))
                            ])
                        ]))
                       ]))
    }
    
    func testCase266() throws {
        // HTML: <ol start=\"10\">\n<li>foo\n<ul>\n<li>bar</li>\n</ul>\n</li>\n</ol>\n
        /* Markdown
         10) foo
         - bar
         
         */
        XCTAssertEqual(try compile("10) foo\n    - bar\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: true, kind: .ordered(start: 10)), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "foo", range: (0,4)-(0,6)))
                                ],
                                range: (0, 4)-(0, 7))),
                                .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                                    ListItem(elements: [
                                        .paragraph(Paragraph(text: [
                                            .text(InlineString(text: "bar", range: (1,6)-(1,8)))
                                        ],
                                        range: (1, 6)-(1, 9)))
                                    ])
                                ]))
                            ])
                        ]))
                       ]))
    }
    
    func testCase267() throws {
        // HTML: <ol start=\"10\">\n<li>foo</li>\n</ol>\n<ul>\n<li>bar</li>\n</ul>\n
        /* Markdown
         10) foo
         - bar
         
         */
        XCTAssertEqual(try compile("10) foo\n   - bar\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: true, kind: .ordered(start: 10)), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "foo", range: (0,4)-(0,6)))
                                ],
                                range: (0, 4)-(0, 7)))
                            ])
                        ])),
                        .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "bar", range: (1,5)-(1,7)))
                                ],
                                range: (1, 5)-(1, 8)))
                            ])
                        ]))
                       ]))
    }
    
    func testCase268() throws {
        // HTML: <ul>\n<li>\n<ul>\n<li>foo</li>\n</ul>\n</li>\n</ul>\n
        /* Markdown
         - - foo
         
         */
        XCTAssertEqual(try compile("- - foo\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                            ListItem(elements: [
                                .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                                    ListItem(elements: [
                                        .paragraph(Paragraph(text: [
                                            .text(InlineString(text: "foo", range: (0,4)-(0,6)))
                                        ],
                                        range: (0, 4)-(0, 7)))
                                    ])
                                ]))
                            ])
                        ]))
                       ]))
    }
    
    func testCase269() throws {
        // HTML: <ol>\n<li>\n<ul>\n<li>\n<ol start=\"2\">\n<li>foo</li>\n</ol>\n</li>\n</ul>\n</li>\n</ol>\n
        /* Markdown
         1. - 2. foo
         
         */
        XCTAssertEqual(try compile("1. - 2. foo\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: true, kind: .ordered(start: 1)), items: [
                            ListItem(elements: [
                                .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                                    ListItem(elements: [
                                        .list(List(info: ListInfo(isTight: true, kind: .ordered(start: 2)), items: [
                                            ListItem(elements: [
                                                .paragraph(Paragraph(text: [
                                                    .text(InlineString(text: "foo", range: (0,8)-(0,10)))
                                                ],
                                                range: (0, 8)-(0, 11)))
                                            ])
                                        ]))
                                    ])
                                ]))
                            ])
                        ]))
                       ]))
    }
    
    func testCase270() throws {
        // HTML: <ul>\n<li>\n<h1>Foo</h1>\n</li>\n<li>\n<h2>Bar</h2>\nbaz</li>\n</ul>\n
        /* Markdown
         - # Foo
         - Bar
         ---
         baz
         
         */
        XCTAssertEqual(try compile("- # Foo\n- Bar\n  ---\n  baz\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                            ListItem(elements: [
                                .heading(Heading(level: 1,
                                                 text: [
                                                    .text(InlineString(text: "Foo", range: (0,4)-(0,6)))
                                                 ],
                                                 range: (0, 2)-(0, 7)))
                            ]),
                            ListItem(elements: [
                                .heading(Heading(level: 2,
                                                 text: [
                                                    .text(InlineString(text: "Bar", range: (1,2)-(1,4)))
                                                 ],
                                                 range: (1, 2)-(2, 5))),
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "baz", range: (3,2)-(3,4)))
                                ],
                                range: (3, 2)-(3, 5)))
                            ])
                        ]))
                       ]))
    }
    
    
}
