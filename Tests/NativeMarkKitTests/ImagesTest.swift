import Foundation
import XCTest
@testable import NativeMarkKit

final class ImagesTest: XCTestCase {
    func testCase568() throws {
        // HTML: <p><img src=\"/url\" alt=\"foo\" title=\"title\" /></p>\n
        /* Markdown
         ![foo](/url "title")
         
         */
        XCTAssertEqual(try compile("![foo](/url \"title\")\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .image(InlineImage(link: Link(title: InlineString(text: "title", range: (0, 12)-(0, 18)),
                                                          url: InlineString(text: "/url", range: (0, 7)-(0, 10))),
                                               alt: InlineString(text: "foo", range: (0, 2)-(0, 4)),
                                               range: (0, 0)-(0, 19)))
                        ],
                        range: (0, 0)-(0, 20)))
                       ]))
    }
    
    func testCase569() throws {
        // HTML: <p><img src=\"train.jpg\" alt=\"foo bar\" title=\"train &amp; tracks\" /></p>\n
        /* Markdown
         ![foo *bar*]
         
         [foo *bar*]: train.jpg "train & tracks"
         
         */
        XCTAssertEqual(try compile("![foo *bar*]\n\n[foo *bar*]: train.jpg \"train & tracks\"\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .image(InlineImage(link: Link(title: InlineString(text: "train & tracks", range: (2, 23)-(2, 38)),
                                                          url: InlineString(text: "train.jpg", range: (2, 13)-(2, 21))),
                                               alt: InlineString(text: "foo bar", range: (0, 2)-(0, 10)),
                                               range: (0, 0)-(0, 11)))
                        ],
                        range: (0, 0)-(0, 12)))
                       ]))
    }
    
    func testCase570() throws {
        // HTML: <p><img src=\"/url2\" alt=\"foo bar\" /></p>\n
        /* Markdown
         ![foo ![bar](/url)](/url2)
         
         */
        XCTAssertEqual(try compile("![foo ![bar](/url)](/url2)\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .image(InlineImage(link: Link(title: nil,
                                                          url: InlineString(text: "/url2", range: (0, 20)-(0, 24))),
                                               alt: InlineString(text: "foo bar", range: (0, 2)-(0, 17)),
                                               range: (0, 0)-(0, 25)))
                        ],
                        range: (0, 0)-(0, 26)))
                       ]))
    }
    
    func testCase571() throws {
        // HTML: <p><img src=\"/url2\" alt=\"foo bar\" /></p>\n
        /* Markdown
         ![foo [bar](/url)](/url2)
         
         */
        XCTAssertEqual(try compile("![foo [bar](/url)](/url2)\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .image(InlineImage(link: Link(title: nil,
                                                          url: InlineString(text: "/url2", range: (0, 19)-(0, 23))),
                                               alt: InlineString(text: "foo bar", range: (0, 2)-(0, 16)),
                                               range: (0, 0)-(0, 24)))
                        ],
                        range: (0, 0)-(0, 25)))
                       ]))
    }
    
    func testCase572() throws {
        // HTML: <p><img src=\"train.jpg\" alt=\"foo bar\" title=\"train &amp; tracks\" /></p>\n
        /* Markdown
         ![foo *bar*][]
         
         [foo *bar*]: train.jpg "train & tracks"
         
         */
        XCTAssertEqual(try compile("![foo *bar*][]\n\n[foo *bar*]: train.jpg \"train & tracks\"\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .image(InlineImage(link: Link(title: InlineString(text: "train & tracks", range: (2, 23)-(2, 38)),
                                                          url: InlineString(text: "train.jpg", range: (2, 13)-(2, 21))),
                                               alt: InlineString(text: "foo bar", range: (0, 2)-(0, 10)),
                                               range: (0, 0)-(0, 13)))
                        ],
                        range: (0, 0)-(0, 14)))
                       ]))
    }
    
    func testCase573() throws {
        // HTML: <p><img src=\"train.jpg\" alt=\"foo bar\" title=\"train &amp; tracks\" /></p>\n
        /* Markdown
         ![foo *bar*][foobar]
         
         [FOOBAR]: train.jpg "train & tracks"
         
         */
        XCTAssertEqual(try compile("![foo *bar*][foobar]\n\n[FOOBAR]: train.jpg \"train & tracks\"\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .image(InlineImage(link: Link(title: InlineString(text: "train & tracks", range: (2, 20)-(2, 35)),
                                                          url: InlineString(text: "train.jpg", range: (2, 10)-(2, 18))),
                                               alt: InlineString(text: "foo bar", range: (0, 2)-(0, 10)),
                                               range: (0, 0)-(0, 19)))
                        ],
                        range: (0, 0)-(0, 20)))
                       ]))
    }
    
    func testCase574() throws {
        // HTML: <p><img src=\"train.jpg\" alt=\"foo\" /></p>\n
        /* Markdown
         ![foo](train.jpg)
         
         */
        XCTAssertEqual(try compile("![foo](train.jpg)\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .image(InlineImage(link: Link(title: nil,
                                                          url: InlineString(text: "train.jpg", range: (0, 7)-(0, 15))),
                                               alt: InlineString(text: "foo", range: (0, 2)-(0, 4)),
                                               range: (0, 0)-(0, 16)))
                        ],
                        range: (0, 0)-(0, 17)))
                       ]))
    }
    
    func testCase575() throws {
        // HTML: <p>My <img src=\"/path/to/train.jpg\" alt=\"foo bar\" title=\"title\" /></p>\n
        /* Markdown
         My ![foo bar](/path/to/train.jpg  "title"   )
         
         */
        XCTAssertEqual(try compile("My ![foo bar](/path/to/train.jpg  \"title\"   )\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "My ", range: (0,0)-(0,2))),
                            .image(InlineImage(link: Link(title: InlineString(text: "title", range: (0, 34)-(0, 40)),
                                                          url: InlineString(text: "/path/to/train.jpg", range: (0, 14)-(0, 31))),
                                               alt: InlineString(text: "foo bar", range: (0, 5)-(0, 11)),
                                               range: (0, 3)-(0, 44)))
                        ],
                        range: (0, 0)-(0, 45)))
                       ]))
    }
    
    func testCase576() throws {
        // HTML: <p><img src=\"url\" alt=\"foo\" /></p>\n
        /* Markdown
         ![foo](<url>)
         
         */
        XCTAssertEqual(try compile("![foo](<url>)\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .image(InlineImage(link: Link(title: nil,
                                                          url: InlineString(text: "url", range: (0, 7)-(0, 11))),
                                               alt: InlineString(text: "foo", range: (0, 2)-(0, 4)),
                                               range: (0, 0)-(0, 12)))
                        ],
                        range: (0, 0)-(0, 13)))
                       ]))
    }
    
    func testCase577() throws {
        // HTML: <p><img src=\"/url\" alt=\"\" /></p>\n
        /* Markdown
         ![](/url)
         
         */
        XCTAssertEqual(try compile("![](/url)\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .image(InlineImage(link: Link(title: nil,
                                                          url: InlineString(text: "/url", range: (0, 4)-(0, 7))),
                                               alt: InlineString(text: "", range: nil),
                                               range: (0, 0)-(0, 8)))
                        ],
                        range: (0, 0)-(0, 9)))
                       ]))
    }
    
    func testCase578() throws {
        // HTML: <p><img src=\"/url\" alt=\"foo\" /></p>\n
        /* Markdown
         ![foo][bar]
         
         [bar]: /url
         
         */
        XCTAssertEqual(try compile("![foo][bar]\n\n[bar]: /url\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .image(InlineImage(link: Link(title: nil,
                                                          url: InlineString(text: "/url", range: (2, 7)-(2, 10))),
                                               alt: InlineString(text: "foo", range: (0, 2)-(0, 4)),
                                               range: (0, 0)-(0, 10)))
                        ],
                        range: (0, 0)-(0, 11)))
                       ]))
    }
    
    func testCase579() throws {
        // HTML: <p><img src=\"/url\" alt=\"foo\" /></p>\n
        /* Markdown
         ![foo][bar]
         
         [BAR]: /url
         
         */
        XCTAssertEqual(try compile("![foo][bar]\n\n[BAR]: /url\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .image(InlineImage(link: Link(title: nil,
                                                          url: InlineString(text: "/url", range: (2, 7)-(2, 10))),
                                               alt: InlineString(text: "foo", range: (0, 2)-(0, 4)),
                                               range: (0, 0)-(0, 10)))
                        ],
                        range: (0, 0)-(0, 11)))
                       ]))
    }
    
    func testCase580() throws {
        // HTML: <p><img src=\"/url\" alt=\"foo\" title=\"title\" /></p>\n
        /* Markdown
         ![foo][]
         
         [foo]: /url "title"
         
         */
        XCTAssertEqual(try compile("![foo][]\n\n[foo]: /url \"title\"\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .image(InlineImage(link: Link(title: InlineString(text: "title", range: (2, 12)-(2, 18)),
                                                          url: InlineString(text: "/url", range: (2, 7)-(2, 10))),
                                               alt: InlineString(text: "foo", range: (0, 2)-(0, 4)),
                                               range: (0, 0)-(0, 7)))
                        ],
                        range: (0, 0)-(0, 8)))
                       ]))
    }
    
    func testCase581() throws {
        // HTML: <p><img src=\"/url\" alt=\"foo bar\" title=\"title\" /></p>\n
        /* Markdown
         ![*foo* bar][]
         
         [*foo* bar]: /url "title"
         
         */
        XCTAssertEqual(try compile("![*foo* bar][]\n\n[*foo* bar]: /url \"title\"\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .image(InlineImage(link: Link(title: InlineString(text: "title", range: (2, 18)-(2, 24)),
                                                          url: InlineString(text: "/url", range: (2, 13)-(2, 16))),
                                               alt: InlineString(text: "foo bar", range: (0, 2)-(0, 10)),
                                               range: (0, 0)-(0, 13)))
                        ],
                        range: (0, 0)-(0, 14)))
                       ]))
    }
    
    func testCase582() throws {
        // HTML: <p><img src=\"/url\" alt=\"Foo\" title=\"title\" /></p>\n
        /* Markdown
         ![Foo][]
         
         [foo]: /url "title"
         
         */
        XCTAssertEqual(try compile("![Foo][]\n\n[foo]: /url \"title\"\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .image(InlineImage(link: Link(title: InlineString(text: "title", range: (2, 12)-(2, 18)),
                                                          url: InlineString(text: "/url", range: (2, 7)-(2, 10))),
                                               alt: InlineString(text: "Foo", range: (0, 2)-(0, 4)),
                                               range: (0, 0)-(0, 7)))
                        ],
                        range: (0, 0)-(0, 8)))
                       ]))
    }
    
    func testCase583() throws {
        // HTML: <p><img src=\"/url\" alt=\"foo\" title=\"title\" />\n[]</p>\n
        /* Markdown
         ![foo] 
         []
         
         [foo]: /url "title"
         
         */
        XCTAssertEqual(try compile("![foo] \n[]\n\n[foo]: /url \"title\"\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .image(InlineImage(link: Link(title: InlineString(text: "title", range: (3, 12)-(3, 18)),
                                                          url: InlineString(text: "/url", range: (3, 7)-(3, 10))),
                                               alt: InlineString(text: "foo", range: (0, 2)-(0, 4)),
                                               range: (0, 0)-(0, 5))),
                            .softbreak(InlineSoftbreak(range: (0, 6)-(0, 7))),
                            .text(InlineString(text: "[]", range: (1,0)-(1,1)))
                        ],
                        range: (0, 0)-(1, 2)))
                       ]))
    }
    
    func testCase584() throws {
        // HTML: <p><img src=\"/url\" alt=\"foo\" title=\"title\" /></p>\n
        /* Markdown
         ![foo]
         
         [foo]: /url "title"
         
         */
        XCTAssertEqual(try compile("![foo]\n\n[foo]: /url \"title\"\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .image(InlineImage(link: Link(title: InlineString(text: "title", range: (2, 12)-(2, 18)),
                                                          url: InlineString(text: "/url", range: (2, 7)-(2, 10))),
                                               alt: InlineString(text: "foo", range: (0, 2)-(0, 4)),
                                               range: (0, 0)-(0, 5)))
                        ],
                        range: (0, 0)-(0, 6)))
                       ]))
    }
    
    func testCase585() throws {
        // HTML: <p><img src=\"/url\" alt=\"foo bar\" title=\"title\" /></p>\n
        /* Markdown
         ![*foo* bar]
         
         [*foo* bar]: /url "title"
         
         */
        XCTAssertEqual(try compile("![*foo* bar]\n\n[*foo* bar]: /url \"title\"\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .image(InlineImage(link: Link(title: InlineString(text: "title", range: (2, 18)-(2, 24)),
                                                          url: InlineString(text: "/url", range: (2, 13)-(2,16))),
                                               alt: InlineString(text: "foo bar", range: (0, 2)-(0, 10)),
                                               range: (0, 0)-(0, 11)))
                        ],
                        range: (0, 0)-(0, 12)))
                       ]))
    }
    
    func testCase586() throws {
        // HTML: <p>![[foo]]</p>\n<p>[[foo]]: /url &quot;title&quot;</p>\n
        /* Markdown
         ![[foo]]
         
         [[foo]]: /url "title"
         
         */
        XCTAssertEqual(try compile("![[foo]]\n\n[[foo]]: /url \"title\"\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "![[foo]]", range: (0,0)-(0,7)))
                        ],
                        range: (0, 0)-(0, 8))),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "[[foo]]: /url “title”", range: (2, 0)-(2, 20)))
                        ],
                        range: (2, 0)-(2, 21)))
                       ]))
    }
    
    func testCase587() throws {
        // HTML: <p><img src=\"/url\" alt=\"Foo\" title=\"title\" /></p>\n
        /* Markdown
         ![Foo]
         
         [foo]: /url "title"
         
         */
        XCTAssertEqual(try compile("![Foo]\n\n[foo]: /url \"title\"\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .image(InlineImage(link: Link(title: InlineString(text: "title", range: (2, 12)-(2, 18)),
                                                          url: InlineString(text: "/url", range: (2, 7)-(2, 10))),
                                               alt: InlineString(text: "Foo", range: (0, 2)-(0, 4)),
                                               range: (0, 0)-(0, 5)))
                        ],
                        range: (0, 0)-(0, 6)))
                       ]))
    }
    
    func testCase588() throws {
        // HTML: <p>![foo]</p>\n
        /* Markdown
         !\[foo]
         
         [foo]: /url "title"
         
         */
        XCTAssertEqual(try compile("!\\[foo]\n\n[foo]: /url \"title\"\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "![foo]", range: (0, 0)-(0, 6)))
                        ],
                        range: (0, 0)-(0, 7)))
                       ]))
    }
    
    func testCase589() throws {
        // HTML: <p>!<a href=\"/url\" title=\"title\">foo</a></p>\n
        /* Markdown
         \![foo]
         
         [foo]: /url "title"
         
         */
        XCTAssertEqual(try compile("\\![foo]\n\n[foo]: /url \"title\"\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "!", range: (0,0)-(0,1))),
                            .link(InlineLink(link: Link(title: InlineString(text: "title", range: (2, 12)-(2, 18)),
                                                        url: InlineString(text: "/url", range: (2, 7)-(2, 10))),
                                             text: [
                                                .text(InlineString(text: "foo", range: (0,3)-(0,5)))
                                             ],
                                             range: (0, 2)-(0, 6)))
                        ],
                        range: (0, 0)-(0, 7)))
                       ]))
    }
    
    
}
