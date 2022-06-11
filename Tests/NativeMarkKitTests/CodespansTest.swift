import Foundation
import XCTest
@testable import NativeMarkKit

final class CodespansTest: XCTestCase {
    func testCase328() throws {
        // HTML: <p><code>foo</code></p>\n
        /* Markdown
         `foo`
         
         */
        XCTAssertEqual(try compile("`foo`\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .code(InlineCode(code: InlineString(text: "foo", range: (0, 1)-(0, 3)),
                                             range: (0, 0)-(0, 4)))
                        ],
                        range: (0, 0)-(0, 5)))
                       ]))
    }
    
    func testCase329() throws {
        // HTML: <p><code>foo ` bar</code></p>\n
        /* Markdown
         `` foo ` bar ``
         
         */
        XCTAssertEqual(try compile("`` foo ` bar ``\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .code(InlineCode(code: InlineString(text: "foo ` bar", range: (0, 3)-(0, 11)),
                                             range: (0, 0)-(0, 14)))
                        ],
                        range: (0, 0)-(0, 15)))
                       ]))
    }
    
    func testCase330() throws {
        // HTML: <p><code>``</code></p>\n
        /* Markdown
         ` `` `
         
         */
        XCTAssertEqual(try compile("` `` `\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .code(InlineCode(code: InlineString(text: "``", range: (0, 2)-(0, 3)),
                                             range: (0, 0)-(0, 5)))
                        ],
                        range: (0, 0)-(0, 6)))
                       ]))
    }
    
    func testCase331() throws {
        // HTML: <p><code> `` </code></p>\n
        /* Markdown
         `  ``  `
         
         */
        XCTAssertEqual(try compile("`  ``  `\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .code(InlineCode(code: InlineString(text: " `` ", range: (0, 2)-(0, 5)),
                                             range: (0, 0)-(0, 7)))
                        ],
                        range: (0, 0)-(0, 8)))
                       ]))
    }
    
    func testCase332() throws {
        // HTML: <p><code> a</code></p>\n
        /* Markdown
         ` a`
         
         */
        XCTAssertEqual(try compile("` a`\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .code(InlineCode(code: InlineString(text: " a", range: (0, 1)-(0, 2)),
                                             range: (0, 0)-(0, 3)))
                        ],
                        range: (0, 0)-(0, 4)))
                       ]))
    }
    
    func testCase333() throws {
        // HTML: <p><code> b </code></p>\n
        /* Markdown
         ` b `
         
         */
        XCTAssertEqual(try compile("` b `\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .code(InlineCode(code: InlineString(text: " b ", range: (0, 1)-(0, 3)),
                                             range: (0, 0)-(0, 4)))
                        ],
                        range: (0, 0)-(0, 5)))
                       ]))
    }
    
    func testCase334() throws {
        // HTML: <p><code> </code>\n<code>  </code></p>\n
        /* Markdown
         ` `
         `  `
         
         */
        XCTAssertEqual(try compile("` `\n`  `\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .code(InlineCode(code: InlineString(text: " ", range: (0, 1)-(0, 1)),
                                             range: (0, 0)-(0, 2))),
                            .softbreak(InlineSoftbreak(range: (0, 3)-(0, 3))),
                            .code(InlineCode(code: InlineString(text: "  ", range: (1, 1)-(1, 2)),
                                             range: (1, 0)-(1, 3)))
                        ],
                        range: (0, 0)-(1, 4)))
                       ]))
    }
    
    func testCase335() throws {
        // HTML: <p><code>foo bar   baz</code></p>\n
        /* Markdown
         ``
         foo
         bar
         baz
         ``
         
         */
        XCTAssertEqual(try compile("``\nfoo\nbar  \nbaz\n``\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .code(InlineCode(code: InlineString(text: "foo bar   baz", range: (1, 0)-(3, 2)),
                                             range: (0, 0)-(4, 1)))
                        ],
                        range: (0, 0)-(4, 2)))
                       ]))
    }
    
    func testCase336() throws {
        // HTML: <p><code>foo </code></p>\n
        /* Markdown
         ``
         foo
         ``
         
         */
        XCTAssertEqual(try compile("``\nfoo \n``\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .code(InlineCode(code: InlineString(text: "foo ", range: (1, 0)-(1, 3)),
                                             range: (0, 0)-(2, 1)))
                        ],
                        range: (0, 0)-(2, 2)))
                       ]))
    }
    
    func testCase337() throws {
        // HTML: <p><code>foo   bar  baz</code></p>\n
        /* Markdown
         `foo   bar
         baz`
         
         */
        XCTAssertEqual(try compile("`foo   bar \nbaz`\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .code(InlineCode(code: InlineString(text: "foo   bar  baz", range: (0, 1)-(1, 2)),
                                             range: (0, 0)-(1, 3)))
                        ],
                        range: (0, 0)-(1, 4)))
                       ]))
    }
    
    func testCase338() throws {
        // HTML: <p><code>foo\\</code>bar`</p>\n
        /* Markdown
         `foo\`bar`
         
         */
        XCTAssertEqual(try compile("`foo\\`bar`\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .code(InlineCode(code: InlineString(text: "foo\\", range: (0, 1)-(0, 4)),
                                             range: (0, 0)-(0, 5))),
                            .text(InlineString(text: "bar`", range: (0,6)-(0,9)))
                        ],
                        range: (0, 0)-(0, 10)))
                       ]))
    }
    
    func testCase339() throws {
        // HTML: <p><code>foo`bar</code></p>\n
        /* Markdown
         ``foo`bar``
         
         */
        XCTAssertEqual(try compile("``foo`bar``\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .code(InlineCode(code: InlineString(text: "foo`bar", range: (0, 2)-(0, 8)),
                                             range: (0, 0)-(0, 10)))
                        ],
                        range: (0, 0)-(0, 11)))
                       ]))
    }
    
    func testCase340() throws {
        // HTML: <p><code>foo `` bar</code></p>\n
        /* Markdown
         ` foo `` bar `
         
         */
        XCTAssertEqual(try compile("` foo `` bar `\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .code(InlineCode(code: InlineString(text: "foo `` bar", range: (0, 2)-(0, 11)),
                                             range: (0, 0)-(0, 13)))
                        ],
                        range: (0, 0)-(0, 14)))
                       ]))
    }
    
    func testCase341() throws {
        // HTML: <p>*foo<code>*</code></p>\n
        /* Markdown
         *foo`*`
         
         */
        XCTAssertEqual(try compile("*foo`*`\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "*foo", range: (0,0)-(0,3))),
                            .code(InlineCode(code: InlineString(text: "*", range: (0, 5)-(0, 5)),
                                             range: (0, 4)-(0, 6)))
                        ],
                        range: (0, 0)-(0, 7)))
                       ]))
    }
    
    func testCase342() throws {
        // HTML: <p>[not a <code>link](/foo</code>)</p>\n
        /* Markdown
         [not a `link](/foo`)
         
         */
        XCTAssertEqual(try compile("[not a `link](/foo`)\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[not a ", range: (0,0)-(0,6))),
                            .code(InlineCode(code: InlineString(text: "link](/foo", range: (0, 8)-(0, 17)),
                                             range: (0, 7)-(0, 18))),
                            .text(InlineString(text: ")", range: (0,19)-(0,19)))
                        ],
                        range: (0, 0)-(0, 20)))
                       ]))
    }
    
    func testCase343() throws {
        // Input: `<a href=\"`\">`\n
        // HTML: <p><code>&lt;a href=&quot;</code>&quot;&gt;`</p>\n
        XCTAssertEqual(try compile("`<a href=\"`\">`\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .code(InlineCode(code: InlineString(text: "<a href=\"", range: (0, 1)-(0, 9)),
                                             range: (0, 0)-(0, 10))),
                            .text(InlineString(text: "”>`", range: (0, 11)-(0, 13)))
                        ],
                        range: (0, 0)-(0,14)))
                       ]))
    }
    
    func testCase344() throws {
        // Input: <a href=\"`\">`\n
        // HTML: <p><a href=\"`\">`</p>\n
        XCTAssertEqual(try compile("<a href=\"`\">`\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "<a href=”", range: (0, 0)-(0, 8))),
                            .code(InlineCode(code: InlineString(text: "\">", range: (0, 10)-(0, 11)),
                                             range: (0, 9)-(0, 12)))
                        ],
                        range: (0, 0)-(0, 13)))
                       ]))
    }
    
    func testCase345() throws {
        // HTML: <p><code>&lt;http://foo.bar.</code>baz&gt;`</p>\n
        /* Markdown
         `<http://foo.bar.`baz>`
         
         */
        XCTAssertEqual(try compile("`<http://foo.bar.`baz>`\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .code(InlineCode(code: InlineString(text: "<http://foo.bar.", range: (0, 1)-(0, 16)),
                                             range: (0, 0)-(0, 17))),
                            .text(InlineString(text: "baz>`", range: (0,18)-(0,22)))
                        ],
                        range: (0, 0)-(0, 23)))
                       ]))
    }
    
    func testCase346() throws {
        // HTML: <p><a href=\"http://foo.bar.%60baz\">http://foo.bar.`baz</a>`</p>\n
        /* Markdown
         <http://foo.bar.`baz>`
         
         */
        XCTAssertEqual(try compile("<http://foo.bar.`baz>`\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "http://foo.bar.`baz", range: (0, 1)-(0, 19))),
                                             text: [
                                                .text(InlineString(text: "http://foo.bar.`baz", range: (0,1)-(0,19)))
                                             ],
                                             range: (0, 0)-(0, 20))),
                            .text(InlineString(text: "`", range: (0,21)-(0,21)))
                        ],
                        range: (0, 0)-(0, 22)))
                       ]))
    }
    
    func testCase347() throws {
        // HTML: <p>```foo``</p>\n
        /* Markdown
         ```foo``
         
         */
        XCTAssertEqual(try compile("```foo``\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "```foo``", range: (0,0)-(0,7)))
                        ],
                        range: (0, 0)-(0, 8)))
                       ]))
    }
    
    func testCase348() throws {
        // HTML: <p>`foo</p>\n
        /* Markdown
         `foo
         
         */
        XCTAssertEqual(try compile("`foo\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "`foo", range: (0,0)-(0,3)))
                        ],
                        range: (0, 0)-(0, 4)))
                       ]))
    }
    
    func testCase349() throws {
        // HTML: <p>`foo<code>bar</code></p>\n
        /* Markdown
         `foo``bar``
         
         */
        XCTAssertEqual(try compile("`foo``bar``\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "`foo", range: (0,0)-(0,3))),
                            .code(InlineCode(code: InlineString(text: "bar", range: (0, 6)-(0, 8)),
                                             range: (0, 4)-(0, 10)))
                        ],
                        range: (0, 0)-(0, 11)))
                       ]))
    }
    
    
}
