import Foundation
import XCTest
@testable import NativeMarkKit

final class ImagesTest: XCTestCase {
    func testCase568() throws {
        // HTML: <p><img src=\"/url\" alt=\"foo\" title=\"title\" /></p>\n
        // Debug: <p><img src=\"/url\" alt=\"foo\" title=\"title\" /></p>\n
        XCTAssertEqual(try compile("![foo](/url \"title\")\n"),
                       Document(elements: [.paragraph([.image(Link(title: "title", url: "/url"), alt: "foo")])]))
    }

    func testCase569() throws {
        // HTML: <p><img src=\"train.jpg\" alt=\"foo bar\" title=\"train &amp; tracks\" /></p>\n
        // Debug: <p><img src=\"train.jpg\" alt=\"foo bar\" title=\"train &amp; tracks\" /></p>\n
        XCTAssertEqual(try compile("![foo *bar*]\n\n[foo *bar*]: train.jpg \"train & tracks\"\n"),
                       Document(elements: [.paragraph([.image(Link(title: "train & tracks", url: "train.jpg"), alt: "foo bar")])]))
    }

    func testCase570() throws {
        // HTML: <p><img src=\"/url2\" alt=\"foo bar\" /></p>\n
        // Debug: <p><img src=\"/url2\" alt=\"foo bar\" /></p>\n
        XCTAssertEqual(try compile("![foo ![bar](/url)](/url2)\n"),
                       Document(elements: [.paragraph([.image(Link(title: "", url: "/url2"), alt: "foo bar")])]))
    }

    func testCase571() throws {
        // HTML: <p><img src=\"/url2\" alt=\"foo bar\" /></p>\n
        // Debug: <p><img src=\"/url2\" alt=\"foo bar\" /></p>\n
        XCTAssertEqual(try compile("![foo [bar](/url)](/url2)\n"),
                       Document(elements: [.paragraph([.image(Link(title: "", url: "/url2"), alt: "foo bar")])]))
    }

    func testCase572() throws {
        // HTML: <p><img src=\"train.jpg\" alt=\"foo bar\" title=\"train &amp; tracks\" /></p>\n
        // Debug: <p><img src=\"train.jpg\" alt=\"foo bar\" title=\"train &amp; tracks\" /></p>\n
        XCTAssertEqual(try compile("![foo *bar*][]\n\n[foo *bar*]: train.jpg \"train & tracks\"\n"),
                       Document(elements: [.paragraph([.image(Link(title: "train & tracks", url: "train.jpg"), alt: "foo bar")])]))
    }

    func testCase573() throws {
        // HTML: <p><img src=\"train.jpg\" alt=\"foo bar\" title=\"train &amp; tracks\" /></p>\n
        // Debug: <p><img src=\"train.jpg\" alt=\"foo bar\" title=\"train &amp; tracks\" /></p>\n
        XCTAssertEqual(try compile("![foo *bar*][foobar]\n\n[FOOBAR]: train.jpg \"train & tracks\"\n"),
                       Document(elements: [.paragraph([.image(Link(title: "train & tracks", url: "train.jpg"), alt: "foo bar")])]))
    }

    func testCase574() throws {
        // HTML: <p><img src=\"train.jpg\" alt=\"foo\" /></p>\n
        // Debug: <p><img src=\"train.jpg\" alt=\"foo\" /></p>\n
        XCTAssertEqual(try compile("![foo](train.jpg)\n"),
                       Document(elements: [.paragraph([.image(Link(title: "", url: "train.jpg"), alt: "foo")])]))
    }

    func testCase575() throws {
        // HTML: <p>My <img src=\"/path/to/train.jpg\" alt=\"foo bar\" title=\"title\" /></p>\n
        // Debug: <p>My <img src=\"/path/to/train.jpg\" alt=\"foo bar\" title=\"title\" /></p>\n
        XCTAssertEqual(try compile("My ![foo bar](/path/to/train.jpg  \"title\"   )\n"),
                       Document(elements: [.paragraph([.text("My "), .image(Link(title: "title", url: "/path/to/train.jpg"), alt: "foo bar")])]))
    }

    func testCase576() throws {
        // HTML: <p><img src=\"url\" alt=\"foo\" /></p>\n
        // Debug: <p><img src=\"url\" alt=\"foo\" /></p>\n
        XCTAssertEqual(try compile("![foo](<url>)\n"),
                       Document(elements: [.paragraph([.image(Link(title: "", url: "url"), alt: "foo")])]))
    }

    func testCase577() throws {
        // HTML: <p><img src=\"/url\" alt=\"\" /></p>\n
        // Debug: <p><img src=\"/url\" alt=\"\" /></p>\n
        XCTAssertEqual(try compile("![](/url)\n"),
                       Document(elements: [.paragraph([.image(Link(title: "", url: "/url"), alt: "")])]))
    }

    func testCase578() throws {
        // HTML: <p><img src=\"/url\" alt=\"foo\" /></p>\n
        // Debug: <p><img src=\"/url\" alt=\"foo\" /></p>\n
        XCTAssertEqual(try compile("![foo][bar]\n\n[bar]: /url\n"),
                       Document(elements: [.paragraph([.image(Link(title: "", url: "/url"), alt: "foo")])]))
    }

