import Foundation
import XCTest
@testable import NativeMarkKit

final class BackslashescapesTest: XCTestCase {
    func testCase298() throws {
        // HTML: <p>!&quot;#$%&amp;'()*+,-./:;&lt;=&gt;?@[\\]^_`{|}~</p>\n
        /* Markdown
         \!\"\#\$\%\&\'\(\)\*\+\,\-\.\/\:\;\<\=\>\?\@\[\\\]\^\_\`\{\|\}\~
         
         */
        XCTAssertEqual(try compile("\\!\\\"\\#\\$\\%\\&\\'\\(\\)\\*\\+\\,\\-\\.\\/\\:\\;\\<\\=\\>\\?\\@\\[\\\\\\]\\^\\_\\`\\{\\|\\}\\~\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~", range: (0, 0)-(0, 63)))
                        ],
                        range: (0, 0)-(0, 64)))
                       ]))
    }
    
    func testCase299() throws {
        // HTML: <p>\\\t\\A\\a\\ \\3\\φ\\«</p>\n
        /* Markdown
         \	\A\a\ \3\φ\«
         
         */
        XCTAssertEqual(try compile("\\\t\\A\\a\\ \\3\\φ\\«\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "\\\t\\A\\a\\ \\3\\φ\\«", range: (0,0)-(0,13)))
                        ],
                        range: (0, 0)-(0, 14)))
                       ]))
    }
    
    func testCase300() throws {
        // Input: \\*not emphasized*\n\\<br/> not a tag\n\\[not a link](/foo)\n\\`not code`\n1\\. not a list\n\\* not a list\n\\# not a heading\n\\[foo]: /url \"not a reference\"\n\\&ouml; not a character entity\n
        // HTML: <p>*not emphasized*\n&lt;br/&gt; not a tag\n[not a link](/foo)\n`not code`\n1. not a list\n* not a list\n# not a heading\n[foo]: /url &quot;not a reference&quot;\n&amp;ouml; not a character entity</p>\n
        XCTAssertEqual(try compile("\\*not emphasized*\n\\<br/> not a tag\n\\[not a link](/foo)\n\\`not code`\n1\\. not a list\n\\* not a list\n\\# not a heading\n\\[foo]: /url \"not a reference\"\n\\&ouml; not a character entity\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "*not emphasized*", range: (0,0)-(0,16))),
                            .softbreak(InlineSoftbreak(range: (0, 17)-(0, 17))),
                            .text(InlineString(text: "<br/> not a tag", range: (1,0)-(1,15))),
                            .softbreak(InlineSoftbreak(range: (1, 16)-(1, 16))),
                            .text(InlineString(text: "[not a link](/foo)", range: (2,0)-(2,18))),
                            .softbreak(InlineSoftbreak(range: (2, 19)-(2, 19))),
                            .text(InlineString(text: "`not code`", range: (3,0)-(3,10))),
                            .softbreak(InlineSoftbreak(range: (3, 11)-(3, 11))),
                            .text(InlineString(text: "1. not a list", range: (4, 0)-(4, 13))),
                            .softbreak(InlineSoftbreak(range: (4, 14)-(4, 14))),
                            .text(InlineString(text: "* not a list", range: (5,0)-(5,12))),
                            .softbreak(InlineSoftbreak(range: (5, 13)-(5, 13))),
                            .text(InlineString(text: "# not a heading", range: (6,0)-(6,15))),
                            .softbreak(InlineSoftbreak(range: (6, 16)-(6, 16))),
                            .text(InlineString(text: "[foo]: /url “not a reference”", range: (7, 0)-(7, 29))),
                            .softbreak(InlineSoftbreak(range: (7, 30)-(7, 30))),
                            .text(InlineString(text: "&ouml; not a character entity", range: (8,0)-(8,29)))
                        ],
                        range: (0, 0)-(8, 30)))
                       ]))
    }
    
    func testCase301() throws {
        // HTML: <p>\\<em>emphasis</em></p>\n
        /* Markdown
         \\*emphasis*
         
         */
        XCTAssertEqual(try compile("\\\\*emphasis*\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "\\", range: (0,0)-(0,1))),
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "emphasis", range: (0,3)-(0,10)))
                            ],
                            range:(0, 2)-(0, 11)))
                        ],
                        range: (0, 0)-(0, 12)))
                       ]))
    }
    
    func testCase302() throws {
        // HTML: <p>foo<br />\nbar</p>\n
        /* Markdown
         foo\
         bar
         
         */
        XCTAssertEqual(try compile("foo\\\nbar\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo", range: (0,0)-(0,2))),
                            .linebreak(InlineLinebreak(range: (0, 3)-(0, 4))),
                            .text(InlineString(text: "bar", range: (1,0)-(1,2)))
                        ],
                        range: (0, 0)-(1, 3)))
                       ]))
    }
    
    func testCase303() throws {
        // HTML: <p><code>\\[\\`</code></p>\n
        /* Markdown
         `` \[\` ``
         
         */
        XCTAssertEqual(try compile("`` \\[\\` ``\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .code(InlineCode(code: InlineString(text: "\\[\\`", range: (0,3)-(0,6)),
                                             range: (0, 0)-(0, 9)))
                        ],
                        range: (0, 0)-(0, 10)))
                       ]))
    }
    
    func testCase304() throws {
        // HTML: <pre><code>\\[\\]\n</code></pre>\n
        /* Markdown
         \[\]
         
         */
        XCTAssertEqual(try compile("    \\[\\]\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "", content: "\\[\\]\n", range: (0, 4)-(1, 0)))
                       ]))
    }
    
    func testCase305() throws {
        // HTML: <pre><code>\\[\\]\n</code></pre>\n
        /* Markdown
         ~~~
         \[\]
         ~~~
         
         */
        XCTAssertEqual(try compile("~~~\n\\[\\]\n~~~\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "", content: "\\[\\]\n", range: (0, 0)-(2, 3)))
                       ]))
    }
    
    func testCase306() throws {
        // HTML: <p><a href=\"http://example.com?find=%5C*\">http://example.com?find=\\*</a></p>\n
        /* Markdown
         <http://example.com?find=\*>
         
         */
        XCTAssertEqual(try compile("<http://example.com?find=\\*>\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "http://example.com?find=\\*", range: (0, 1)-(0, 26))),
                                             text: [
                                                .text(InlineString(text: "http://example.com?find=\\*", range: (0,1)-(0,26)))
                                             ],
                                             range: (0, 0)-(0, 27)))
                        ],
                        range: (0, 0)-(0, 28)))
                       ]))
    }
    
    func testCase307() throws {
        // Input: <a href=\"/bar\\/)\">\n
        // HTML: <a href=\"/bar\\/)\">\n
        XCTAssertEqual(try compile("<a href=\"/bar\\/)\">\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "<a href=”/bar/)\">", range: (0, 0)-(0, 17)))
                        ],
                        range: (0,0)-(0,18)))
                       ]))

    }
    
    func testCase308() throws {
        // HTML: <p><a href=\"/bar*\" title=\"ti*tle\">foo</a></p>\n
        /* Markdown
         [foo](/bar\* "ti\*tle")
         
         */
        XCTAssertEqual(try compile("[foo](/bar\\* \"ti\\*tle\")\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: InlineString(text: "ti*tle", range: (0, 13)-(0, 21)),
                                                        url: InlineString(text: "/bar*", range: (0, 6)-(0, 11))),
                                             text: [
                                                .text(InlineString(text: "foo", range: (0,1)-(0,3)))
                                             ],
                                             range: (0, 0)-(0, 22)))
                        ],
                        range: (0, 0)-(0, 23)))
                       ]))
    }
    
    func testCase309() throws {
        // HTML: <p><a href=\"/bar*\" title=\"ti*tle\">foo</a></p>\n
        /* Markdown
         [foo]
         
         [foo]: /bar\* "ti\*tle"
         
         */
        XCTAssertEqual(try compile("[foo]\n\n[foo]: /bar\\* \"ti\\*tle\"\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: InlineString(text: "ti*tle", range: (2, 14)-(2, 22)),
                                                        url: InlineString(text: "/bar*", range: (2, 7)-(2, 12))),
                                             text: [
                                                .text(InlineString(text: "foo", range: (0,1)-(0,3)))
                                             ],
                                             range: (0, 0)-(0, 4)))
                        ],
                        range: (0, 0)-(0, 5)))
                       ], linkDefinitions: [
                        LinkDefinition(label: InlineString(text: "[foo]", range: (2,0)-(2,4)),
                                       link: Link(title: InlineString(text: "ti*tle", range: (2, 14)-(2, 22)),
                                                  url: InlineString(text: "/bar*", range: (2, 7)-(2, 12))),
                                       range: (2,0)-(2,23))
                       ]))
    }
    
    func testCase310() throws {
        // HTML: <pre><code class=\"language-foo+bar\">foo\n</code></pre>\n
        /* Markdown
         ``` foo\+bar
         foo
         ```
         
         */
        XCTAssertEqual(try compile("``` foo\\+bar\nfoo\n```\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "foo+bar", content: "foo\n", range: (0, 0)-(2, 3)))
                       ]))
    }
    
    
}
