import Foundation
import XCTest
@testable import NativeMarkKit

final class LinksTest: XCTestCase {
    func testCase481() throws {
        // HTML: <p><a href=\"/uri\" title=\"title\">link</a></p>\n
        /* Markdown
         [link](/uri "title")
         
         */
        XCTAssertEqual(try compile("[link](/uri \"title\")\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: InlineString(text: "title", range: (0, 12)-(0, 18)),
                                                        url: InlineString(text: "/uri", range: (0, 7)-(0, 10))),
                                             text: [
                                                .text(InlineString(text: "link", range: (0,1)-(0, 4)))
                                             ],
                                             range: (0, 0)-(0, 19)))
                        ],
                        range: (0, 0)-(0, 20)))
                       ]))
    }
    
    func testCase482() throws {
        // HTML: <p><a href=\"/uri\">link</a></p>\n
        /* Markdown
         [link](/uri)
         
         */
        XCTAssertEqual(try compile("[link](/uri)\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/uri", range: (0, 7)-(0, 10))),
                                             text: [
                                                .text(InlineString(text: "link", range: (0,1)-(0,4)))
                                             ],
                                             range: (0, 0)-(0, 11)))
                        ],
                        range: (0, 0)-(0, 12)))
                       ]))
    }
    
    func testCase483() throws {
        // HTML: <p><a href=\"\">link</a></p>\n
        /* Markdown
         [link]()
         
         */
        XCTAssertEqual(try compile("[link]()\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: nil),
                                             text: [
                                                .text(InlineString(text: "link", range: (0,1)-(0,4)))
                                             ],
                                             range: (0, 0)-(0, 7)))
                        ],
                        range: (0, 0)-(0, 8)))
                       ]))
    }
    
    func testCase484() throws {
        // HTML: <p><a href=\"\">link</a></p>\n
        /* Markdown
         [link](<>)
         
         */
        XCTAssertEqual(try compile("[link](<>)\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "", range: (0, 7)-(0, 8))),
                                             text: [
                                                .text(InlineString(text: "link", range: (0,1)-(0,4)))
                                             ],
                                             range: (0, 0)-(0, 9)))
                        ],
                        range: (0, 0)-(0, 10)))
                       ]))
    }
    
    func testCase485() throws {
        // HTML: <p>[link](/my uri)</p>\n
        /* Markdown
         [link](/my uri)
         
         */
        XCTAssertEqual(try compile("[link](/my uri)\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[link](/my uri)", range: (0,0)-(0,14)))
                        ],
                        range: (0, 0)-(0, 15)))
                       ]))
    }
    
    func testCase486() throws {
        // HTML: <p><a href=\"/my%20uri\">link</a></p>\n
        /* Markdown
         [link](</my uri>)
         
         */
        XCTAssertEqual(try compile("[link](</my uri>)\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/my uri", range: (0, 7)-(0, 15))),
                                             text: [
                                                .text(InlineString(text: "link", range: (0,1)-(0,4)))
                                             ],
                                             range: (0, 0)-(0, 16)))
                        ],
                        range: (0, 0)-(0, 17)))
                       ]))
    }
    
    func testCase487() throws {
        // HTML: <p>[link](foo\nbar)</p>\n
        /* Markdown
         [link](foo
         bar)
         
         */
        XCTAssertEqual(try compile("[link](foo\nbar)\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[link](foo", range: (0,0)-(0,9))),
                            .softbreak(InlineSoftbreak(range: (0, 10)-(0, 10))),
                            .text(InlineString(text: "bar)", range: (1,0)-(1,3)))
                        ],
                        range: (0, 0)-(1, 4)))
                       ]))
    }
    
    func testCase488() throws {
        // HTML: <p>[link](<foo\nbar>)</p>\n
        /* Markdown
         [link](<foo
         bar>)
         
         */
        XCTAssertEqual(try compile("[link](<foo\nbar>)\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[link](<foo", range: (0,0)-(0,10))),
                            .softbreak(InlineSoftbreak(range: (0, 11)-(0, 11))),
                            .text(InlineString(text: "bar>)", range: (1,0)-(1,4)))
                        ],
                        range: (0, 0)-(1, 5)))
                       ]))
    }
    
    func testCase489() throws {
        // HTML: <p><a href=\"b)c\">a</a></p>\n
        /* Markdown
         [a](<b)c>)
         
         */
        XCTAssertEqual(try compile("[a](<b)c>)\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "b)c", range: (0, 4)-(0, 8))),
                                             text: [
                                                .text(InlineString(text: "a", range: (0,1)-(0,1)))
                                             ],
                                             range: (0, 0)-(0, 9)))
                        ],
                        range: (0, 0)-(0, 10)))
                       ]))
    }
    
    func testCase490() throws {
        // HTML: <p>[link](&lt;foo&gt;)</p>\n
        /* Markdown
         [link](<foo\>)
         
         */
        XCTAssertEqual(try compile("[link](<foo\\>)\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[link](<foo>)", range: (0, 0)-(0, 13)))
                        ],
                        range: (0, 0)-(0, 14)))
                       ]))
    }
    
    func testCase491() throws {
        // HTML: <p>[a](&lt;b)c\n[a](&lt;b)c&gt;\n[a](<b>c)</p>\n
        /* Markdown
         [a](<b)c
         [a](<b)c>
         [a](<b>c)
         
         */
        XCTAssertEqual(try compile("[a](<b)c\n[a](<b)c>\n[a](<b>c)\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[a](<b)c", range: (0,0)-(0,7))),
                            .softbreak(InlineSoftbreak(range: (0, 8)-(0, 8))),
                            .text(InlineString(text: "[a](<b)c>", range: (1,0)-(1,8))),
                            .softbreak(InlineSoftbreak(range: (1, 9)-(1, 9))),
                            .text(InlineString(text: "[a](<b>c)", range: (2,0)-(2,8)))
                        ],
                        range: (0, 0)-(2, 9)))
                       ]))
    }
    
    func testCase492() throws {
        // HTML: <p><a href=\"(foo)\">link</a></p>\n
        /* Markdown
         [link](\(foo\))
         
         */
        XCTAssertEqual(try compile("[link](\\(foo\\))\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "(foo)", range: (0, 7)-(0, 13))),
                                             text: [
                                                .text(InlineString(text: "link", range: (0,1)-(0,4)))
                                             ],
                                             range: (0, 0)-(0, 14)))
                        ],
                        range: (0, 0)-(0, 15)))
                       ]))
    }
    
    func testCase493() throws {
        // HTML: <p><a href=\"foo(and(bar))\">link</a></p>\n
        /* Markdown
         [link](foo(and(bar)))
         
         */
        XCTAssertEqual(try compile("[link](foo(and(bar)))\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "foo(and(bar))", range: (0, 7)-(0, 19))),
                                             text: [
                                                .text(InlineString(text: "link", range: (0,1)-(0,4)))
                                             ],
                                             range: (0, 0)-(0, 20)))
                        ],
                        range: (0, 0)-(0, 21)))
                       ]))
    }
    
    func testCase494() throws {
        // HTML: <p><a href=\"foo(and(bar)\">link</a></p>\n
        /* Markdown
         [link](foo\(and\(bar\))
         
         */
        XCTAssertEqual(try compile("[link](foo\\(and\\(bar\\))\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "foo(and(bar)", range: (0, 7)-(0, 21))),
                                             text: [
                                                .text(InlineString(text: "link", range: (0,1)-(0,4)))
                                             ],
                                             range: (0, 0)-(0, 22)))
                        ],
                        range: (0, 0)-(0, 23)))
                       ]))
    }
    
    func testCase495() throws {
        // HTML: <p><a href=\"foo(and(bar)\">link</a></p>\n
        /* Markdown
         [link](<foo(and(bar)>)
         
         */
        XCTAssertEqual(try compile("[link](<foo(and(bar)>)\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "foo(and(bar)", range: (0, 7)-(0, 20))),
                                             text: [
                                                .text(InlineString(text: "link", range: (0,1)-(0,4)))
                                             ],
                                             range: (0, 0)-(0, 21)))
                        ],
                        range: (0, 0)-(0, 22)))
                       ]))
    }
    
    func testCase496() throws {
        // HTML: <p><a href=\"foo):\">link</a></p>\n
        /* Markdown
         [link](foo\)\:)
         
         */
        XCTAssertEqual(try compile("[link](foo\\)\\:)\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "foo):", range: (0, 7)-(0, 13))),
                                             text: [
                                                .text(InlineString(text: "link", range: (0,1)-(0,4)))
                                             ],
                                             range: (0, 0)-(0, 14)))
                        ],
                        range: (0, 0)-(0, 15)))
                       ]))
    }
    
    func testCase497() throws {
        // HTML: <p><a href=\"#fragment\">link</a></p>\n<p><a href=\"http://example.com#fragment\">link</a></p>\n<p><a href=\"http://example.com?foo=3#frag\">link</a></p>\n
        /* Markdown
         [link](#fragment)
         
         [link](http://example.com#fragment)
         
         [link](http://example.com?foo=3#frag)
         
         */
        XCTAssertEqual(try compile("[link](#fragment)\n\n[link](http://example.com#fragment)\n\n[link](http://example.com?foo=3#frag)\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "#fragment", range: (0, 7)-(0, 15))),
                                             text: [
                                                .text(InlineString(text: "link", range: (0,1)-(0,4)))
                                             ],
                                             range: (0, 0)-(0, 16)))
                        ],
                        range: (0, 0)-(0, 17))),
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "http://example.com#fragment", range: (2, 7)-(2, 33))),
                                             text: [
                                                .text(InlineString(text: "link", range: (2,1)-(2,4)))
                                             ],
                                             range: (2, 0)-(2, 34)))
                        ],
                        range: (2, 0)-(2, 35))),
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "http://example.com?foo=3#frag", range: (4, 7)-(4, 35))),
                                             text: [
                                                .text(InlineString(text: "link", range: (4,1)-(4,4)))
                                             ],
                                             range: (4, 0)-(4, 36)))
                        ],
                        range: (4, 0)-(4, 37)))
                       ]))
    }
    
    func testCase498() throws {
        // HTML: <p><a href=\"foo%5Cbar\">link</a></p>\n
        /* Markdown
         [link](foo\bar)
         
         */
        XCTAssertEqual(try compile("[link](foo\\bar)\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "foo\\bar", range: (0, 7)-(0, 13))),
                                             text: [
                                                .text(InlineString(text: "link", range: (0,1)-(0,4)))
                                             ],
                                             range: (0, 0)-(0, 14)))
                        ],
                        range: (0, 0)-(0, 15)))
                       ]))
    }
    
    func testCase499() throws {
        // HTML: <p><a href=\"foo%20b%C3%A4\">link</a></p>\n
        /* Markdown
         [link](foo%20b&auml;)
         
         */
        XCTAssertEqual(try compile("[link](foo%20b&auml;)\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "foo%20bä", range: (0, 7)-(0, 19))),
                                             text: [
                                                .text(InlineString(text: "link", range: (0,1)-(0,4)))
                                             ],
                                             range: (0, 0)-(0, 20)))
                        ],
                        range: (0, 0)-(0, 21)))
                       ]))
    }
    
    func testCase500() throws {
        // HTML: <p><a href=\"%22title%22\">link</a></p>\n
        /* Markdown
         [link]("title")
         
         */
        XCTAssertEqual(try compile("[link](\"title\")\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "\"title\"", range: (0, 7)-(0, 13))),
                                             text: [
                                                .text(InlineString(text: "link", range: (0,1)-(0,4)))
                                             ],
                                             range: (0, 0)-(0, 14)))
                        ],
                        range: (0, 0)-(0, 15)))
                       ]))
    }
    
    func testCase501() throws {
        // HTML: <p><a href=\"/url\" title=\"title\">link</a>\n<a href=\"/url\" title=\"title\">link</a>\n<a href=\"/url\" title=\"title\">link</a></p>\n
        /* Markdown
         [link](/url "title")
         [link](/url 'title')
         [link](/url (title))
         
         */
        XCTAssertEqual(try compile("[link](/url \"title\")\n[link](/url 'title')\n[link](/url (title))\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: InlineString(text: "title", range: (0, 12)-(0, 18)),
                                                        url: InlineString(text: "/url", range: (0, 7)-(0, 10))),
                                             text: [
                                                .text(InlineString(text: "link", range: (0,1)-(0,4)))
                                             ],
                                             range: (0, 0)-(0, 19))),
                            .softbreak(InlineSoftbreak(range: (0, 20)-(0, 20))),
                            .link(InlineLink(link: Link(title: InlineString(text: "title", range: (1, 12)-(1, 18)),
                                                        url: InlineString(text: "/url", range: (1, 7)-(1, 10))),
                                             text: [
                                                .text(InlineString(text: "link", range: (1,1)-(1,4)))
                                             ],
                                             range: (1, 0)-(1, 19))),
                            .softbreak(InlineSoftbreak(range: (1, 20)-(1, 20))),
                            .link(InlineLink(link: Link(title: InlineString(text: "title", range: (2, 12)-(2, 18)),
                                                        url: InlineString(text: "/url", range: (2, 7)-(2, 10))),
                                             text: [
                                                .text(InlineString(text: "link", range: (2,1)-(2,4)))
                                             ],
                                             range: (2, 0)-(2, 19)))
                        ],
                        range: (0, 0)-(2, 20)))
                       ]))
    }
    
    func testCase502() throws {
        // HTML: <p><a href=\"/url\" title=\"title &quot;&quot;\">link</a></p>\n
        /* Markdown
         [link](/url "title \"&quot;")
         
         */
        XCTAssertEqual(try compile("[link](/url \"title \\\"&quot;\")\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: InlineString(text: "title \"\"", range: (0, 12)-(0, 27)),
                                                        url: InlineString(text: "/url", range: (0, 7)-(0, 10))),
                                             text: [
                                                .text(InlineString(text: "link", range: (0,1)-(0,4)))
                                             ],
                                             range: (0, 0)-(0, 28)))
                        ],
                        range: (0, 0)-(0, 29)))
                       ]))
    }
    
    func testCase503() throws {
        // HTML: <p><a href=\"/url%C2%A0%22title%22\">link</a></p>\n
        /* Markdown
         [link](/url "title")
         
         */
        XCTAssertEqual(try compile("[link](/url \"title\")\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/url \"title\"", range: (0, 7)-(0, 18))),
                                             text: [
                                                .text(InlineString(text: "link", range: (0,1)-(0,4)))
                                             ],
                                             range: (0, 0)-(0, 19)))
                        ],
                        range: (0, 0)-(0, 20)))
                       ]))
    }
    
    func testCase504() throws {
        // HTML: <p>[link](/url &quot;title &quot;and&quot; title&quot;)</p>\n
        /* Markdown
         [link](/url "title "and" title")
         
         */
        XCTAssertEqual(try compile("[link](/url \"title \"and\" title\")\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[link](/url “title “and” title”)", range: (0, 0)-(0, 31)))
                        ],
                        range: (0, 0)-(0, 32)))
                       ]))
    }
    
    func testCase505() throws {
        // HTML: <p><a href=\"/url\" title=\"title &quot;and&quot; title\">link</a></p>\n
        /* Markdown
         [link](/url 'title "and" title')
         
         */
        XCTAssertEqual(try compile("[link](/url 'title \"and\" title')\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: InlineString(text: "title \"and\" title", range: (0, 12)-(0, 30)),
                                                        url: InlineString(text: "/url", range: (0, 7)-(0, 10))),
                                             text: [
                                                .text(InlineString(text: "link", range: (0,1)-(0,4)))
                                             ],
                                             range: (0, 0)-(0, 31)))
                        ],
                        range: (0, 0)-(0, 32)))
                       ]))
    }
    
    func testCase506() throws {
        // HTML: <p><a href=\"/uri\" title=\"title\">link</a></p>\n
        /* Markdown
         [link](   /uri
         "title"  )
         
         */
        XCTAssertEqual(try compile("[link](   /uri\n  \"title\"  )\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: InlineString(text: "title", range: (1, 2)-(1, 8)),
                                                        url: InlineString(text: "/uri", range: (0, 10)-(0, 13))),
                                             text: [
                                                .text(InlineString(text: "link", range: (0,1)-(0,4)))
                                             ],
                                             range: (0, 0)-(1, 11)))
                        ],
                        range: (0, 0)-(1, 12)))
                       ]))
    }
    
    func testCase507() throws {
        // HTML: <p>[link] (/uri)</p>\n
        /* Markdown
         [link] (/uri)
         
         */
        XCTAssertEqual(try compile("[link] (/uri)\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[link] (/uri)", range: (0,0)-(0,12)))
                        ],
                        range: (0, 0)-(0, 13)))
                       ]))
    }
    
    func testCase508() throws {
        // HTML: <p><a href=\"/uri\">link [foo [bar]]</a></p>\n
        /* Markdown
         [link [foo [bar]]](/uri)
         
         */
        XCTAssertEqual(try compile("[link [foo [bar]]](/uri)\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/uri", range: (0, 19)-(0, 22))),
                                             text: [
                                                .text(InlineString(text: "link [foo [bar]]", range: (0,1)-(0,16)))
                                             ],
                                             range: (0, 0)-(0, 23)))
                        ],
                        range: (0, 0)-(0, 24)))
                       ]))
    }
    
    func testCase509() throws {
        // HTML: <p>[link] bar](/uri)</p>\n
        /* Markdown
         [link] bar](/uri)
         
         */
        XCTAssertEqual(try compile("[link] bar](/uri)\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[link] bar](/uri)", range: (0,0)-(0,16)))
                        ],
                        range: (0, 0)-(0, 17)))
                       ]))
    }
    
    func testCase510() throws {
        // HTML: <p>[link <a href=\"/uri\">bar</a></p>\n
        /* Markdown
         [link [bar](/uri)
         
         */
        XCTAssertEqual(try compile("[link [bar](/uri)\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[link ", range: (0,0)-(0,5))),
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/uri", range: (0, 12)-(0, 15))),
                                             text: [
                                                .text(InlineString(text: "bar", range: (0,7)-(0,9)))
                                             ],
                                             range: (0, 6)-(0, 16)))
                        ],
                        range: (0, 0)-(0, 17)))
                       ]))
    }
    
    func testCase511() throws {
        // HTML: <p><a href=\"/uri\">link [bar</a></p>\n
        /* Markdown
         [link \[bar](/uri)
         
         */
        XCTAssertEqual(try compile("[link \\[bar](/uri)\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/uri", range: (0, 13)-(0, 16))),
                                             text: [
                                                .text(InlineString(text: "link [bar", range: (0, 1)-(0, 10)))
                                             ],
                                             range: (0, 0)-(0, 17)))
                        ],
                        range: (0, 0)-(0, 18)))
                       ]))
    }
    
    func testCase512() throws {
        // HTML: <p><a href=\"/uri\">link <em>foo <strong>bar</strong> <code>#</code></em></a></p>\n
        /* Markdown
         [link *foo **bar** `#`*](/uri)
         
         */
        XCTAssertEqual(try compile("[link *foo **bar** `#`*](/uri)\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/uri", range: (0, 25)-(0, 28))),
                                             text: [
                                                .text(InlineString(text: "link ", range: (0,1)-(0,5))),
                                                .emphasis(InlineEmphasis(text: [
                                                    .text(InlineString(text: "foo ", range: (0,7)-(0,10))),
                                                    .strong(InlineStrong(text: [
                                                        .text(InlineString(text: "bar", range: (0,13)-(0,15)))
                                                    ],
                                                    range:(0, 11)-(0, 17))),
                                                    .text(InlineString(text: " ", range: (0,18)-(0,18))),
                                                    .code(InlineCode(code: InlineString(text: "#", range: (0, 20)-(0, 20)),
                                                                     range: (0, 19)-(0, 21)))
                                                ],
                                                range:(0, 6)-(0, 22)))
                                             ],
                                             range: (0, 0)-(0, 29)))
                        ],
                        range: (0, 0)-(0, 30)))
                       ]))
    }
    
    func testCase513() throws {
        // HTML: <p><a href=\"/uri\"><img src=\"moon.jpg\" alt=\"moon\" /></a></p>\n
        /* Markdown
         [![moon](moon.jpg)](/uri)
         
         */
        XCTAssertEqual(try compile("[![moon](moon.jpg)](/uri)\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/uri", range: (0, 20)-(0, 23))),
                                             text: [
                                                .image(InlineImage(link: Link(title: nil,
                                                                              url: InlineString(text: "moon.jpg", range: (0, 9)-(0, 16))),
                                                                   alt: InlineString(text: "moon", range: (0, 3)-(0, 6)),
                                                                   range: (0, 1)-(0, 17)))
                                             ],
                                             range: (0, 0)-(0, 24)))
                        ],
                        range: (0, 0)-(0, 25)))
                       ]))
    }
    
    func testCase514() throws {
        // HTML: <p>[foo <a href=\"/uri\">bar</a>](/uri)</p>\n
        /* Markdown
         [foo [bar](/uri)](/uri)
         
         */
        XCTAssertEqual(try compile("[foo [bar](/uri)](/uri)\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[foo ", range: (0,0)-(0,4))),
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/uri", range: (0, 11)-(0, 14))),
                                             text: [
                                                .text(InlineString(text: "bar", range: (0,6)-(0,8)))
                                             ],
                                             range: (0, 5)-(0, 15))),
                            .text(InlineString(text: "](/uri)", range: (0,16)-(0,22)))
                        ],
                        range: (0, 0)-(0, 23)))
                       ]))
    }
    
    func testCase515() throws {
        // HTML: <p>[foo <em>[bar <a href=\"/uri\">baz</a>](/uri)</em>](/uri)</p>\n
        /* Markdown
         [foo *[bar [baz](/uri)](/uri)*](/uri)
         
         */
        XCTAssertEqual(try compile("[foo *[bar [baz](/uri)](/uri)*](/uri)\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[foo ", range: (0,0)-(0,4))),
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "[bar ", range: (0,6)-(0,10))),
                                .link(InlineLink(link: Link(title: nil,
                                                            url: InlineString(text: "/uri", range: (0, 17)-(0, 20))),
                                                 text: [
                                                    .text(InlineString(text: "baz", range: (0,12)-(0,14)))
                                                 ],
                                                 range: (0, 11)-(0, 21))),
                                .text(InlineString(text: "](/uri)", range: (0,22)-(0,28)))
                            ],
                            range:(0, 5)-(0, 29))),
                            .text(InlineString(text: "](/uri)", range: (0,30)-(0,36)))
                        ],
                        range: (0, 0)-(0, 37)))
                       ]))
    }
    
    func testCase516() throws {
        // HTML: <p><img src=\"uri3\" alt=\"[foo](uri2)\" /></p>\n
        /* Markdown
         ![[[foo](uri1)](uri2)](uri3)
         
         */
        XCTAssertEqual(try compile("![[[foo](uri1)](uri2)](uri3)\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .image(InlineImage(link: Link(title: nil,
                                                          url: InlineString(text: "uri3", range: (0, 23)-(0, 26))),
                                               alt: InlineString(text: "[foo](uri2)", range: (0, 2)-(0, 20)),
                                               range: (0, 0)-(0, 27)))
                        ],
                        range: (0, 0)-(0, 28)))
                       ]))
    }
    
    func testCase517() throws {
        // HTML: <p>*<a href=\"/uri\">foo*</a></p>\n
        /* Markdown
         *[foo*](/uri)
         
         */
        XCTAssertEqual(try compile("*[foo*](/uri)\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "*", range: (0,0)-(0,0))),
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/uri", range: (0, 8)-(0, 11))),
                                             text: [
                                                .text(InlineString(text: "foo*", range: (0,2)-(0,5)))
                                             ],
                                             range: (0, 1)-(0, 12)))
                        ],
                        range: (0, 0)-(0, 13)))
                       ]))
    }
    
    func testCase518() throws {
        // HTML: <p><a href=\"baz*\">foo *bar</a></p>\n
        /* Markdown
         [foo *bar](baz*)
         
         */
        XCTAssertEqual(try compile("[foo *bar](baz*)\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "baz*", range: (0, 11)-(0, 14))),
                                             text: [
                                                .text(InlineString(text: "foo *bar", range: (0,1)-(0,8)))
                                             ],
                                             range: (0, 0)-(0, 15)))
                        ],
                        range: (0, 0)-(0, 16)))
                       ]))
    }
    
    func testCase519() throws {
        // HTML: <p><em>foo [bar</em> baz]</p>\n
        /* Markdown
         *foo [bar* baz]
         
         */
        XCTAssertEqual(try compile("*foo [bar* baz]\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "foo [bar", range: (0,1)-(0,8)))
                            ],
                            range:(0, 0)-(0, 9))),
                            .text(InlineString(text: " baz]", range: (0,10)-(0,14)))
                        ],
                        range: (0, 0)-(0, 15)))
                       ]))
    }
    
    func testCase520() throws {
        // HTML: <p>[foo <bar attr=\"](baz)\"></p>\n
        /* Markdown
         [foo <bar attr="](baz)">
         
         */
        XCTAssertEqual(try compile("[foo <bar attr=\"](baz)\">\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "baz", range: (0, 18)-(0, 20))),
                                             text: [
                                                .text(InlineString(text: "foo <bar attr=”", range: (0, 1)-(0, 15)))
                                             ],
                                             range: (0, 0)-(0, 21))),
                            .text(InlineString(text: "\">", range: (0, 22)-(0, 23)))
                        ],
                        range: (0, 0)-(0, 24)))
                       ]))
    }
    
    func testCase521() throws {
        // HTML: <p>[foo<code>](/uri)</code></p>\n
        /* Markdown
         [foo`](/uri)`
         
         */
        XCTAssertEqual(try compile("[foo`](/uri)`\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[foo", range: (0,0)-(0,3))),
                            .code(InlineCode(code: InlineString(text: "](/uri)", range: (0, 5)-(0, 11)),
                                             range: (0, 4)-(0, 12)))
                        ],
                        range: (0, 0)-(0, 13)))
                       ]))
    }
    
    func testCase522() throws {
        // HTML: <p>[foo<a href=\"http://example.com/?search=%5D(uri)\">http://example.com/?search=](uri)</a></p>\n
        /* Markdown
         [foo<http://example.com/?search=](uri)>
         
         */
        XCTAssertEqual(try compile("[foo<http://example.com/?search=](uri)>\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[foo", range: (0,0)-(0,3))),
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "http://example.com/?search=](uri)", range: (0, 5)-(0, 37))),
                                             text: [
                                                .text(InlineString(text: "http://example.com/?search=](uri)", range: (0,5)-(0,37)))
                                             ],
                                             range: (0, 4)-(0, 38)))
                        ],
                        range: (0, 0)-(0, 39)))
                       ]))
    }
    
    func testCase523() throws {
        // HTML: <p><a href=\"/url\" title=\"title\">foo</a></p>\n
        /* Markdown
         [foo][bar]
         
         [bar]: /url "title"
         
         */
        XCTAssertEqual(try compile("[foo][bar]\n\n[bar]: /url \"title\"\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: InlineString(text: "title", range: (2, 12)-(2, 18)),
                                                        url: InlineString(text: "/url", range: (2, 7)-(2, 10))),
                                             text: [
                                                .text(InlineString(text: "foo", range: (0,1)-(0,3)))
                                             ],
                                             range: (0, 0)-(0, 9)))
                        ],
                        range: (0, 0)-(0, 10)))
                       ]))
    }
    
    func testCase524() throws {
        // HTML: <p><a href=\"/uri\">link [foo [bar]]</a></p>\n
        /* Markdown
         [link [foo [bar]]][ref]
         
         [ref]: /uri
         
         */
        XCTAssertEqual(try compile("[link [foo [bar]]][ref]\n\n[ref]: /uri\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/uri", range: (2, 7)-(2, 10))),
                                             text: [
                                                .text(InlineString(text: "link [foo [bar]]", range: (0,1)-(0,16)))
                                             ],
                                             range: (0, 0)-(0, 22)))
                        ],
                        range: (0, 0)-(0, 23)))
                       ]))
    }
    
    func testCase525() throws {
        // HTML: <p><a href=\"/uri\">link [bar</a></p>\n
        /* Markdown
         [link \[bar][ref]
         
         [ref]: /uri
         
         */
        XCTAssertEqual(try compile("[link \\[bar][ref]\n\n[ref]: /uri\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/uri", range: (2, 7)-(2, 10))),
                                             text: [
                                                .text(InlineString(text: "link [bar", range: (0, 1)-(0, 10)))
                                             ],
                                             range: (0, 0)-(0, 16)))
                        ],
                        range: (0, 0)-(0, 17)))
                       ]))
    }
    
    func testCase526() throws {
        // HTML: <p><a href=\"/uri\">link <em>foo <strong>bar</strong> <code>#</code></em></a></p>\n
        /* Markdown
         [link *foo **bar** `#`*][ref]
         
         [ref]: /uri
         
         */
        XCTAssertEqual(try compile("[link *foo **bar** `#`*][ref]\n\n[ref]: /uri\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/uri", range: (2, 7)-(2, 10))),
                                             text: [
                                                .text(InlineString(text: "link ", range: (0,1)-(0,5))),
                                                .emphasis(InlineEmphasis(text: [
                                                    .text(InlineString(text: "foo ", range: (0,7)-(0,10))),
                                                    .strong(InlineStrong(text: [
                                                        .text(InlineString(text: "bar", range: (0,13)-(0,15)))
                                                    ],
                                                    range:(0, 11)-(0, 17))),
                                                    .text(InlineString(text: " ", range: (0,18)-(0,18))),
                                                    .code(InlineCode(code: InlineString(text: "#", range: (0, 20)-(0, 20)),
                                                                     range: (0, 19)-(0, 21)))
                                                ],
                                                range:(0, 6)-(0, 22)))
                                             ],
                                             range: (0, 0)-(0, 28)))
                        ],
                        range: (0, 0)-(0, 29)))
                       ]))
    }
    
    func testCase527() throws {
        // HTML: <p><a href=\"/uri\"><img src=\"moon.jpg\" alt=\"moon\" /></a></p>\n
        /* Markdown
         [![moon](moon.jpg)][ref]
         
         [ref]: /uri
         
         */
        XCTAssertEqual(try compile("[![moon](moon.jpg)][ref]\n\n[ref]: /uri\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/uri", range: (2, 7)-(2, 10))),
                                             text: [
                                                .image(InlineImage(link: Link(title: nil,
                                                                              url: InlineString(text: "moon.jpg", range: (0, 9)-(0, 16))),
                                                                   alt: InlineString(text: "moon", range: (0, 3)-(0, 6)),
                                                                   range: (0, 1)-(0, 17)))
                                             ],
                                             range: (0, 0)-(0, 23)))
                        ],
                        range: (0, 0)-(0, 24)))
                       ]))
    }
    
    func testCase528() throws {
        // HTML: <p>[foo <a href=\"/uri\">bar</a>]<a href=\"/uri\">ref</a></p>\n
        /* Markdown
         [foo [bar](/uri)][ref]
         
         [ref]: /uri
         
         */
        XCTAssertEqual(try compile("[foo [bar](/uri)][ref]\n\n[ref]: /uri\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[foo ", range: (0,0)-(0,4))),
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/uri", range: (0, 11)-(0, 14))),
                                             text: [
                                                .text(InlineString(text: "bar", range: (0,6)-(0,8)))
                                             ],
                                             range: (0, 5)-(0, 15))),
                            .text(InlineString(text: "]", range: (0,16)-(0,16))),
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/uri", range: (2, 7)-(2, 10))),
                                             text: [
                                                .text(InlineString(text: "ref", range: (0,18)-(0,20)))
                                             ],
                                             range: (0, 17)-(0, 21)))
                        ],
                        range: (0, 0)-(0, 22)))
                       ]))
    }
    
    func testCase529() throws {
        // HTML: <p>[foo <em>bar <a href=\"/uri\">baz</a></em>]<a href=\"/uri\">ref</a></p>\n
        /* Markdown
         [foo *bar [baz][ref]*][ref]
         
         [ref]: /uri
         
         */
        XCTAssertEqual(try compile("[foo *bar [baz][ref]*][ref]\n\n[ref]: /uri\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[foo ", range: (0,0)-(0,4))),
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "bar ", range: (0,6)-(0,9))),
                                .link(InlineLink(link: Link(title: nil,
                                                            url: InlineString(text: "/uri", range: (2, 7)-(2, 10))),
                                                 text: [
                                                    .text(InlineString(text: "baz", range: (0,11)-(0,13)))
                                                 ],
                                                 range: (0, 10)-(0, 19)))
                            ],
                            range:(0, 5)-(0, 20))),
                            .text(InlineString(text: "]", range: (0,21)-(0,21))),
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/uri", range: (2, 7)-(2, 10))),
                                             text: [
                                                .text(InlineString(text: "ref", range: (0,23)-(0,25)))
                                             ],
                                             range: (0, 22)-(0, 26)))
                        ],
                        range: (0, 0)-(0, 27)))
                       ]))
    }
    
    func testCase530() throws {
        // HTML: <p>*<a href=\"/uri\">foo*</a></p>\n
        /* Markdown
         *[foo*][ref]
         
         [ref]: /uri
         
         */
        XCTAssertEqual(try compile("*[foo*][ref]\n\n[ref]: /uri\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "*", range: (0,0)-(0,0))),
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/uri", range: (2, 7)-(2, 10))),
                                             text: [
                                                .text(InlineString(text: "foo*", range: (0,2)-(0,5)))
                                             ],
                                             range: (0, 1)-(0, 11)))
                        ],
                        range: (0, 0)-(0, 12)))
                       ]))
    }
    
    func testCase531() throws {
        // HTML: <p><a href=\"/uri\">foo *bar</a></p>\n
        /* Markdown
         [foo *bar][ref]
         
         [ref]: /uri
         
         */
        XCTAssertEqual(try compile("[foo *bar][ref]\n\n[ref]: /uri\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/uri", range: (2, 7)-(2, 10))),
                                             text: [
                                                .text(InlineString(text: "foo *bar", range: (0,1)-(0,8)))
                                             ],
                                             range: (0, 0)-(0, 14)))
                        ],
                        range: (0, 0)-(0, 15)))
                       ]))
    }
    
    func testCase532() throws {
        // HTML: <p>[foo <bar attr=\"][ref]\"></p>\n
        /* Markdown
         [foo <bar attr="][ref]">
         
         [ref]: /uri
         
         */
        XCTAssertEqual(try compile("[foo <bar attr=\"][ref]\">\n\n[ref]: /uri\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/uri", range:  (2, 7)-(2, 10))),
                                             text: [
                                                .text(InlineString(text: "foo <bar attr=”", range: (0, 1)-(0, 15)))
                                             ],
                                             range: (0, 0)-(0, 21))),
                            .text(InlineString(text: "\">", range: (0, 22)-(0, 23)))
                        ],
                        range: (0, 0)-(0, 24)))
                       ]))
    }
    
    func testCase533() throws {
        // HTML: <p>[foo<code>][ref]</code></p>\n
        /* Markdown
         [foo`][ref]`
         
         [ref]: /uri
         
         */
        XCTAssertEqual(try compile("[foo`][ref]`\n\n[ref]: /uri\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[foo", range: (0,0)-(0,3))),
                            .code(InlineCode(code: InlineString(text: "][ref]", range: (0, 5)-(0, 10)),
                                             range: (0, 4)-(0, 11)))
                        ],
                        range: (0, 0)-(0, 12)))
                       ]))
    }
    
    func testCase534() throws {
        // HTML: <p>[foo<a href=\"http://example.com/?search=%5D%5Bref%5D\">http://example.com/?search=][ref]</a></p>\n
        /* Markdown
         [foo<http://example.com/?search=][ref]>
         
         [ref]: /uri
         
         */
        XCTAssertEqual(try compile("[foo<http://example.com/?search=][ref]>\n\n[ref]: /uri\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[foo", range: (0,0)-(0,3))),
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "http://example.com/?search=][ref]", range: (0, 5)-(0, 37))),
                                             text: [
                                                .text(InlineString(text: "http://example.com/?search=][ref]", range: (0,5)-(0,37)))
                                             ],
                                             range: (0, 4)-(0, 38)))
                        ],
                        range: (0, 0)-(0, 39)))
                       ]))
    }
    
    func testCase535() throws {
        // HTML: <p><a href=\"/url\" title=\"title\">foo</a></p>\n
        /* Markdown
         [foo][BaR]
         
         [bar]: /url "title"
         
         */
        XCTAssertEqual(try compile("[foo][BaR]\n\n[bar]: /url \"title\"\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: InlineString(text: "title", range: (2, 12)-(2, 18)),
                                                        url: InlineString(text: "/url", range: (2, 7)-(2, 10))),
                                             text: [
                                                .text(InlineString(text: "foo", range: (0,1)-(0,3)))
                                             ],
                                             range: (0, 0)-(0, 9)))
                        ],
                        range: (0, 0)-(0, 10)))
                       ]))
    }
    
    func testCase536() throws {
        // HTML: <p><a href=\"/url\">Толпой</a> is a Russian word.</p>\n
        /* Markdown
         [Толпой][Толпой] is a Russian word.
         
         [ТОЛПОЙ]: /url
         
         */
        XCTAssertEqual(try compile("[Толпой][Толпой] is a Russian word.\n\n[ТОЛПОЙ]: /url\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/url", range: (2, 10)-(2, 13))),
                                             text: [
                                                .text(InlineString(text: "Толпой", range: (0,1)-(0,6)))
                                             ],
                                             range: (0, 0)-(0, 15))),
                            .text(InlineString(text: " is a Russian word.", range: (0,16)-(0,34)))
                        ],
                        range: (0, 0)-(0, 35)))
                       ]))
    }
    
    func testCase537() throws {
        // HTML: <p><a href=\"/url\">Baz</a></p>\n
        /* Markdown
         [Foo
         bar]: /url
         
         [Baz][Foo bar]
         
         */
        XCTAssertEqual(try compile("[Foo\n  bar]: /url\n\n[Baz][Foo bar]\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/url", range: (1, 8)-(1, 11))),
                                             text: [
                                                .text(InlineString(text: "Baz", range: (3,1)-(3,3)))
                                             ],
                                             range: (3, 0)-(3, 13)))
                        ],
                        range: (3, 0)-(3, 14)))
                       ]))
    }
    
    func testCase538() throws {
        // HTML: <p>[foo] <a href=\"/url\" title=\"title\">bar</a></p>\n
        /* Markdown
         [foo] [bar]
         
         [bar]: /url "title"
         
         */
        XCTAssertEqual(try compile("[foo] [bar]\n\n[bar]: /url \"title\"\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[foo] ", range: (0,0)-(0,5))),
                            .link(InlineLink(link: Link(title: InlineString(text: "title", range: (2, 12)-(2, 18)),
                                                        url: InlineString(text: "/url", range: (2, 7)-(2, 10))),
                                             text: [
                                                .text(InlineString(text: "bar", range: (0,7)-(0,9)))
                                             ],
                                             range: (0, 6)-(0, 10)))
                        ],
                        range: (0, 0)-(0, 11)))
                       ]))
    }
    
    func testCase539() throws {
        // HTML: <p>[foo]\n<a href=\"/url\" title=\"title\">bar</a></p>\n
        /* Markdown
         [foo]
         [bar]
         
         [bar]: /url "title"
         
         */
        XCTAssertEqual(try compile("[foo]\n[bar]\n\n[bar]: /url \"title\"\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[foo]", range: (0,0)-(0,4))),
                            .softbreak(InlineSoftbreak(range: (0, 5)-(0, 5))),
                            .link(InlineLink(link: Link(title: InlineString(text: "title", range: (3, 12)-(3, 18)),
                                                        url: InlineString(text: "/url", range: (3, 7)-(3, 10))),
                                             text: [
                                                .text(InlineString(text: "bar", range: (1,1)-(1,3)))
                                             ],
                                             range: (1, 0)-(1, 4)))
                        ],
                        range: (0, 0)-(1, 5)))
                       ]))
    }
    
    func testCase540() throws {
        // HTML: <p><a href=\"/url1\">bar</a></p>\n
        /* Markdown
         [foo]: /url1
         
         [foo]: /url2
         
         [bar][foo]
         
         */
        XCTAssertEqual(try compile("[foo]: /url1\n\n[foo]: /url2\n\n[bar][foo]\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/url1", range: (0, 7)-(0, 11))),
                                             text: [
                                                .text(InlineString(text: "bar", range: (4,1)-(4,3)))
                                             ],
                                             range: (4, 0)-(4, 9)))
                        ],
                        range: (4, 0)-(4, 10)))
                       ]))
    }
    
    func testCase541() throws {
        // HTML: <p>[bar][foo!]</p>\n
        /* Markdown
         [bar][foo\!]
         
         [foo!]: /url
         
         */
        XCTAssertEqual(try compile("[bar][foo\\!]\n\n[foo!]: /url\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[bar][foo!]", range: (0, 0)-(0, 11)))
                        ],
                        range: (0, 0)-(0, 12)))
                       ]))
    }
    
    func testCase542() throws {
        // HTML: <p>[foo][ref[]</p>\n<p>[ref[]: /uri</p>\n
        /* Markdown
         [foo][ref[]
         
         [ref[]: /uri
         
         */
        XCTAssertEqual(try compile("[foo][ref[]\n\n[ref[]: /uri\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[foo][ref[]", range: (0,0)-(0,10)))
                        ],
                        range: (0, 0)-(0, 11))),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[ref[]: /uri", range: (2,0)-(2,11)))
                        ],
                        range: (2, 0)-(2, 12)))
                       ]))
    }
    
    func testCase543() throws {
        // HTML: <p>[foo][ref[bar]]</p>\n<p>[ref[bar]]: /uri</p>\n
        /* Markdown
         [foo][ref[bar]]
         
         [ref[bar]]: /uri
         
         */
        XCTAssertEqual(try compile("[foo][ref[bar]]\n\n[ref[bar]]: /uri\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[foo][ref[bar]]", range: (0,0)-(0,14)))
                        ],
                        range: (0, 0)-(0, 15))),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[ref[bar]]: /uri", range: (2,0)-(2,15)))
                        ],
                        range: (2, 0)-(2, 16)))
                       ]))
    }
    
    func testCase544() throws {
        // HTML: <p>[[[foo]]]</p>\n<p>[[[foo]]]: /url</p>\n
        /* Markdown
         [[[foo]]]
         
         [[[foo]]]: /url
         
         */
        XCTAssertEqual(try compile("[[[foo]]]\n\n[[[foo]]]: /url\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[[[foo]]]", range: (0,0)-(0,8)))
                        ],
                        range: (0, 0)-(0, 9))),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[[[foo]]]: /url", range: (2,0)-(2,14)))
                        ],
                        range: (2, 0)-(2, 15)))
                       ]))
    }
    
    func testCase545() throws {
        // HTML: <p><a href=\"/uri\">foo</a></p>\n
        /* Markdown
         [foo][ref\[]
         
         [ref\[]: /uri
         
         */
        XCTAssertEqual(try compile("[foo][ref\\[]\n\n[ref\\[]: /uri\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/uri", range: (2, 9)-(2, 12))),
                                             text: [
                                                .text(InlineString(text: "foo", range: (0,1)-(0,3)))
                                             ],
                                             range: (0, 0)-(0, 11)))
                        ],
                        range: (0, 0)-(0, 12)))
                       ]))
    }
    
    func testCase546() throws {
        // HTML: <p><a href=\"/uri\">bar\\</a></p>\n
        /* Markdown
         [bar\\]: /uri
         
         [bar\\]
         
         */
        XCTAssertEqual(try compile("[bar\\\\]: /uri\n\n[bar\\\\]\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/uri", range: (0, 9)-(0, 12))),
                                             text: [
                                                .text(InlineString(text: "bar\\", range: (2,1)-(2,5)))
                                             ],
                                             range: (2, 0)-(2, 6)))
                        ],
                        range: (2, 0)-(2, 7)))
                       ]))
    }
    
    func testCase547() throws {
        // HTML: <p>[]</p>\n<p>[]: /uri</p>\n
        /* Markdown
         []
         
         []: /uri
         
         */
        XCTAssertEqual(try compile("[]\n\n[]: /uri\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[]", range: (0,0)-(0,1)))
                        ],
                        range: (0, 0)-(0, 2))),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[]: /uri", range: (2,0)-(2,7)))
                        ],
                        range: (2, 0)-(2, 8)))
                       ]))
    }
    
    func testCase548() throws {
        // HTML: <p>[\n]</p>\n<p>[\n]: /uri</p>\n
        /* Markdown
         [
         ]
         
         [
         ]: /uri
         
         */
        XCTAssertEqual(try compile("[\n ]\n\n[\n ]: /uri\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[", range: (0,0)-(0,0))),
                            .softbreak(InlineSoftbreak(range: (0, 1)-(1, 0))),
                            .text(InlineString(text: "]", range: (1,1)-(1,1)))
                        ],
                        range: (0, 0)-(1, 2))),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[", range: (3,0)-(3,0))),
                            .softbreak(InlineSoftbreak(range: (3, 1)-(4, 0))),
                            .text(InlineString(text: "]: /uri", range: (4,1)-(4,7)))
                        ],
                        range: (3, 0)-(4, 8)))
                       ]))
    }
    
    func testCase549() throws {
        // HTML: <p><a href=\"/url\" title=\"title\">foo</a></p>\n
        /* Markdown
         [foo][]
         
         [foo]: /url "title"
         
         */
        XCTAssertEqual(try compile("[foo][]\n\n[foo]: /url \"title\"\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: InlineString(text: "title", range: (2, 12)-(2, 18)),
                                                        url: InlineString(text: "/url", range: (2, 7)-(2, 10))),
                                             text: [
                                                .text(InlineString(text: "foo", range: (0,1)-(0,3)))
                                             ],
                                             range: (0, 0)-(0, 6)))
                        ],
                        range: (0, 0)-(0, 7)))
                       ]))
    }
    
    func testCase550() throws {
        // HTML: <p><a href=\"/url\" title=\"title\"><em>foo</em> bar</a></p>\n
        /* Markdown
         [*foo* bar][]
         
         [*foo* bar]: /url "title"
         
         */
        XCTAssertEqual(try compile("[*foo* bar][]\n\n[*foo* bar]: /url \"title\"\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: InlineString(text: "title", range: (2, 18)-(2, 24)),
                                                        url: InlineString(text: "/url", range: (2, 13)-(2, 16))),
                                             text: [
                                                .emphasis(InlineEmphasis(text: [
                                                    .text(InlineString(text: "foo", range: (0,2)-(0,4)))
                                                ],
                                                range:(0, 1)-(0, 5))),
                                                .text(InlineString(text: " bar", range: (0,6)-(0,9)))
                                             ],
                                             range: (0, 0)-(0, 12)))
                        ],
                        range: (0, 0)-(0, 13)))
                       ]))
    }
    
    func testCase551() throws {
        // HTML: <p><a href=\"/url\" title=\"title\">Foo</a></p>\n
        /* Markdown
         [Foo][]
         
         [foo]: /url "title"
         
         */
        XCTAssertEqual(try compile("[Foo][]\n\n[foo]: /url \"title\"\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: InlineString(text: "title", range: (2, 12)-(2, 18)),
                                                        url: InlineString(text: "/url", range: (2, 7)-(2, 10))),
                                             text: [
                                                .text(InlineString(text: "Foo", range: (0,1)-(0,3)))
                                             ],
                                             range: (0, 0)-(0, 6)))
                        ],
                        range: (0, 0)-(0, 7)))
                       ]))
    }
    
    func testCase552() throws {
        // HTML: <p><a href=\"/url\" title=\"title\">foo</a>\n[]</p>\n
        /* Markdown
         [foo]
         []
         
         [foo]: /url "title"
         
         */
        XCTAssertEqual(try compile("[foo] \n[]\n\n[foo]: /url \"title\"\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: InlineString(text: "title", range: (3, 12)-(3, 18)),
                                                        url: InlineString(text: "/url", range: (3, 7)-(3, 10))),
                                             text: [
                                                .text(InlineString(text: "foo", range: (0,1)-(0,3)))
                                             ],
                                             range: (0, 0)-(0, 4))),
                            .softbreak(InlineSoftbreak(range: (0, 5)-(0, 6))),
                            .text(InlineString(text: "[]", range: (1,0)-(1,1)))
                        ],
                        range: (0, 0)-(1, 2)))
                       ]))
    }
    
    func testCase553() throws {
        // HTML: <p><a href=\"/url\" title=\"title\">foo</a></p>\n
        /* Markdown
         [foo]
         
         [foo]: /url "title"
         
         */
        XCTAssertEqual(try compile("[foo]\n\n[foo]: /url \"title\"\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: InlineString(text: "title", range: (2, 12)-(2, 18)),
                                                        url: InlineString(text: "/url", range: (2, 7)-(2, 10))),
                                             text: [
                                                .text(InlineString(text: "foo", range: (0,1)-(0,3)))
                                             ],
                                             range: (0, 0)-(0, 4)))
                        ],
                        range: (0, 0)-(0, 5)))
                       ]))
    }
    
    func testCase554() throws {
        // HTML: <p><a href=\"/url\" title=\"title\"><em>foo</em> bar</a></p>\n
        /* Markdown
         [*foo* bar]
         
         [*foo* bar]: /url "title"
         
         */
        XCTAssertEqual(try compile("[*foo* bar]\n\n[*foo* bar]: /url \"title\"\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: InlineString(text: "title", range: (2, 18)-(2, 24)),
                                                        url: InlineString(text: "/url", range: (2, 13)-(2, 16))),
                                             text: [
                                                .emphasis(InlineEmphasis(text: [
                                                    .text(InlineString(text: "foo", range: (0,2)-(0,4)))
                                                ],
                                                range:(0, 1)-(0, 5))),
                                                .text(InlineString(text: " bar", range: (0,6)-(0,9)))
                                             ],
                                             range: (0, 0)-(0, 10)))
                        ],
                        range: (0, 0)-(0, 11)))
                       ]))
    }
    
    func testCase555() throws {
        // HTML: <p>[<a href=\"/url\" title=\"title\"><em>foo</em> bar</a>]</p>\n
        /* Markdown
         [[*foo* bar]]
         
         [*foo* bar]: /url "title"
         
         */
        XCTAssertEqual(try compile("[[*foo* bar]]\n\n[*foo* bar]: /url \"title\"\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[", range: (0,0)-(0,0))),
                            .link(InlineLink(link: Link(title: InlineString(text: "title", range: (2, 18)-(2, 24)),
                                                        url: InlineString(text: "/url", range: (2, 13)-(2, 16))),
                                             text: [
                                                .emphasis(InlineEmphasis(text: [
                                                    .text(InlineString(text: "foo", range: (0,3)-(0,5)))
                                                ],
                                                range:(0, 2)-(0, 6))),
                                                .text(InlineString(text: " bar", range: (0,7)-(0,10)))
                                             ],
                                             range: (0, 1)-(0, 11))),
                            .text(InlineString(text: "]", range: (0,12)-(0,12)))
                        ],
                        range: (0, 0)-(0, 13)))
                       ]))
    }
    
    func testCase556() throws {
        // HTML: <p>[[bar <a href=\"/url\">foo</a></p>\n
        /* Markdown
         [[bar [foo]
         
         [foo]: /url
         
         */
        XCTAssertEqual(try compile("[[bar [foo]\n\n[foo]: /url\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[[bar ", range: (0,0)-(0,5))),
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/url", range: (2, 7)-(2, 10))),
                                             text: [
                                                .text(InlineString(text: "foo", range: (0,7)-(0,9)))
                                             ],
                                             range: (0, 6)-(0, 10)))
                        ],
                        range: (0, 0)-(0, 11)))
                       ]))
    }
    
    func testCase557() throws {
        // HTML: <p><a href=\"/url\" title=\"title\">Foo</a></p>\n
        /* Markdown
         [Foo]
         
         [foo]: /url "title"
         
         */
        XCTAssertEqual(try compile("[Foo]\n\n[foo]: /url \"title\"\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: InlineString(text: "title", range: (2, 12)-(2, 18)),
                                                        url: InlineString(text: "/url", range: (2, 7)-(2, 10))),
                                             text: [
                                                .text(InlineString(text: "Foo", range: (0,1)-(0,3)))
                                             ],
                                             range: (0, 0)-(0, 4)))
                        ],
                        range: (0, 0)-(0, 5)))
                       ]))
    }
    
    func testCase558() throws {
        // HTML: <p><a href=\"/url\">foo</a> bar</p>\n
        /* Markdown
         [foo] bar
         
         [foo]: /url
         
         */
        XCTAssertEqual(try compile("[foo] bar\n\n[foo]: /url\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/url", range: (2, 7)-(2, 10))),
                                             text: [
                                                .text(InlineString(text: "foo", range: (0,1)-(0,3)))
                                             ],
                                             range: (0, 0)-(0, 4))),
                            .text(InlineString(text: " bar", range: (0,5)-(0,8)))
                        ],
                        range: (0, 0)-(0, 9)))
                       ]))
    }
    
    func testCase559() throws {
        // HTML: <p>[foo]</p>\n
        /* Markdown
         \[foo]
         
         [foo]: /url "title"
         
         */
        XCTAssertEqual(try compile("\\[foo]\n\n[foo]: /url \"title\"\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[foo]", range: (0,0)-(0,5)))
                        ],
                        range: (0, 0)-(0, 6)))
                       ]))
    }
    
    func testCase560() throws {
        // HTML: <p>*<a href=\"/url\">foo*</a></p>\n
        /* Markdown
         [foo*]: /url
         
         *[foo*]
         
         */
        XCTAssertEqual(try compile("[foo*]: /url\n\n*[foo*]\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "*", range: (2,0)-(2,0))),
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/url", range: (0, 8)-(0, 11))),
                                             text: [
                                                .text(InlineString(text: "foo*", range: (2,2)-(2,5)))
                                             ],
                                             range: (2, 1)-(2, 6)))
                        ],
                        range: (2, 0)-(2, 7)))
                       ]))
    }
    
    func testCase561() throws {
        // HTML: <p><a href=\"/url2\">foo</a></p>\n
        /* Markdown
         [foo][bar]
         
         [foo]: /url1
         [bar]: /url2
         
         */
        XCTAssertEqual(try compile("[foo][bar]\n\n[foo]: /url1\n[bar]: /url2\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/url2", range: (3, 7)-(3, 11))),
                                             text: [
                                                .text(InlineString(text: "foo", range: (0,1)-(0,3)))
                                             ],
                                             range: (0, 0)-(0, 9)))
                        ],
                        range: (0, 0)-(0, 10)))
                       ]))
    }
    
    func testCase562() throws {
        // HTML: <p><a href=\"/url1\">foo</a></p>\n
        /* Markdown
         [foo][]
         
         [foo]: /url1
         
         */
        XCTAssertEqual(try compile("[foo][]\n\n[foo]: /url1\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/url1", range: (2, 7)-(2, 11))),
                                             text: [
                                                .text(InlineString(text: "foo", range: (0,1)-(0,3)))
                                             ],
                                             range: (0, 0)-(0, 6)))
                        ],
                        range: (0, 0)-(0, 7)))
                       ]))
    }
    
    func testCase563() throws {
        // HTML: <p><a href=\"\">foo</a></p>\n
        /* Markdown
         [foo]()
         
         [foo]: /url1
         
         */
        XCTAssertEqual(try compile("[foo]()\n\n[foo]: /url1\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: nil),
                                             text: [
                                                .text(InlineString(text: "foo", range: (0,1)-(0,3)))
                                             ],
                                             range: (0, 0)-(0, 6)))
                        ],
                        range: (0, 0)-(0, 7)))
                       ]))
    }
    
    func testCase564() throws {
        // HTML: <p><a href=\"/url1\">foo</a>(not a link)</p>\n
        /* Markdown
         [foo](not a link)
         
         [foo]: /url1
         
         */
        XCTAssertEqual(try compile("[foo](not a link)\n\n[foo]: /url1\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/url1", range: (2, 7)-(2, 11))),
                                             text: [
                                                .text(InlineString(text: "foo", range: (0,1)-(0,3)))
                                             ],
                                             range: (0, 0)-(0, 4))),
                            .text(InlineString(text: "(not a link)", range: (0,5)-(0,16)))
                        ],
                        range: (0, 0)-(0, 17)))
                       ]))
    }
    
    func testCase565() throws {
        // HTML: <p>[foo]<a href=\"/url\">bar</a></p>\n
        /* Markdown
         [foo][bar][baz]
         
         [baz]: /url
         
         */
        XCTAssertEqual(try compile("[foo][bar][baz]\n\n[baz]: /url\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[foo]", range: (0,0)-(0,4))),
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/url", range: (2, 7)-(2, 10))),
                                             text: [
                                                .text(InlineString(text: "bar", range: (0,6)-(0,8)))
                                             ],
                                             range: (0, 5)-(0, 14)))
                        ],
                        range: (0, 0)-(0, 15)))
                       ]))
    }
    
    func testCase566() throws {
        // HTML: <p><a href=\"/url2\">foo</a><a href=\"/url1\">baz</a></p>\n
        /* Markdown
         [foo][bar][baz]
         
         [baz]: /url1
         [bar]: /url2
         
         */
        XCTAssertEqual(try compile("[foo][bar][baz]\n\n[baz]: /url1\n[bar]: /url2\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/url2", range: (3, 7)-(3, 11))),
                                             text: [
                                                .text(InlineString(text: "foo", range: (0,1)-(0,3)))
                                             ],
                                             range: (0, 0)-(0, 9))),
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/url1", range: (2, 7)-(2, 11))),
                                             text: [
                                                .text(InlineString(text: "baz", range: (0,11)-(0,13)))
                                             ],
                                             range: (0, 10)-(0, 14)))
                        ],
                        range: (0, 0)-(0, 15)))
                       ]))
    }
    
    func testCase567() throws {
        // HTML: <p>[foo]<a href=\"/url1\">bar</a></p>\n
        /* Markdown
         [foo][bar][baz]
         
         [baz]: /url1
         [foo]: /url2
         
         */
        XCTAssertEqual(try compile("[foo][bar][baz]\n\n[baz]: /url1\n[foo]: /url2\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[foo]", range: (0,0)-(0,4))),
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/url1", range: (2, 7)-(2, 11))),
                                             text: [
                                                .text(InlineString(text: "bar", range: (0,6)-(0,8)))
                                             ],
                                             range: (0, 5)-(0, 14)))
                        ],
                        range: (0, 0)-(0, 15)))
                       ]))
    }
    
    
}