    func testCase579() throws {
        // HTML: <p><img src=\"/url\" alt=\"foo\" /></p>\n
        // Debug: <p><img src=\"/url\" alt=\"foo\" /></p>\n
        XCTAssertEqual(try compile("![foo][bar]\n\n[BAR]: /url\n"),
                       Document(elements: [.paragraph([.image(Link(title: "", url: "/url"), alt: "foo")])]))
    }

    func testCase580() throws {
        // HTML: <p><img src=\"/url\" alt=\"foo\" title=\"title\" /></p>\n
        // Debug: <p><img src=\"/url\" alt=\"foo\" title=\"title\" /></p>\n
        XCTAssertEqual(try compile("![foo][]\n\n[foo]: /url \"title\"\n"),
                       Document(elements: [.paragraph([.image(Link(title: "title", url: "/url"), alt: "foo")])]))
    }

    func testCase581() throws {
        // HTML: <p><img src=\"/url\" alt=\"foo bar\" title=\"title\" /></p>\n
        // Debug: <p><img src=\"/url\" alt=\"foo bar\" title=\"title\" /></p>\n
        XCTAssertEqual(try compile("![*foo* bar][]\n\n[*foo* bar]: /url \"title\"\n"),
                       Document(elements: [.paragraph([.image(Link(title: "title", url: "/url"), alt: "foo bar")])]))
    }

    func testCase582() throws {
        // HTML: <p><img src=\"/url\" alt=\"Foo\" title=\"title\" /></p>\n
        // Debug: <p><img src=\"/url\" alt=\"Foo\" title=\"title\" /></p>\n
        XCTAssertEqual(try compile("![Foo][]\n\n[foo]: /url \"title\"\n"),
                       Document(elements: [.paragraph([.image(Link(title: "title", url: "/url"), alt: "Foo")])]))
    }

    func testCase583() throws {
        // HTML: <p><img src=\"/url\" alt=\"foo\" title=\"title\" />\n[]</p>\n
        // Debug: <p><img src=\"/url\" alt=\"foo\" title=\"title\" />\n[]</p>\n
        XCTAssertEqual(try compile("![foo] \n[]\n\n[foo]: /url \"title\"\n"),
                       Document(elements: [.paragraph([.image(Link(title: "title", url: "/url"), alt: "foo"), .softbreak, .text("[]")])]))
    }

    func testCase584() throws {
        // HTML: <p><img src=\"/url\" alt=\"foo\" title=\"title\" /></p>\n
        // Debug: <p><img src=\"/url\" alt=\"foo\" title=\"title\" /></p>\n
        XCTAssertEqual(try compile("![foo]\n\n[foo]: /url \"title\"\n"),
                       Document(elements: [.paragraph([.image(Link(title: "title", url: "/url"), alt: "foo")])]))
    }

    func testCase585() throws {
        // HTML: <p><img src=\"/url\" alt=\"foo bar\" title=\"title\" /></p>\n
        // Debug: <p><img src=\"/url\" alt=\"foo bar\" title=\"title\" /></p>\n
        XCTAssertEqual(try compile("![*foo* bar]\n\n[*foo* bar]: /url \"title\"\n"),
                       Document(elements: [.paragraph([.image(Link(title: "title", url: "/url"), alt: "foo bar")])]))
    }

    func testCase586() throws {
        // HTML: <p>![[foo]]</p>\n<p>[[foo]]: /url &quot;title&quot;</p>\n
        // Debug: <p>![[foo]]</p>\n<p>[[foo]]: /url &quot;title&quot;</p>\n
        XCTAssertEqual(try compile("![[foo]]\n\n[[foo]]: /url \"title\"\n"),
                       Document(elements: [.paragraph([.text("![[foo]]")]), .paragraph([.text("[[foo]]: /url “title”")])]))
    }

    func testCase587() throws {
        // HTML: <p><img src=\"/url\" alt=\"Foo\" title=\"title\" /></p>\n
        // Debug: <p><img src=\"/url\" alt=\"Foo\" title=\"title\" /></p>\n
        XCTAssertEqual(try compile("![Foo]\n\n[foo]: /url \"title\"\n"),
                       Document(elements: [.paragraph([.image(Link(title: "title", url: "/url"), alt: "Foo")])]))
    }

    func testCase588() throws {
        // HTML: <p>![foo]</p>\n
        // Debug: <p>![foo]</p>\n
        XCTAssertEqual(try compile("!\\[foo]\n\n[foo]: /url \"title\"\n"),
                       Document(elements: [.paragraph([.text("![foo]")])]))
    }

    func testCase589() throws {
        // HTML: <p>!<a href=\"/url\" title=\"title\">foo</a></p>\n
        // Debug: <p>!<a href=\"/url\" title=\"title\">foo</a></p>\n
        XCTAssertEqual(try compile("\\![foo]\n\n[foo]: /url \"title\"\n"),
                       Document(elements: [.paragraph([.text("!"), .link(Link(title: "title", url: "/url"), text: [.text("foo")])])]))
    }

    
}
