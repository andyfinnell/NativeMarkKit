import Foundation
import XCTest
@testable import NativeMarkKit

final class EntityandnumericcharacterreferencesTest: XCTestCase {
    func testCase311() throws {
        // HTML: <p>  &amp; © Æ Ď\n¾ ℋ ⅆ\n∲ ≧̸</p>\n
        /* Markdown
         &nbsp; &amp; &copy; &AElig; &Dcaron;
         &frac34; &HilbertSpace; &DifferentialD;
         &ClockwiseContourIntegral; &ngE;
         
         */
        XCTAssertEqual(try compile("&nbsp; &amp; &copy; &AElig; &Dcaron;\n&frac34; &HilbertSpace; &DifferentialD;\n&ClockwiseContourIntegral; &ngE;\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "  & © Æ Ď", range: (0, 0)-(0, 35))),
                            .softbreak(InlineSoftbreak(range: (0, 36)-(0, 36))),
                            .text(InlineString(text: "¾ ℋ ⅆ", range: (1, 0)-(1, 38))),
                            .softbreak(InlineSoftbreak(range: (1, 39)-(1, 39))),
                            .text(InlineString(text: "∲ ≧̸", range: (2, 0)-(2, 31)))
                        ],
                        range: (0, 0)-(2, 32)))
                       ]))
    }
    
    func testCase312() throws {
        // HTML: <p># Ӓ Ϡ �</p>\n
        /* Markdown
         &#35; &#1234; &#992; &#0;
         
         */
        XCTAssertEqual(try compile("&#35; &#1234; &#992; &#0;\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "# Ӓ Ϡ ", range: (0, 0)-(0, 20)))
                        ],
                        range: (0, 0)-(0, 25)))
                       ]))
    }
    
    func testCase313() throws {
        // HTML: <p>&quot; ആ ಫ</p>\n
        /* Markdown
         &#X22; &#XD06; &#xcab;
         
         */
        XCTAssertEqual(try compile("&#X22; &#XD06; &#xcab;\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "\" ആ ಫ", range: (0, 0)-(0, 21)))
                        ],
                        range: (0, 0)-(0, 22)))
                       ]))
    }
    
    func testCase314() throws {
        // HTML: <p>&amp;nbsp &amp;x; &amp;#; &amp;#x;\n&amp;#987654321;\n&amp;#abcdef0;\n&amp;ThisIsNotDefined; &amp;hi?;</p>\n
        /* Markdown
         &nbsp &x; &#; &#x;
         &#987654321;
         &#abcdef0;
         &ThisIsNotDefined; &hi?;
         
         */
        XCTAssertEqual(try compile("&nbsp &x; &#; &#x;\n&#987654321;\n&#abcdef0;\n&ThisIsNotDefined; &hi?;\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "&nbsp &x; &#; &#x;", range: (0,0)-(0,17))),
                            .softbreak(InlineSoftbreak(range: (0, 18)-(0, 18))),
                            .text(InlineString(text: "&#987654321;", range: (1,0)-(1,11))),
                            .softbreak(InlineSoftbreak(range: (1, 12)-(1, 12))),
                            .text(InlineString(text: "&#abcdef0;", range: (2,0)-(2,9))),
                            .softbreak(InlineSoftbreak(range: (2, 10)-(2, 10))),
                            .text(InlineString(text: "&ThisIsNotDefined; &hi?;", range: (3,0)-(3,23)))
                        ],
                        range: (0, 0)-(3, 24)))
                       ]))
    }
    
    func testCase315() throws {
        // HTML: <p>&amp;copy</p>\n
        /* Markdown
         &copy
         
         */
        XCTAssertEqual(try compile("&copy\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "&copy", range: (0,0)-(0,4)))
                        ],
                        range: (0, 0)-(0, 5)))
                       ]))
    }
    
    func testCase316() throws {
        // HTML: <p>&amp;MadeUpEntity;</p>\n
        /* Markdown
         &MadeUpEntity;
         
         */
        XCTAssertEqual(try compile("&MadeUpEntity;\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "&MadeUpEntity;", range: (0,0)-(0,13)))
                        ],
                        range: (0, 0)-(0, 14)))
                       ]))
    }
    
    func testCase317() throws {
        // Input: <a href=\"&ouml;&ouml;.html\">\n
        // HTML: <a href=\"&ouml;&ouml;.html\">\n
        XCTAssertEqual(try compile("<a href=\"&ouml;&ouml;.html\">\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "<a href=”öö.html\">", range: (0, 0)-(0, 27)))
                        ],
                        range: (0, 0)-(0, 28)))
                       ]))
    }
    
    func testCase318() throws {
        // HTML: <p><a href=\"/f%C3%B6%C3%B6\" title=\"föö\">foo</a></p>\n
        /* Markdown
         [foo](/f&ouml;&ouml; "f&ouml;&ouml;")
         
         */
        XCTAssertEqual(try compile("[foo](/f&ouml;&ouml; \"f&ouml;&ouml;\")\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: InlineString(text: "föö", range: (0, 21)-(0, 35)),
                                                        url: InlineString(text: "/föö", range: (0, 6)-(0, 19))),
                                             text: [
                                                .text(InlineString(text: "foo", range: (0,1)-(0,3)))
                                             ],
                                             range: (0, 0)-(0, 36)))
                        ],
                        range: (0, 0)-(0, 37)))
                       ]))
    }
    
    func testCase319() throws {
        // HTML: <p><a href=\"/f%C3%B6%C3%B6\" title=\"föö\">foo</a></p>\n
        /* Markdown
         [foo]
         
         [foo]: /f&ouml;&ouml; "f&ouml;&ouml;"
         
         */
        XCTAssertEqual(try compile("[foo]\n\n[foo]: /f&ouml;&ouml; \"f&ouml;&ouml;\"\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: InlineString(text: "föö", range: (2, 22)-(2, 36)),
                                                        url: InlineString(text: "/föö", range: (2, 7)-(2, 20))),
                                             text: [
                                                .text(InlineString(text: "foo", range: (0,1)-(0,3)))
                                             ],
                                             range: (0, 0)-(0, 4)))
                        ],
                        range: (0, 0)-(0, 5)))
                       ]))
    }
    
    func testCase320() throws {
        // HTML: <pre><code class=\"language-föö\">foo\n</code></pre>\n
        /* Markdown
         ``` f&ouml;&ouml;
         foo
         ```
         
         */
        XCTAssertEqual(try compile("``` f&ouml;&ouml;\nfoo\n```\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "föö",
                                             content: "foo\n",
                                             range: (0, 0)-(2, 3)))
                       ]))
    }
    
    func testCase321() throws {
        // HTML: <p><code>f&amp;ouml;&amp;ouml;</code></p>\n
        /* Markdown
         `f&ouml;&ouml;`
         
         */
        XCTAssertEqual(try compile("`f&ouml;&ouml;`\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .code(InlineCode(code: InlineString(text: "f&ouml;&ouml;", range: (0, 1)-(0, 13)),
                                             range: (0, 0)-(0, 14)))
                        ],
                        range: (0, 0)-(0, 15)))
                       ]))
    }
    
    func testCase322() throws {
        // HTML: <pre><code>f&amp;ouml;f&amp;ouml;\n</code></pre>\n
        /* Markdown
         f&ouml;f&ouml;
         
         */
        XCTAssertEqual(try compile("    f&ouml;f&ouml;\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "",
                                             content: "f&ouml;f&ouml;\n",
                                             range: (0, 4)-(1, 0)))
                       ]))
    }
    
    func testCase323() throws {
        // HTML: <p>*foo*\n<em>foo</em></p>\n
        /* Markdown
         &#42;foo&#42;
         *foo*
         
         */
        XCTAssertEqual(try compile("&#42;foo&#42;\n*foo*\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "*foo*", range: (0,0)-(0,12))),
                            .softbreak(InlineSoftbreak(range: (0, 13)-(0, 13))),
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "foo", range: (1,1)-(1,3)))
                            ],
                            range:(1, 0)-(1, 4)))
                        ],
                        range: (0, 0)-(1, 5)))
                       ]))
    }
    
    func testCase324() throws {
        // HTML: <p>* foo</p>\n<ul>\n<li>foo</li>\n</ul>\n
        /* Markdown
         &#42; foo
         
         * foo
         
         */
        XCTAssertEqual(try compile("&#42; foo\n\n* foo\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "* foo", range: (0,0)-(0,8)))
                        ],
                        range: (0, 0)-(0, 9))),
                        .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "foo", range: (2,2)-(2,4)))
                                ],
                                range: (2, 2)-(2, 5)))
                            ], range: (2, 0)-(2,5))
                        ]))
                       ]))
    }
    
    func testCase325() throws {
        // HTML: <p>foo\n\nbar</p>\n
        /* Markdown
         foo&#10;&#10;bar
         
         */
        XCTAssertEqual(try compile("foo&#10;&#10;bar\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo\n\nbar", range: (0, 0)-(0, 15)))
                        ],
                        range: (0, 0)-(0, 16)))
                       ]))
    }
    
    func testCase326() throws {
        // HTML: <p>\tfoo</p>\n
        /* Markdown
         &#9;foo
         
         */
        XCTAssertEqual(try compile("&#9;foo\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "\tfoo", range: (0, 0)-(0, 6)))
                        ],
                        range: (0, 0)-(0, 7)))
                       ]))
    }
    
    func testCase327() throws {
        // HTML: <p>[a](url &quot;tit&quot;)</p>\n
        /* Markdown
         [a](url &quot;tit&quot;)
         
         */
        XCTAssertEqual(try compile("[a](url &quot;tit&quot;)\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[a](url \"tit\")", range: (0, 0)-(0, 23)))
                        ],
                        range: (0, 0)-(0, 24)))
                       ]))
    }
    
    
}
