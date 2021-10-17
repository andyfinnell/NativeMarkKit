import Foundation
import XCTest
@testable import NativeMarkKit

final class BlockquotesTest: XCTestCase {
    func testCase198() throws {
        // HTML: <blockquote>\n<h1>Foo</h1>\n<p>bar\nbaz</p>\n</blockquote>\n
        /* Markdown
         > # Foo
         > bar
         > baz
         
         */
        XCTAssertEqual(try compile("> # Foo\n> bar\n> baz\n"),
                       Document(elements: [
                        .blockQuote(BlockQuote(blocks: [
                            .heading(Heading(level: 1,
                                             text: [
                                                .text(InlineString(text: "Foo", range: (0,4)-(0,6)))
                                             ],
                                             range: (0, 2)-(0, 7))),
                            .paragraph(Paragraph(text: [
                                .text(InlineString(text: "bar", range: (1,2)-(1,4))),
                                .softbreak(InlineSoftbreak(range: (1, 5)-(1, 5))),
                                .text(InlineString(text: "baz", range: (2,2)-(2,4)))
                            ],
                            range: (1, 2)-(2, 5)))
                        ],
                        range: (0, 0)-(2, 5)))
                       ]))
    }
    
    func testCase199() throws {
        // HTML: <blockquote>\n<h1>Foo</h1>\n<p>bar\nbaz</p>\n</blockquote>\n
        /* Markdown
         ># Foo
         >bar
         > baz
         
         */
        XCTAssertEqual(try compile("># Foo\n>bar\n> baz\n"),
                       Document(elements: [
                        .blockQuote(BlockQuote(blocks: [
                            .heading(Heading(level: 1,
                                             text: [
                                                .text(InlineString(text: "Foo", range: (0,3)-(0,5)))
                                             ],
                                             range: (0, 1)-(0, 6))),
                            .paragraph(Paragraph(text: [
                                .text(InlineString(text: "bar", range: (1,1)-(1,3))),
                                .softbreak(InlineSoftbreak(range: (1, 4)-(1, 4))),
                                .text(InlineString(text: "baz", range: (2,2)-(2,4)))
                            ],
                            range: (1, 1)-(2, 5)))
                        ],
                        range: (0, 0)-(2, 5)))
                       ]))
    }
    
    func testCase200() throws {
        // HTML: <blockquote>\n<h1>Foo</h1>\n<p>bar\nbaz</p>\n</blockquote>\n
        /* Markdown
         > # Foo
         > bar
         > baz
         
         */
        XCTAssertEqual(try compile("   > # Foo\n   > bar\n > baz\n"),
                       Document(elements: [
                        .blockQuote(BlockQuote(blocks: [
                            .heading(Heading(level: 1,
                                             text: [
                                                .text(InlineString(text: "Foo", range: (0,7)-(0,9)))
                                             ],
                                             range: (0, 5)-(0, 10))),
                            .paragraph(Paragraph(text: [
                                .text(InlineString(text: "bar", range: (1,5)-(1,7))),
                                .softbreak(InlineSoftbreak(range: (1, 8)-(1, 8))),
                                .text(InlineString(text: "baz", range: (2,3)-(2,5)))
                            ],
                            range: (1, 5)-(2, 6)))
                        ],
                        range: (0, 3)-(2, 6)))
                       ]))
    }
    
