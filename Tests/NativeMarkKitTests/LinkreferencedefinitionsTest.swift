import Foundation
import XCTest
@testable import NativeMarkKit

final class LinkreferencedefinitionsTest: XCTestCase {
    func testCase161() throws {
        // HTML: <p><a href=\"/url\" title=\"title\">foo</a></p>\n
        /* Markdown
         [foo]: /url "title"
         
         [foo]
         
         */
        XCTAssertEqual(try compile("[foo]: /url \"title\"\n\n[foo]\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: InlineString(text: "title", range: (0, 12)-(0, 18)),
                                                        url: InlineString(text: "/url", range: (0, 7)-(0, 10))),
                                             text: [
                                                .text(InlineString(text: "foo", range: (2,1)-(2,3)))
                                             ],
                                             range: (2, 0)-(2, 4)))
                        ],
                        range: (2, 0)-(2, 5)))
                       ]))
    }
    
    func testCase162() throws {
        // HTML: <p><a href=\"/url\" title=\"the title\">foo</a></p>\n
        /* Markdown
         [foo]: 
         /url  
         'the title'  
         
         [foo]
         
         */
        XCTAssertEqual(try compile("   [foo]: \n      /url  \n           'the title'  \n\n[foo]\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: InlineString(text: "the title", range: (2, 11)-(2, 21)),
                                                        url: InlineString(text: "/url", range: (1, 6)-(1, 9))),
                                             text: [
                                                .text(InlineString(text: "foo", range: (4,1)-(4,3)))
                                             ],
                                             range: (4, 0)-(4, 4)))
                        ],
                        range: (4, 0)-(4, 5)))
                       ]))
    }
    
    func testCase163() throws {
        // HTML: <p><a href=\"my_(url)\" title=\"title (with parens)\">Foo*bar]</a></p>\n
        /* Markdown
         [Foo*bar\]]:my_(url) 'title (with parens)'
         
         [Foo*bar\]]
         
         */
        XCTAssertEqual(try compile("[Foo*bar\\]]:my_(url) 'title (with parens)'\n\n[Foo*bar\\]]\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: InlineString(text: "title (with parens)", range: (0, 21)-(0, 41)),
                                                        url: InlineString(text: "my_(url)", range: (0, 12)-(0, 19))),
                                             text: [
                                                .text(InlineString(text: "Foo*bar]", range: (2, 1)-(2, 9)))
                                             ],
                                             range: (2, 0)-(2, 10)))
                        ],
                        range: (2, 0)-(2, 11)))
                       ]))
    }
    
    func testCase164() throws {
        // HTML: <p><a href=\"my%20url\" title=\"title\">Foo bar</a></p>\n
        /* Markdown
         [Foo bar]:
         <my url>
         'title'
         
         [Foo bar]
         
         */
        XCTAssertEqual(try compile("[Foo bar]:\n<my url>\n'title'\n\n[Foo bar]\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: InlineString(text: "title", range: (2, 0)-(2, 6)),
                                                        url: InlineString(text: "my url", range: (1, 0)-(1, 7))),
                                             text: [
                                                .text(InlineString(text: "Foo bar", range: (4,1)-(4,7)))
                                             ],
                                             range: (4, 0)-(4, 8)))
                        ],
                        range: (4, 0)-(4, 9)))
                       ]))
    }
    
    func testCase165() throws {
        // HTML: <p><a href=\"/url\" title=\"\ntitle\nline1\nline2\n\">foo</a></p>\n
        /* Markdown
         [foo]: /url '
         title
         line1
         line2
         '
         
         [foo]
         
         */
        XCTAssertEqual(try compile("[foo]: /url '\ntitle\nline1\nline2\n'\n\n[foo]\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: InlineString(text: "\ntitle\nline1\nline2\n", range: (0, 12)-(4, 0)),
                                                        url: InlineString(text: "/url", range: (0, 7)-(0, 10))),
                                             text: [
                                                .text(InlineString(text: "foo", range: (6,1)-(6,3)))
                                             ],
                                             range: (6, 0)-(6, 4)))
                        ],
                        range: (6, 0)-(6, 5)))
                       ]))
    }
    
    func testCase166() throws {
        // HTML: <p>[foo]: /url 'title</p>\n<p>with blank line'</p>\n<p>[foo]</p>\n
        /* Markdown
         [foo]: /url 'title
         
         with blank line'
         
         [foo]
         
         */
        XCTAssertEqual(try compile("[foo]: /url 'title\n\nwith blank line'\n\n[foo]\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[foo]: /url 'title", range: (0,0)-(0,17)))
                        ],
                        range: (0, 0)-(0, 18))),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "with blank line'", range: (2,0)-(2,15)))
                        ],
                        range: (2, 0)-(2, 16))),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[foo]", range: (4,0)-(4,4)))
                        ],
                        range: (4, 0)-(4, 5)))
                       ]))
    }
    
    func testCase167() throws {
        // HTML: <p><a href=\"/url\">foo</a></p>\n
        /* Markdown
         [foo]:
         /url
         
         [foo]
         
         */
        XCTAssertEqual(try compile("[foo]:\n/url\n\n[foo]\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/url", range: (1, 0)-(1, 3))),
                                             text: [
                                                .text(InlineString(text: "foo", range: (3,1)-(3,3)))
                                             ],
                                             range: (3, 0)-(3, 4)))
                        ],
                        range: (3, 0)-(3, 5)))
                       ]))
    }
    
    func testCase168() throws {
        // HTML: <p>[foo]:</p>\n<p>[foo]</p>\n
        /* Markdown
         [foo]:
         
         [foo]
         
         */
        XCTAssertEqual(try compile("[foo]:\n\n[foo]\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[foo]:", range: (0,0)-(0,5)))
                        ],
                        range: (0, 0)-(0, 6))),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[foo]", range: (2,0)-(2,4)))
                        ],
                        range: (2, 0)-(2, 5)))
                       ]))
    }
    
    func testCase169() throws {
        // HTML: <p><a href=\"\">foo</a></p>\n
        /* Markdown
         [foo]: <>
         
         [foo]
         
         */
        XCTAssertEqual(try compile("[foo]: <>\n\n[foo]\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "", range: (0, 7)-(0, 8))),
                                             text: [
                                                .text(InlineString(text: "foo", range: (2,1)-(2,3)))
                                             ],
                                             range: (2, 0)-(2, 4)))
                        ],
                        range: (2, 0)-(2, 5)))
                       ]))
    }
    
    func testCase170() throws {
        // HTML: <p>[foo]: <bar>(baz)</p>\n<p>[foo]</p>\n
        /* Markdown
         [foo]: <bar>(baz)
         
         [foo]
         
         */
        XCTAssertEqual(try compile("[foo]: <bar>(baz)\n\n[foo]\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[foo]: <bar>(baz)", range: (0,0)-(0,16)))
                        ],
                        range: (0, 0)-(0, 17))),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[foo]", range: (2,0)-(2,4)))
                        ],
                        range: (2, 0)-(2, 5)))
                       ]))
    }
    
    func testCase171() throws {
        // HTML: <p><a href=\"/url%5Cbar*baz\" title=\"foo&quot;bar\\baz\">foo</a></p>\n
        /* Markdown
         [foo]: /url\bar\*baz "foo\"bar\baz"
         
         [foo]
         
         */
        XCTAssertEqual(try compile("[foo]: /url\\bar\\*baz \"foo\\\"bar\\baz\"\n\n[foo]\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: InlineString(text: "foo\"bar\\baz", range: (0, 21)-(0, 34)),
                                                        url: InlineString(text: "/url\\bar*baz", range: (0, 7)-(0, 19))),
                                             text: [
                                                .text(InlineString(text: "foo", range: (2,1)-(2,3)))
                                             ],
                                             range: (2, 0)-(2, 4)))
                        ],
                        range: (2, 0)-(2, 5)))
                       ]))
    }
    
    func testCase172() throws {
        // HTML: <p><a href=\"url\">foo</a></p>\n
        /* Markdown
         [foo]
         
         [foo]: url
         
         */
        XCTAssertEqual(try compile("[foo]\n\n[foo]: url\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "url", range: (2, 7)-(2, 9))),
                                             text: [
                                                .text(InlineString(text: "foo", range: (0,1)-(0,3)))
                                             ],
                                             range: (0, 0)-(0, 4)))
                        ],
                        range: (0, 0)-(0, 5)))
                       ]))
    }
    
    func testCase173() throws {
        // HTML: <p><a href=\"first\">foo</a></p>\n
        /* Markdown
         [foo]
         
         [foo]: first
         [foo]: second
         
         */
        XCTAssertEqual(try compile("[foo]\n\n[foo]: first\n[foo]: second\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "first", range: (2, 7)-(2, 11))),
                                             text: [
                                                .text(InlineString(text: "foo", range: (0,1)-(0,3)))
                                             ],
                                             range: (0, 0)-(0, 4)))
                        ],
                        range: (0, 0)-(0, 5)))
                       ]))
    }
    
    func testCase174() throws {
        // HTML: <p><a href=\"/url\">Foo</a></p>\n
        /* Markdown
         [FOO]: /url
         
         [Foo]
         
         */
        XCTAssertEqual(try compile("[FOO]: /url\n\n[Foo]\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/url", range: (0, 7)-(0, 10))),
                                             text: [
                                                .text(InlineString(text: "Foo", range: (2,1)-(2,3)))
                                             ],
                                             range: (2, 0)-(2, 4)))
                        ],
                        range: (2, 0)-(2, 5)))
                       ]))
    }
    
    func testCase175() throws {
        // HTML: <p><a href=\"/%CF%86%CE%BF%CF%85\">αγω</a></p>\n
        /* Markdown
         [ΑΓΩ]: /φου
         
         [αγω]
         
         */
        XCTAssertEqual(try compile("[ΑΓΩ]: /φου\n\n[αγω]\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/φου", range: (0, 7)-(0, 10))),
                                             text: [
                                                .text(InlineString(text: "αγω", range: (2,1)-(2,3)))
                                             ],
                                             range: (2, 0)-(2, 4)))
                        ],
                        range: (2, 0)-(2, 5)))
                       ]))
    }
    
    func testCase176() throws {
        // HTML: 
        /* Markdown
         [foo]: /url
         
         */
        XCTAssertEqual(try compile("[foo]: /url\n"),
                       Document(elements: [
                        
                       ]))
    }
    
    func testCase177() throws {
        // HTML: <p>bar</p>\n
        /* Markdown
         [
         foo
         ]: /url
         bar
         
         */
        XCTAssertEqual(try compile("[\nfoo\n]: /url\nbar\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "bar", range: (3,0)-(3,2)))
                        ],
                        range: (3, 0)-(3, 3)))
                       ]))
    }
    
    func testCase178() throws {
        // HTML: <p>[foo]: /url &quot;title&quot; ok</p>\n
        /* Markdown
         [foo]: /url "title" ok
         
         */
        XCTAssertEqual(try compile("[foo]: /url \"title\" ok\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[foo]: /url “title” ok", range: (0, 0)-(0, 21)))
                        ],
                        range: (0, 0)-(0, 22)))
                       ]))
    }
    
    func testCase179() throws {
        // HTML: <p>&quot;title&quot; ok</p>\n
        /* Markdown
         [foo]: /url
         "title" ok
         
         */
        XCTAssertEqual(try compile("[foo]: /url\n\"title\" ok\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "“title” ok", range: (1, 0)-(1, 9)))
                        ],
                        range: (1, 0)-(1, 10)))
                       ]))
    }
    
    func testCase180() throws {
        // HTML: <pre><code>[foo]: /url &quot;title&quot;\n</code></pre>\n<p>[foo]</p>\n
        /* Markdown
         [foo]: /url "title"
         
         [foo]
         
         */
        XCTAssertEqual(try compile("    [foo]: /url \"title\"\n\n[foo]\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "",
                                             content: "[foo]: /url \"title\"\n",
                                             range: (0, 4)-(1, 0))),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[foo]", range: (2,0)-(2,4)))
                        ],
                        range: (2, 0)-(2, 5)))
                       ]))
    }
    
    func testCase181() throws {
        // HTML: <pre><code>[foo]: /url\n</code></pre>\n<p>[foo]</p>\n
        /* Markdown
         ```
         [foo]: /url
         ```
         
         [foo]
         
         */
        XCTAssertEqual(try compile("```\n[foo]: /url\n```\n\n[foo]\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "",
                                             content: "[foo]: /url\n",
                                             range: (0, 0)-(2, 3))),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[foo]", range: (4,0)-(4,4)))
                        ],
                        range: (4, 0)-(4, 5)))
                       ]))
    }
    
    func testCase182() throws {
        // HTML: <p>Foo\n[bar]: /baz</p>\n<p>[bar]</p>\n
        /* Markdown
         Foo
         [bar]: /baz
         
         [bar]
         
         */
        XCTAssertEqual(try compile("Foo\n[bar]: /baz\n\n[bar]\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "Foo", range: (0,0)-(0,2))),
                            .softbreak(InlineSoftbreak(range: (0, 3)-(0, 3))),
                            .text(InlineString(text: "[bar]: /baz", range: (1,0)-(1,10)))
                        ],
                        range: (0, 0)-(1, 11))),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[bar]", range: (3,0)-(3,4)))
                        ],
                        range: (3, 0)-(3, 5)))
                       ]))
    }
    
    func testCase183() throws {
        // HTML: <h1><a href=\"/url\">Foo</a></h1>\n<blockquote>\n<p>bar</p>\n</blockquote>\n
        /* Markdown
         # [Foo]
         [foo]: /url
         > bar
         
         */
        XCTAssertEqual(try compile("# [Foo]\n[foo]: /url\n> bar\n"),
                       Document(elements: [
                        .heading(Heading(level: 1,
                                         text: [
                                            .link(InlineLink(link: Link(title: nil,
                                                                        url: InlineString(text: "/url", range: (1, 7)-(1, 10))),
                                                             text: [
                                                                .text(InlineString(text: "Foo", range: (0,3)-(0,5)))
                                                             ],
                                                             range: (0, 2)-(0, 6)))
                                         ],
                                         range: (0, 0)-(0, 7))),
                        .blockQuote(BlockQuote(blocks: [
                            .paragraph(Paragraph(text: [
                                .text(InlineString(text: "bar", range: (2,2)-(2,4)))
                            ],
                            range: (2, 2)-(2, 5)))
                        ],
                        range: (2, 0)-(2, 5)))
                       ]))
    }
    
    func testCase184() throws {
        // HTML: <h1>bar</h1>\n<p><a href=\"/url\">foo</a></p>\n
        /* Markdown
         [foo]: /url
         bar
         ===
         [foo]
         
         */
        XCTAssertEqual(try compile("[foo]: /url\nbar\n===\n[foo]\n"),
                       Document(elements: [
                        .heading(Heading(level: 1,
                                         text: [
                                            .text(InlineString(text: "bar", range: (1,0)-(1,2)))
                                         ],
                                         range: (1, 0)-(2, 3))),
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/url", range: (0, 7)-(0, 10))),
                                             text: [
                                                .text(InlineString(text: "foo", range: (3,1)-(3,3)))
                                             ],
                                             range: (3, 0)-(3, 4)))
                        ],
                        range: (3, 0)-(3, 5)))
                       ]))
    }
    
    func testCase185() throws {
        // HTML: <p>===\n<a href=\"/url\">foo</a></p>\n
        /* Markdown
         [foo]: /url
         ===
         [foo]
         
         */
        XCTAssertEqual(try compile("[foo]: /url\n===\n[foo]\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "===", range: (1,0)-(1,2))),
                            .softbreak(InlineSoftbreak(range: (1, 3)-(1, 3))),
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/url", range: (0, 7)-(0, 10))),
                                             text: [
                                                .text(InlineString(text: "foo", range: (2,1)-(2,3)))
                                             ],
                                             range: (2, 0)-(2, 4)))
                        ],
                        range: (1, 0)-(2, 5)))
                       ]))
    }
    
    func testCase186() throws {
        // HTML: <p><a href=\"/foo-url\" title=\"foo\">foo</a>,\n<a href=\"/bar-url\" title=\"bar\">bar</a>,\n<a href=\"/baz-url\">baz</a></p>\n
        /* Markdown
         [foo]: /foo-url "foo"
         [bar]: /bar-url
         "bar"
         [baz]: /baz-url
         
         [foo],
         [bar],
         [baz]
         
         */
        XCTAssertEqual(try compile("[foo]: /foo-url \"foo\"\n[bar]: /bar-url\n  \"bar\"\n[baz]: /baz-url\n\n[foo],\n[bar],\n[baz]\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: InlineString(text: "foo", range: (0, 16)-(0, 20)),
                                                        url: InlineString(text: "/foo-url", range: (0, 7)-(0, 14))),
                                             text: [
                                                .text(InlineString(text: "foo", range: (5,1)-(5,3)))
                                             ],
                                             range: (5, 0)-(5, 4))),
                            .text(InlineString(text: ",", range: (5,5)-(5,5))),
                            .softbreak(InlineSoftbreak(range: (5, 6)-(5, 6))),
                            .link(InlineLink(link: Link(title: InlineString(text: "bar", range: (2, 2)-(2, 6)),
                                                        url: InlineString(text: "/bar-url", range: (1, 7)-(1, 14))),
                                             text: [
                                                .text(InlineString(text: "bar", range: (6,1)-(6,3)))
                                             ],
                                             range: (6, 0)-(6, 4))),
                            .text(InlineString(text: ",", range: (6,5)-(6,5))),
                            .softbreak(InlineSoftbreak(range: (6, 6)-(6, 6))),
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/baz-url", range: (3, 7)-(3, 14))),
                                             text: [
                                                .text(InlineString(text: "baz", range: (7,1)-(7,3)))
                                             ],
                                             range: (7, 0)-(7, 4)))
                        ],
                        range: (5, 0)-(7, 5)))
                       ]))
    }
    
    func testCase187() throws {
        // HTML: <p><a href=\"/url\">foo</a></p>\n<blockquote>\n</blockquote>\n
        /* Markdown
         [foo]
         
         > [foo]: /url
         
         */
        XCTAssertEqual(try compile("[foo]\n\n> [foo]: /url\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/url", range: (2, 9)-(2, 12))),
                                             text: [
                                                .text(InlineString(text: "foo", range: (0,1)-(0,3)))
                                             ],
                                             range: (0, 0)-(0, 4)))
                        ],
                        range: (0, 0)-(0, 5))),
                        .blockQuote(BlockQuote(blocks: [
                            
                        ],
                        range: (2, 0)-(2, 13)))
                       ]))
    }
    
    func testCase188() throws {
        // HTML: 
        /* Markdown
         [foo]: /url
         
         */
        XCTAssertEqual(try compile("[foo]: /url\n"),
                       Document(elements: [
                        
                       ]))
    }
    
    
}