    func testCase201() throws {
        // HTML: <pre><code>&gt; # Foo\n&gt; bar\n&gt; baz\n</code></pre>\n
        /* Markdown
         > # Foo
         > bar
         > baz
         
         */
        XCTAssertEqual(try compile("    > # Foo\n    > bar\n    > baz\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "",
                                             content: "> # Foo\n> bar\n> baz\n",
                                             range: (0, 4)-(3, 0)))
                       ]))
    }
    
    func testCase202() throws {
        // HTML: <blockquote>\n<h1>Foo</h1>\n<p>bar\nbaz</p>\n</blockquote>\n
        /* Markdown
         > # Foo
         > bar
         baz
         
         */
        XCTAssertEqual(try compile("> # Foo\n> bar\nbaz\n"),
                       Document(elements: [
                        .blockQuote(BlockQuote(blocks: [
                            .heading(Heading(level: 1,
                                             text: [
                                                .text(InlineString(text: "Foo", range: (0,4)-(0,6)))
                                             ],
                                             range: (0, 2)-(0, 7))),
                            .paragraph(Paragraph(text: [
                                .text(InlineString(text: "bar", range: (1,2)-(1,4))),
                                .softbreak(InlineSoftbreak(range: (1, 5)-(1, 5))),
                                .text(InlineString(text: "baz", range: (2,0)-(2,2)))
                            ],
                            range: (1, 2)-(2, 3)))
                        ],
                        range: (0, 0)-(2, 3)))
                       ]))
    }
    
    func testCase203() throws {
        // HTML: <blockquote>\n<p>bar\nbaz\nfoo</p>\n</blockquote>\n
        /* Markdown
         > bar
         baz
         > foo
         
         */
        XCTAssertEqual(try compile("> bar\nbaz\n> foo\n"),
                       Document(elements: [
                        .blockQuote(BlockQuote(blocks: [
                            .paragraph(Paragraph(text: [
                                .text(InlineString(text: "bar", range: (0,2)-(0,4))),
                                .softbreak(InlineSoftbreak(range: (0, 5)-(0, 5))),
                                .text(InlineString(text: "baz", range: (1,0)-(1,2))),
                                .softbreak(InlineSoftbreak(range: (1, 3)-(1, 3))),
                                .text(InlineString(text: "foo", range: (2,2)-(2,4)))
                            ],
                            range: (0, 2)-(2, 5)))
                        ],
                        range: (0, 0)-(2, 5)))
                       ]))
    }
    
    func testCase204() throws {
        // HTML: <blockquote>\n<p>foo</p>\n</blockquote>\n<hr />\n
        /* Markdown
         > foo
         ---
         
         */
        XCTAssertEqual(try compile("> foo\n---\n"),
                       Document(elements: [
                        .blockQuote(BlockQuote(blocks: [
                            .paragraph(Paragraph(text: [
                                .text(InlineString(text: "foo", range: (0,2)-(0,4)))
                            ],
                            range: (0, 2)-(0, 5)))
                        ],
                        range: (0, 0)-(0, 5))),
                        .thematicBreak(ThematicBreak(range: (1, 0)-(1, 3)))
                       ]))
    }
    
    func testCase205() throws {
        // HTML: <blockquote>\n<ul>\n<li>foo</li>\n</ul>\n</blockquote>\n<ul>\n<li>bar</li>\n</ul>\n
        /* Markdown
         > - foo
         - bar
         
         */
        XCTAssertEqual(try compile("> - foo\n- bar\n"),
                       Document(elements: [
                        .blockQuote(BlockQuote(blocks: [
                            .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                                ListItem(elements: [
                                    .paragraph(Paragraph(text: [
                                        .text(InlineString(text: "foo", range: (0,4)-(0,6)))
                                    ],
                                    range: (0, 4)-(0, 7)))
                                ], range: (0, 2)-(0,7))
                            ]))
                        ],
                        range: (0, 0)-(0, 7))),
                        .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "bar", range: (1,2)-(1,4)))
                                ],
                                range: (1, 2)-(1, 5)))
                            ], range: (1, 0)-(1,5))
                        ]))
                       ]))
    }
    
    func testCase206() throws {
        // HTML: <blockquote>\n<pre><code>foo\n</code></pre>\n</blockquote>\n<pre><code>bar\n</code></pre>\n
        /* Markdown
         >     foo
         bar
         
         */
        XCTAssertEqual(try compile(">     foo\n    bar\n"),
                       Document(elements: [
                        .blockQuote(BlockQuote(blocks: [
                            .codeBlock(CodeBlock(infoString: "", content: "foo\n", range: (0, 6)-(0, 9)))
                        ],
                        range: (0, 0)-(0, 9))),
                        .codeBlock(CodeBlock(infoString: "", content: "bar\n", range: (1, 4)-(2, 0)))
                       ]))
    }
    
    func testCase207() throws {
        // HTML: <blockquote>\n<pre><code></code></pre>\n</blockquote>\n<p>foo</p>\n<pre><code></code></pre>\n
        /* Markdown
         > ```
         foo
         ```
         
         */
        XCTAssertEqual(try compile("> ```\nfoo\n```\n"),
                       Document(elements: [
                        .blockQuote(BlockQuote(blocks: [
                            .codeBlock(CodeBlock(infoString: "", content: "", range: (0, 2)-(0, 5)))
                        ],
                        range: (0, 0)-(0, 5))),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo", range: (1,0)-(1,2)))
                        ],
                        range: (1, 0)-(1, 3))),
                        .codeBlock(CodeBlock(infoString: "", content: "", range: (2, 0)-(3, 0)))
                       ]))
    }
    
    func testCase208() throws {
        // HTML: <blockquote>\n<p>foo\n- bar</p>\n</blockquote>\n
        /* Markdown
         > foo
         - bar
         
         */
        XCTAssertEqual(try compile("> foo\n    - bar\n"),
                       Document(elements: [
                        .blockQuote(BlockQuote(blocks: [
                            .paragraph(Paragraph(text: [
                                .text(InlineString(text: "foo", range: (0,2)-(0,4))),
                                .softbreak(InlineSoftbreak(range: (0, 5)-(1, 3))),
                                .text(InlineString(text: "- bar", range: (1,4)-(1,8)))
                            ],
                            range: (0, 2)-(1, 9)))
                        ],
                        range: (0, 0)-(1, 9)))
                       ]))
    }
    
    func testCase209() throws {
        // HTML: <blockquote>\n</blockquote>\n
        /* Markdown
         >
         
         */
        XCTAssertEqual(try compile(">\n"),
                       Document(elements: [
                        .blockQuote(BlockQuote(blocks: [
                            
                        ],
                        range: (0, 0)-(0, 1)))
                       ]))
    }
    
    func testCase210() throws {
        // HTML: <blockquote>\n</blockquote>\n
        /* Markdown
         >
         >
         >
         
         */
        XCTAssertEqual(try compile(">\n>  \n> \n"),
                       Document(elements: [
                        .blockQuote(BlockQuote(blocks: [
                            
                        ],
                        range: (0, 0)-(2, 2)))
                       ]))
    }
    
    func testCase211() throws {
        // HTML: <blockquote>\n<p>foo</p>\n</blockquote>\n
        /* Markdown
         >
         > foo
         >
         
         */
        XCTAssertEqual(try compile(">\n> foo\n>  \n"),
                       Document(elements: [
                        .blockQuote(BlockQuote(blocks: [
                            .paragraph(Paragraph(text: [
                                .text(InlineString(text: "foo", range: (1,2)-(1,4)))
                            ],
                            range: (1, 2)-(1, 5)))
                        ],
                        range: (0, 0)-(2, 3)))
                       ]))
    }
    
    func testCase212() throws {
        // HTML: <blockquote>\n<p>foo</p>\n</blockquote>\n<blockquote>\n<p>bar</p>\n</blockquote>\n
        /* Markdown
         > foo
         
         > bar
         
         */
        XCTAssertEqual(try compile("> foo\n\n> bar\n"),
                       Document(elements: [
                        .blockQuote(BlockQuote(blocks: [
                            .paragraph(Paragraph(text: [
                                .text(InlineString(text: "foo", range: (0,2)-(0,4)))
                            ],
                            range: (0, 2)-(0, 5)))
                        ],
                        range: (0, 0)-(0, 5))),
                        .blockQuote(BlockQuote(blocks: [
                            .paragraph(Paragraph(text: [
                                .text(InlineString(text: "bar", range: (2,2)-(2,4)))
                            ],
                            range: (2, 2)-(2, 5)))
                        ],
                        range: (2, 0)-(2, 5)))
                       ]))
    }
    
    func testCase213() throws {
        // HTML: <blockquote>\n<p>foo\nbar</p>\n</blockquote>\n
        /* Markdown
         > foo
         > bar
         
         */
        XCTAssertEqual(try compile("> foo\n> bar\n"),
                       Document(elements: [
                        .blockQuote(BlockQuote(blocks: [
                            .paragraph(Paragraph(text: [
                                .text(InlineString(text: "foo", range: (0,2)-(0,4))),
                                .softbreak(InlineSoftbreak(range: (0, 5)-(0, 5))),
                                .text(InlineString(text: "bar", range: (1,2)-(1,4)))
                            ],
                            range: (0, 2)-(1, 5)))
                        ],
                        range: (0, 0)-(1, 5)))
                       ]))
    }
    
    func testCase214() throws {
        // HTML: <blockquote>\n<p>foo</p>\n<p>bar</p>\n</blockquote>\n
        /* Markdown
         > foo
         >
         > bar
         
         */
        XCTAssertEqual(try compile("> foo\n>\n> bar\n"),
                       Document(elements: [
                        .blockQuote(BlockQuote(blocks: [
                            .paragraph(Paragraph(text: [
                                .text(InlineString(text: "foo", range: (0,2)-(0,4)))
                            ],
                            range: (0, 2)-(0, 5))),
                            .paragraph(Paragraph(text: [
                                .text(InlineString(text: "bar", range: (2,2)-(2,4)))
                            ],
                            range: (2, 2)-(2, 5)))
                        ],
                        range: (0, 0)-(2, 5)))
                       ]))
    }
    
    func testCase215() throws {
        // HTML: <p>foo</p>\n<blockquote>\n<p>bar</p>\n</blockquote>\n
        /* Markdown
         foo
         > bar
         
         */
        XCTAssertEqual(try compile("foo\n> bar\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo", range: (0,0)-(0,2)))
                        ],
                        range: (0, 0)-(0, 3))),
                        .blockQuote(BlockQuote(blocks: [
                            .paragraph(Paragraph(text: [
                                .text(InlineString(text: "bar", range: (1,2)-(1,4)))
                            ],
                            range: (1, 2)-(1, 5)))
                        ],
                        range: (1, 0)-(1, 5)))
                       ]))
    }
    
    func testCase216() throws {
        // HTML: <blockquote>\n<p>aaa</p>\n</blockquote>\n<hr />\n<blockquote>\n<p>bbb</p>\n</blockquote>\n
        /* Markdown
         > aaa
         ***
         > bbb
         
         */
        XCTAssertEqual(try compile("> aaa\n***\n> bbb\n"),
                       Document(elements: [
                        .blockQuote(BlockQuote(blocks: [
                            .paragraph(Paragraph(text: [
                                .text(InlineString(text: "aaa", range: (0,2)-(0,4)))
                            ],
                            range: (0, 2)-(0, 5)))
                        ],
                        range: (0, 0)-(0, 5))),
                        .thematicBreak(ThematicBreak(range: (1, 0)-(1, 3))),
                        .blockQuote(BlockQuote(blocks: [
                            .paragraph(Paragraph(text: [
                                .text(InlineString(text: "bbb", range: (2,2)-(2,4)))
                            ],
                            range: (2, 2)-(2, 5)))
                        ],
                        range: (2, 0)-(2, 5)))
                       ]))
    }
    
    func testCase217() throws {
        // HTML: <blockquote>\n<p>bar\nbaz</p>\n</blockquote>\n
        /* Markdown
         > bar
         baz
         
         */
        XCTAssertEqual(try compile("> bar\nbaz\n"),
                       Document(elements: [
                        .blockQuote(BlockQuote(blocks: [
                            .paragraph(Paragraph(text: [
                                .text(InlineString(text: "bar", range: (0,2)-(0,4))),
                                .softbreak(InlineSoftbreak(range: (0, 5)-(0, 5))),
                                .text(InlineString(text: "baz", range: (1,0)-(1,2)))
                            ],
                            range: (0, 2)-(1, 3)))
                        ],
                        range: (0, 0)-(1, 3)))
                       ]))
    }
    
    func testCase218() throws {
        // HTML: <blockquote>\n<p>bar</p>\n</blockquote>\n<p>baz</p>\n
        /* Markdown
         > bar
         
         baz
         
         */
        XCTAssertEqual(try compile("> bar\n\nbaz\n"),
                       Document(elements: [
                        .blockQuote(BlockQuote(blocks: [
                            .paragraph(Paragraph(text: [
                                .text(InlineString(text: "bar", range: (0,2)-(0,4)))
                            ],
                            range: (0, 2)-(0, 5)))
                        ],
                        range: (0, 0)-(0, 5))),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "baz", range: (2,0)-(2,2)))
                        ],
                        range: (2, 0)-(2, 3)))
                       ]))
    }
    
    func testCase219() throws {
        // HTML: <blockquote>\n<p>bar</p>\n</blockquote>\n<p>baz</p>\n
        /* Markdown
         > bar
         >
         baz
         
         */
        XCTAssertEqual(try compile("> bar\n>\nbaz\n"),
                       Document(elements: [
                        .blockQuote(BlockQuote(blocks: [
                            .paragraph(Paragraph(text: [
                                .text(InlineString(text: "bar", range: (0,2)-(0,4)))
                            ],
                            range: (0, 2)-(0, 5)))
                        ],
                        range: (0, 0)-(1, 1))),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "baz", range: (2,0)-(2,2)))
                        ],
                        range: (2, 0)-(2, 3)))
                       ]))
    }
    
    func testCase220() throws {
        // HTML: <blockquote>\n<blockquote>\n<blockquote>\n<p>foo\nbar</p>\n</blockquote>\n</blockquote>\n</blockquote>\n
        /* Markdown
         > > > foo
         bar
         
         */
        XCTAssertEqual(try compile("> > > foo\nbar\n"),
                       Document(elements: [
                        .blockQuote(BlockQuote(blocks: [
                            .blockQuote(BlockQuote(blocks: [
                                .blockQuote(BlockQuote(blocks: [
                                    .paragraph(Paragraph(text: [
                                        .text(InlineString(text: "foo", range: (0,6)-(0,8))),
                                        .softbreak(InlineSoftbreak(range: (0, 9)-(0, 9))),
                                        .text(InlineString(text: "bar", range: (1,0)-(1,2)))
                                    ],
                                    range: (0, 6)-(1, 3)))
                                ],
                                range: (0, 4)-(1, 3)))
                            ],
                            range: (0, 2)-(1, 3)))
                        ],
                        range: (0, 0)-(1, 3)))
                       ]))
    }
    
    func testCase221() throws {
        // HTML: <blockquote>\n<blockquote>\n<blockquote>\n<p>foo\nbar\nbaz</p>\n</blockquote>\n</blockquote>\n</blockquote>\n
        /* Markdown
         >>> foo
         > bar
         >>baz
         
         */
        XCTAssertEqual(try compile(">>> foo\n> bar\n>>baz\n"),
                       Document(elements: [
                        .blockQuote(BlockQuote(blocks: [
                            .blockQuote(BlockQuote(blocks: [
                                .blockQuote(BlockQuote(blocks: [
                                    .paragraph(Paragraph(text: [
                                        .text(InlineString(text: "foo", range: (0,4)-(0,6))),
                                        .softbreak(InlineSoftbreak(range: (0, 7)-(0, 7))),
                                        .text(InlineString(text: "bar", range: (1,2)-(1,4))),
                                        .softbreak(InlineSoftbreak(range: (1, 5)-(1, 5))),
                                        .text(InlineString(text: "baz", range: (2,2)-(2,4)))
                                    ],
                                    range: (0, 4)-(2, 5)))
                                ],
                                range: (0, 2)-(2, 5)))
                            ],
                            range: (0, 1)-(2, 5)))
                        ],
                        range: (0, 0)-(2, 5)))
                       ]))
    }
    
    func testCase222() throws {
        // HTML: <blockquote>\n<pre><code>code\n</code></pre>\n</blockquote>\n<blockquote>\n<p>not code</p>\n</blockquote>\n
        /* Markdown
         >     code
         
         >    not code
         
         */
        XCTAssertEqual(try compile(">     code\n\n>    not code\n"),
                       Document(elements: [
                        .blockQuote(BlockQuote(blocks: [
                            .codeBlock(CodeBlock(infoString: "",
                                                 content: "code\n",
                                                 range: (0, 6)-(0, 10)))
                        ],
                        range: (0, 0)-(0, 10))),
                        .blockQuote(BlockQuote(blocks: [
                            .paragraph(Paragraph(text: [
                                .text(InlineString(text: "not code", range: (2,5)-(2,12)))
                            ],
                            range: (2, 5)-(2, 13)))
                        ],
                        range: (2, 0)-(2, 13)))
                       ]))
    }
    
    
}
