import Foundation
import XCTest
@testable import NativeMarkKit

final class LinksTest: XCTestCase {
    func testCase481() throws {
        // HTML: <p><a href=\"/uri\" title=\"title\">link</a></p>\n
        // Debug: <p><a href=\"/uri\" title=\"title\">link</a></p>\n
        XCTAssertEqual(try compile("[link](/uri \"title\")\n"),
                       Document(elements: [.paragraph([.link(Link(title: "title", url: "/uri"), text: [.text("link")])])]))
    }

    func testCase482() throws {
        // HTML: <p><a href=\"/uri\">link</a></p>\n
        // Debug: <p><a href=\"/uri\">link</a></p>\n
        XCTAssertEqual(try compile("[link](/uri)\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "/uri"), text: [.text("link")])])]))
    }

    func testCase483() throws {
        // HTML: <p><a href=\"\">link</a></p>\n
        // Debug: <p><a href=\"\">link</a></p>\n
        XCTAssertEqual(try compile("[link]()\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: ""), text: [.text("link")])])]))
    }

    func testCase484() throws {
        // HTML: <p><a href=\"\">link</a></p>\n
        // Debug: <p><a href=\"\">link</a></p>\n
        XCTAssertEqual(try compile("[link](<>)\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: ""), text: [.text("link")])])]))
    }

    func testCase485() throws {
        // HTML: <p>[link](/my uri)</p>\n
        // Debug: <p>[link](/my uri)</p>\n
        XCTAssertEqual(try compile("[link](/my uri)\n"),
                       Document(elements: [.paragraph([.text("[link](/my uri)")])]))
    }

    func testCase486() throws {
        // HTML: <p><a href=\"/my%20uri\">link</a></p>\n
        // Debug: <p><a href=\"/my%20uri\">link</a></p>\n
        XCTAssertEqual(try compile("[link](</my uri>)\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "/my uri"), text: [.text("link")])])]))
    }

    func testCase487() throws {
        // HTML: <p>[link](foo\nbar)</p>\n
        // Debug: <p>[link](foo\nbar)</p>\n
        XCTAssertEqual(try compile("[link](foo\nbar)\n"),
                       Document(elements: [.paragraph([.text("[link](foo"), .softbreak, .text("bar)")])]))
    }

    func testCase488() throws {
        // HTML: <p>[link](<foo\nbar>)</p>\n
        // Debug: <p>[link](<foo\nbar>)</p>\n
        XCTAssertEqual(try compile("[link](<foo\nbar>)\n"),
                       Document(elements: [.paragraph([.text("[link](<foo"), .softbreak, .text("bar>)")])]))
    }

    func testCase489() throws {
        // HTML: <p><a href=\"b)c\">a</a></p>\n
        // Debug: <p><a href=\"b)c\">a</a></p>\n
        XCTAssertEqual(try compile("[a](<b)c>)\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "b)c"), text: [.text("a")])])]))
    }

    func testCase490() throws {
        // HTML: <p>[link](&lt;foo&gt;)</p>\n
        // Debug: <p>[link](&lt;foo&gt;)</p>\n
        XCTAssertEqual(try compile("[link](<foo\\>)\n"),
                       Document(elements: [.paragraph([.text("[link](<foo>)")])]))
    }

    func testCase491() throws {
        // HTML: <p>[a](&lt;b)c\n[a](&lt;b)c&gt;\n[a](<b>c)</p>\n
        // Debug: <p>[a](&lt;b)c\n[a](&lt;b)c&gt;\n[a](<b>c)</p>\n
        XCTAssertEqual(try compile("[a](<b)c\n[a](<b)c>\n[a](<b>c)\n"),
                       Document(elements: [.paragraph([.text("[a](<b)c"), .softbreak, .text("[a](<b)c>"), .softbreak, .text("[a](<b>c)")])]))
    }

    func testCase492() throws {
        // HTML: <p><a href=\"(foo)\">link</a></p>\n
        // Debug: <p><a href=\"(foo)\">link</a></p>\n
        XCTAssertEqual(try compile("[link](\\(foo\\))\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "(foo)"), text: [.text("link")])])]))
    }

    func testCase493() throws {
        // HTML: <p><a href=\"foo(and(bar))\">link</a></p>\n
        // Debug: <p><a href=\"foo(and(bar))\">link</a></p>\n
        XCTAssertEqual(try compile("[link](foo(and(bar)))\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "foo(and(bar))"), text: [.text("link")])])]))
    }

    func testCase494() throws {
        // HTML: <p><a href=\"foo(and(bar)\">link</a></p>\n
        // Debug: <p><a href=\"foo(and(bar)\">link</a></p>\n
        XCTAssertEqual(try compile("[link](foo\\(and\\(bar\\))\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "foo(and(bar)"), text: [.text("link")])])]))
    }

    func testCase495() throws {
        // HTML: <p><a href=\"foo(and(bar)\">link</a></p>\n
        // Debug: <p><a href=\"foo(and(bar)\">link</a></p>\n
        XCTAssertEqual(try compile("[link](<foo(and(bar)>)\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "foo(and(bar)"), text: [.text("link")])])]))
    }

    func testCase496() throws {
        // HTML: <p><a href=\"foo):\">link</a></p>\n
        // Debug: <p><a href=\"foo):\">link</a></p>\n
        XCTAssertEqual(try compile("[link](foo\\)\\:)\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "foo):"), text: [.text("link")])])]))
    }

    func testCase497() throws {
        // HTML: <p><a href=\"#fragment\">link</a></p>\n<p><a href=\"http://example.com#fragment\">link</a></p>\n<p><a href=\"http://example.com?foo=3#frag\">link</a></p>\n
        // Debug: <p><a href=\"#fragment\">link</a></p>\n<p><a href=\"http://example.com#fragment\">link</a></p>\n<p><a href=\"http://example.com?foo=3#frag\">link</a></p>\n
        XCTAssertEqual(try compile("[link](#fragment)\n\n[link](http://example.com#fragment)\n\n[link](http://example.com?foo=3#frag)\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "#fragment"), text: [.text("link")])]), .paragraph([.link(Link(title: "", url: "http://example.com#fragment"), text: [.text("link")])]), .paragraph([.link(Link(title: "", url: "http://example.com?foo=3#frag"), text: [.text("link")])])]))
    }

    func testCase498() throws {
        // HTML: <p><a href=\"foo%5Cbar\">link</a></p>\n
        // Debug: <p><a href=\"foo%5Cbar\">link</a></p>\n
        XCTAssertEqual(try compile("[link](foo\\bar)\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "foo\\bar"), text: [.text("link")])])]))
    }

    func testCase499() throws {
        // HTML: <p><a href=\"foo%20b%C3%A4\">link</a></p>\n
        // Debug: <p><a href=\"foo%20b%C3%A4\">link</a></p>\n
        XCTAssertEqual(try compile("[link](foo%20b&auml;)\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "foo%20bä"), text: [.text("link")])])]))
    }

    func testCase500() throws {
        // HTML: <p><a href=\"%22title%22\">link</a></p>\n
        // Debug: <p><a href=\"%22title%22\">link</a></p>\n
        XCTAssertEqual(try compile("[link](\"title\")\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "\"title\""), text: [.text("link")])])]))
    }

    func testCase501() throws {
        // HTML: <p><a href=\"/url\" title=\"title\">link</a>\n<a href=\"/url\" title=\"title\">link</a>\n<a href=\"/url\" title=\"title\">link</a></p>\n
        // Debug: <p><a href=\"/url\" title=\"title\">link</a>\n<a href=\"/url\" title=\"title\">link</a>\n<a href=\"/url\" title=\"title\">link</a></p>\n
        XCTAssertEqual(try compile("[link](/url \"title\")\n[link](/url 'title')\n[link](/url (title))\n"),
                       Document(elements: [.paragraph([.link(Link(title: "title", url: "/url"), text: [.text("link")]), .softbreak, .link(Link(title: "title", url: "/url"), text: [.text("link")]), .softbreak, .link(Link(title: "title", url: "/url"), text: [.text("link")])])]))
    }

    func testCase502() throws {
        // HTML: <p><a href=\"/url\" title=\"title &quot;&quot;\">link</a></p>\n
        // Debug: <p><a href=\"/url\" title=\"title &quot;&quot;\">link</a></p>\n
        XCTAssertEqual(try compile("[link](/url \"title \\\"&quot;\")\n"),
                       Document(elements: [.paragraph([.link(Link(title: "title \"\"", url: "/url"), text: [.text("link")])])]))
    }

    func testCase503() throws {
        // HTML: <p><a href=\"/url%C2%A0%22title%22\">link</a></p>\n
        // Debug: <p><a href=\"/url%C2%A0%22title%22\">link</a></p>\n
        XCTAssertEqual(try compile("[link](/url \"title\")\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "/url \"title\""), text: [.text("link")])])]))
    }

    func testCase504() throws {
        // HTML: <p>[link](/url &quot;title &quot;and&quot; title&quot;)</p>\n
        // Debug: <p>[link](/url &quot;title &quot;and&quot; title&quot;)</p>\n
        XCTAssertEqual(try compile("[link](/url \"title \"and\" title\")\n"),
                       Document(elements: [.paragraph([.text("[link](/url “title “and” title”)")])]))
    }

    func testCase505() throws {
        // HTML: <p><a href=\"/url\" title=\"title &quot;and&quot; title\">link</a></p>\n
        // Debug: <p><a href=\"/url\" title=\"title &quot;and&quot; title\">link</a></p>\n
        XCTAssertEqual(try compile("[link](/url 'title \"and\" title')\n"),
                       Document(elements: [.paragraph([.link(Link(title: "title \"and\" title", url: "/url"), text: [.text("link")])])]))
    }

    func testCase506() throws {
        // HTML: <p><a href=\"/uri\" title=\"title\">link</a></p>\n
        // Debug: <p><a href=\"/uri\" title=\"title\">link</a></p>\n
        XCTAssertEqual(try compile("[link](   /uri\n  \"title\"  )\n"),
                       Document(elements: [.paragraph([.link(Link(title: "title", url: "/uri"), text: [.text("link")])])]))
    }

    func testCase507() throws {
        // HTML: <p>[link] (/uri)</p>\n
        // Debug: <p>[link] (/uri)</p>\n
        XCTAssertEqual(try compile("[link] (/uri)\n"),
                       Document(elements: [.paragraph([.text("[link] (/uri)")])]))
    }

    func testCase508() throws {
        // HTML: <p><a href=\"/uri\">link [foo [bar]]</a></p>\n
        // Debug: <p><a href=\"/uri\">link [foo [bar]]</a></p>\n
        XCTAssertEqual(try compile("[link [foo [bar]]](/uri)\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "/uri"), text: [.text("link [foo [bar]]")])])]))
    }

    func testCase509() throws {
        // HTML: <p>[link] bar](/uri)</p>\n
        // Debug: <p>[link] bar](/uri)</p>\n
        XCTAssertEqual(try compile("[link] bar](/uri)\n"),
                       Document(elements: [.paragraph([.text("[link] bar](/uri)")])]))
    }

    func testCase510() throws {
        // HTML: <p>[link <a href=\"/uri\">bar</a></p>\n
        // Debug: <p>[link <a href=\"/uri\">bar</a></p>\n
        XCTAssertEqual(try compile("[link [bar](/uri)\n"),
                       Document(elements: [.paragraph([.text("[link "), .link(Link(title: "", url: "/uri"), text: [.text("bar")])])]))
    }

    func testCase511() throws {
        // HTML: <p><a href=\"/uri\">link [bar</a></p>\n
        // Debug: <p><a href=\"/uri\">link [bar</a></p>\n
        XCTAssertEqual(try compile("[link \\[bar](/uri)\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "/uri"), text: [.text("link [bar")])])]))
    }

    func testCase512() throws {
        // HTML: <p><a href=\"/uri\">link <em>foo <strong>bar</strong> <code>#</code></em></a></p>\n
        // Debug: <p><a href=\"/uri\">link <em>foo <strong>bar</strong> <code>#</code></em></a></p>\n
        XCTAssertEqual(try compile("[link *foo **bar** `#`*](/uri)\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "/uri"), text: [.text("link "), .emphasis([.text("foo "), .strong([.text("bar")]), .text(" "), .code("#")])])])]))
    }

    func testCase513() throws {
        // HTML: <p><a href=\"/uri\"><img src=\"moon.jpg\" alt=\"moon\" /></a></p>\n
        // Debug: <p><a href=\"/uri\"><img src=\"moon.jpg\" alt=\"moon\" /></a></p>\n
        XCTAssertEqual(try compile("[![moon](moon.jpg)](/uri)\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "/uri"), text: [.image(Link(title: "", url: "moon.jpg"), alt: "moon")])])]))
    }

    func testCase514() throws {
        // HTML: <p>[foo <a href=\"/uri\">bar</a>](/uri)</p>\n
        // Debug: <p>[foo <a href=\"/uri\">bar</a>](/uri)</p>\n
        XCTAssertEqual(try compile("[foo [bar](/uri)](/uri)\n"),
                       Document(elements: [.paragraph([.text("[foo "), .link(Link(title: "", url: "/uri"), text: [.text("bar")]), .text("](/uri)")])]))
    }

    func testCase515() throws {
        // HTML: <p>[foo <em>[bar <a href=\"/uri\">baz</a>](/uri)</em>](/uri)</p>\n
        // Debug: <p>[foo <em>[bar <a href=\"/uri\">baz</a>](/uri)</em>](/uri)</p>\n
        XCTAssertEqual(try compile("[foo *[bar [baz](/uri)](/uri)*](/uri)\n"),
                       Document(elements: [.paragraph([.text("[foo "), .emphasis([.text("[bar "), .link(Link(title: "", url: "/uri"), text: [.text("baz")]), .text("](/uri)")]), .text("](/uri)")])]))
    }

    func testCase516() throws {
        // HTML: <p><img src=\"uri3\" alt=\"[foo](uri2)\" /></p>\n
        // Debug: <p><img src=\"uri3\" alt=\"[foo](uri2)\" /></p>\n
        XCTAssertEqual(try compile("![[[foo](uri1)](uri2)](uri3)\n"),
                       Document(elements: [.paragraph([.image(Link(title: "", url: "uri3"), alt: "[foo](uri2)")])]))
    }

    func testCase517() throws {
        // HTML: <p>*<a href=\"/uri\">foo*</a></p>\n
        // Debug: <p>*<a href=\"/uri\">foo*</a></p>\n
        XCTAssertEqual(try compile("*[foo*](/uri)\n"),
                       Document(elements: [.paragraph([.text("*"), .link(Link(title: "", url: "/uri"), text: [.text("foo*")])])]))
    }

    func testCase518() throws {
        // HTML: <p><a href=\"baz*\">foo *bar</a></p>\n
        // Debug: <p><a href=\"baz*\">foo *bar</a></p>\n
        XCTAssertEqual(try compile("[foo *bar](baz*)\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "baz*"), text: [.text("foo *bar")])])]))
    }

    func testCase519() throws {
        // HTML: <p><em>foo [bar</em> baz]</p>\n
        // Debug: <p><em>foo [bar</em> baz]</p>\n
        XCTAssertEqual(try compile("*foo [bar* baz]\n"),
                       Document(elements: [.paragraph([.emphasis([.text("foo [bar")]), .text(" baz]")])]))
    }

    func testCase520() throws {
        // HTML: <p>[foo <bar attr=\"](baz)\"></p>\n
        // Debug: <p>[foo <bar attr=\"](baz)\"></p>\n
        XCTAssertEqual(try compile("[foo <bar attr=\"](baz)\">\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "baz"), text: [.text("foo <bar attr=”")]), .text("\">")])]))
    }

    func testCase521() throws {
        // HTML: <p>[foo<code>](/uri)</code></p>\n
        // Debug: <p>[foo<code>](/uri)</code></p>\n
        XCTAssertEqual(try compile("[foo`](/uri)`\n"),
                       Document(elements: [.paragraph([.text("[foo"), .code("](/uri)")])]))
    }

    func testCase522() throws {
        // HTML: <p>[foo<a href=\"http://example.com/?search=%5D(uri)\">http://example.com/?search=](uri)</a></p>\n
        // Debug: <p>[foo<a href=\"http://example.com/?search=%5D(uri)\">http://example.com/?search=](uri)</a></p>\n
        XCTAssertEqual(try compile("[foo<http://example.com/?search=](uri)>\n"),
                       Document(elements: [.paragraph([.text("[foo"), .link(Link(title: "", url: "http://example.com/?search=](uri)"), text: [.text("http://example.com/?search=](uri)")])])]))
    }

    func testCase523() throws {
        // HTML: <p><a href=\"/url\" title=\"title\">foo</a></p>\n
        // Debug: <p><a href=\"/url\" title=\"title\">foo</a></p>\n
        XCTAssertEqual(try compile("[foo][bar]\n\n[bar]: /url \"title\"\n"),
                       Document(elements: [.paragraph([.link(Link(title: "title", url: "/url"), text: [.text("foo")])])]))
    }

    func testCase524() throws {
        // HTML: <p><a href=\"/uri\">link [foo [bar]]</a></p>\n
        // Debug: <p><a href=\"/uri\">link [foo [bar]]</a></p>\n
        XCTAssertEqual(try compile("[link [foo [bar]]][ref]\n\n[ref]: /uri\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "/uri"), text: [.text("link [foo [bar]]")])])]))
    }

    func testCase525() throws {
        // HTML: <p><a href=\"/uri\">link [bar</a></p>\n
        // Debug: <p><a href=\"/uri\">link [bar</a></p>\n
        XCTAssertEqual(try compile("[link \\[bar][ref]\n\n[ref]: /uri\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "/uri"), text: [.text("link [bar")])])]))
    }

    func testCase526() throws {
        // HTML: <p><a href=\"/uri\">link <em>foo <strong>bar</strong> <code>#</code></em></a></p>\n
        // Debug: <p><a href=\"/uri\">link <em>foo <strong>bar</strong> <code>#</code></em></a></p>\n
        XCTAssertEqual(try compile("[link *foo **bar** `#`*][ref]\n\n[ref]: /uri\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "/uri"), text: [.text("link "), .emphasis([.text("foo "), .strong([.text("bar")]), .text(" "), .code("#")])])])]))
    }

    func testCase527() throws {
        // HTML: <p><a href=\"/uri\"><img src=\"moon.jpg\" alt=\"moon\" /></a></p>\n
        // Debug: <p><a href=\"/uri\"><img src=\"moon.jpg\" alt=\"moon\" /></a></p>\n
        XCTAssertEqual(try compile("[![moon](moon.jpg)][ref]\n\n[ref]: /uri\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "/uri"), text: [.image(Link(title: "", url: "moon.jpg"), alt: "moon")])])]))
    }

    func testCase528() throws {
        // HTML: <p>[foo <a href=\"/uri\">bar</a>]<a href=\"/uri\">ref</a></p>\n
        // Debug: <p>[foo <a href=\"/uri\">bar</a>]<a href=\"/uri\">ref</a></p>\n
        XCTAssertEqual(try compile("[foo [bar](/uri)][ref]\n\n[ref]: /uri\n"),
                       Document(elements: [.paragraph([.text("[foo "), .link(Link(title: "", url: "/uri"), text: [.text("bar")]), .text("]"), .link(Link(title: "", url: "/uri"), text: [.text("ref")])])]))
    }

    func testCase529() throws {
        // HTML: <p>[foo <em>bar <a href=\"/uri\">baz</a></em>]<a href=\"/uri\">ref</a></p>\n
        // Debug: <p>[foo <em>bar <a href=\"/uri\">baz</a></em>]<a href=\"/uri\">ref</a></p>\n
        XCTAssertEqual(try compile("[foo *bar [baz][ref]*][ref]\n\n[ref]: /uri\n"),
                       Document(elements: [.paragraph([.text("[foo "), .emphasis([.text("bar "), .link(Link(title: "", url: "/uri"), text: [.text("baz")])]), .text("]"), .link(Link(title: "", url: "/uri"), text: [.text("ref")])])]))
    }

    func testCase530() throws {
        // HTML: <p>*<a href=\"/uri\">foo*</a></p>\n
        // Debug: <p>*<a href=\"/uri\">foo*</a></p>\n
        XCTAssertEqual(try compile("*[foo*][ref]\n\n[ref]: /uri\n"),
                       Document(elements: [.paragraph([.text("*"), .link(Link(title: "", url: "/uri"), text: [.text("foo*")])])]))
    }

    func testCase531() throws {
        // HTML: <p><a href=\"/uri\">foo *bar</a></p>\n
        // Debug: <p><a href=\"/uri\">foo *bar</a></p>\n
        XCTAssertEqual(try compile("[foo *bar][ref]\n\n[ref]: /uri\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "/uri"), text: [.text("foo *bar")])])]))
    }

    func testCase532() throws {
        // HTML: <p>[foo <bar attr=\"][ref]\"></p>\n
        // Debug: <p>[foo <bar attr=\"][ref]\"></p>\n
        XCTAssertEqual(try compile("[foo <bar attr=\"][ref]\">\n\n[ref]: /uri\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "/uri"), text: [.text("foo <bar attr=”")]), .text("\">")])]))
    }

    func testCase533() throws {
        // HTML: <p>[foo<code>][ref]</code></p>\n
        // Debug: <p>[foo<code>][ref]</code></p>\n
        XCTAssertEqual(try compile("[foo`][ref]`\n\n[ref]: /uri\n"),
                       Document(elements: [.paragraph([.text("[foo"), .code("][ref]")])]))
    }

    func testCase534() throws {
        // HTML: <p>[foo<a href=\"http://example.com/?search=%5D%5Bref%5D\">http://example.com/?search=][ref]</a></p>\n
        // Debug: <p>[foo<a href=\"http://example.com/?search=%5D%5Bref%5D\">http://example.com/?search=][ref]</a></p>\n
        XCTAssertEqual(try compile("[foo<http://example.com/?search=][ref]>\n\n[ref]: /uri\n"),
                       Document(elements: [.paragraph([.text("[foo"), .link(Link(title: "", url: "http://example.com/?search=][ref]"), text: [.text("http://example.com/?search=][ref]")])])]))
    }

    func testCase535() throws {
        // HTML: <p><a href=\"/url\" title=\"title\">foo</a></p>\n
        // Debug: <p><a href=\"/url\" title=\"title\">foo</a></p>\n
        XCTAssertEqual(try compile("[foo][BaR]\n\n[bar]: /url \"title\"\n"),
                       Document(elements: [.paragraph([.link(Link(title: "title", url: "/url"), text: [.text("foo")])])]))
    }

    func testCase536() throws {
        // HTML: <p><a href=\"/url\">Толпой</a> is a Russian word.</p>\n
        // Debug: <p><a href=\"/url\">Толпой</a> is a Russian word.</p>\n
        XCTAssertEqual(try compile("[Толпой][Толпой] is a Russian word.\n\n[ТОЛПОЙ]: /url\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "/url"), text: [.text("Толпой")]), .text(" is a Russian word.")])]))
    }

    func testCase537() throws {
        // HTML: <p><a href=\"/url\">Baz</a></p>\n
        // Debug: <p><a href=\"/url\">Baz</a></p>\n
        XCTAssertEqual(try compile("[Foo\n  bar]: /url\n\n[Baz][Foo bar]\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "/url"), text: [.text("Baz")])])]))
    }

    func testCase538() throws {
        // HTML: <p>[foo] <a href=\"/url\" title=\"title\">bar</a></p>\n
        // Debug: <p>[foo] <a href=\"/url\" title=\"title\">bar</a></p>\n
        XCTAssertEqual(try compile("[foo] [bar]\n\n[bar]: /url \"title\"\n"),
                       Document(elements: [.paragraph([.text("[foo] "), .link(Link(title: "title", url: "/url"), text: [.text("bar")])])]))
    }

    func testCase539() throws {
        // HTML: <p>[foo]\n<a href=\"/url\" title=\"title\">bar</a></p>\n
        // Debug: <p>[foo]\n<a href=\"/url\" title=\"title\">bar</a></p>\n
        XCTAssertEqual(try compile("[foo]\n[bar]\n\n[bar]: /url \"title\"\n"),
                       Document(elements: [.paragraph([.text("[foo]"), .softbreak, .link(Link(title: "title", url: "/url"), text: [.text("bar")])])]))
    }

    func testCase540() throws {
        // HTML: <p><a href=\"/url1\">bar</a></p>\n
        // Debug: <p><a href=\"/url1\">bar</a></p>\n
        XCTAssertEqual(try compile("[foo]: /url1\n\n[foo]: /url2\n\n[bar][foo]\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "/url1"), text: [.text("bar")])])]))
    }

    func testCase541() throws {
        // HTML: <p>[bar][foo!]</p>\n
        // Debug: <p>[bar][foo!]</p>\n
        XCTAssertEqual(try compile("[bar][foo\\!]\n\n[foo!]: /url\n"),
                       Document(elements: [.paragraph([.text("[bar][foo!]")])]))
    }

    func testCase542() throws {
        // HTML: <p>[foo][ref[]</p>\n<p>[ref[]: /uri</p>\n
        // Debug: <p>[foo][ref[]</p>\n<p>[ref[]: /uri</p>\n
        XCTAssertEqual(try compile("[foo][ref[]\n\n[ref[]: /uri\n"),
                       Document(elements: [.paragraph([.text("[foo][ref[]")]), .paragraph([.text("[ref[]: /uri")])]))
    }

    func testCase543() throws {
        // HTML: <p>[foo][ref[bar]]</p>\n<p>[ref[bar]]: /uri</p>\n
        // Debug: <p>[foo][ref[bar]]</p>\n<p>[ref[bar]]: /uri</p>\n
        XCTAssertEqual(try compile("[foo][ref[bar]]\n\n[ref[bar]]: /uri\n"),
                       Document(elements: [.paragraph([.text("[foo][ref[bar]]")]), .paragraph([.text("[ref[bar]]: /uri")])]))
    }

    func testCase544() throws {
        // HTML: <p>[[[foo]]]</p>\n<p>[[[foo]]]: /url</p>\n
        // Debug: <p>[[[foo]]]</p>\n<p>[[[foo]]]: /url</p>\n
        XCTAssertEqual(try compile("[[[foo]]]\n\n[[[foo]]]: /url\n"),
                       Document(elements: [.paragraph([.text("[[[foo]]]")]), .paragraph([.text("[[[foo]]]: /url")])]))
    }

    func testCase545() throws {
        // HTML: <p><a href=\"/uri\">foo</a></p>\n
        // Debug: <p><a href=\"/uri\">foo</a></p>\n
        XCTAssertEqual(try compile("[foo][ref\\[]\n\n[ref\\[]: /uri\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "/uri"), text: [.text("foo")])])]))
    }

    func testCase546() throws {
        // HTML: <p><a href=\"/uri\">bar\\</a></p>\n
        // Debug: <p><a href=\"/uri\">bar\\</a></p>\n
        XCTAssertEqual(try compile("[bar\\\\]: /uri\n\n[bar\\\\]\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "/uri"), text: [.text("bar\\")])])]))
    }

    func testCase547() throws {
        // HTML: <p>[]</p>\n<p>[]: /uri</p>\n
        // Debug: <p>[]</p>\n<p>[]: /uri</p>\n
        XCTAssertEqual(try compile("[]\n\n[]: /uri\n"),
                       Document(elements: [.paragraph([.text("[]")]), .paragraph([.text("[]: /uri")])]))
    }

    func testCase548() throws {
        // HTML: <p>[\n]</p>\n<p>[\n]: /uri</p>\n
        // Debug: <p>[\n]</p>\n<p>[\n]: /uri</p>\n
        XCTAssertEqual(try compile("[\n ]\n\n[\n ]: /uri\n"),
                       Document(elements: [.paragraph([.text("["), .softbreak, .text("]")]), .paragraph([.text("["), .softbreak, .text("]: /uri")])]))
    }

    func testCase549() throws {
        // HTML: <p><a href=\"/url\" title=\"title\">foo</a></p>\n
        // Debug: <p><a href=\"/url\" title=\"title\">foo</a></p>\n
        XCTAssertEqual(try compile("[foo][]\n\n[foo]: /url \"title\"\n"),
                       Document(elements: [.paragraph([.link(Link(title: "title", url: "/url"), text: [.text("foo")])])]))
    }

    func testCase550() throws {
        // HTML: <p><a href=\"/url\" title=\"title\"><em>foo</em> bar</a></p>\n
        // Debug: <p><a href=\"/url\" title=\"title\"><em>foo</em> bar</a></p>\n
        XCTAssertEqual(try compile("[*foo* bar][]\n\n[*foo* bar]: /url \"title\"\n"),
                       Document(elements: [.paragraph([.link(Link(title: "title", url: "/url"), text: [.emphasis([.text("foo")]), .text(" bar")])])]))
    }

    func testCase551() throws {
        // HTML: <p><a href=\"/url\" title=\"title\">Foo</a></p>\n
        // Debug: <p><a href=\"/url\" title=\"title\">Foo</a></p>\n
        XCTAssertEqual(try compile("[Foo][]\n\n[foo]: /url \"title\"\n"),
                       Document(elements: [.paragraph([.link(Link(title: "title", url: "/url"), text: [.text("Foo")])])]))
    }

    func testCase552() throws {
        // HTML: <p><a href=\"/url\" title=\"title\">foo</a>\n[]</p>\n
        // Debug: <p><a href=\"/url\" title=\"title\">foo</a>\n[]</p>\n
        XCTAssertEqual(try compile("[foo] \n[]\n\n[foo]: /url \"title\"\n"),
                       Document(elements: [.paragraph([.link(Link(title: "title", url: "/url"), text: [.text("foo")]), .softbreak, .text("[]")])]))
    }

    func testCase553() throws {
        // HTML: <p><a href=\"/url\" title=\"title\">foo</a></p>\n
        // Debug: <p><a href=\"/url\" title=\"title\">foo</a></p>\n
        XCTAssertEqual(try compile("[foo]\n\n[foo]: /url \"title\"\n"),
                       Document(elements: [.paragraph([.link(Link(title: "title", url: "/url"), text: [.text("foo")])])]))
    }

    func testCase554() throws {
        // HTML: <p><a href=\"/url\" title=\"title\"><em>foo</em> bar</a></p>\n
        // Debug: <p><a href=\"/url\" title=\"title\"><em>foo</em> bar</a></p>\n
        XCTAssertEqual(try compile("[*foo* bar]\n\n[*foo* bar]: /url \"title\"\n"),
                       Document(elements: [.paragraph([.link(Link(title: "title", url: "/url"), text: [.emphasis([.text("foo")]), .text(" bar")])])]))
    }

    func testCase555() throws {
        // HTML: <p>[<a href=\"/url\" title=\"title\"><em>foo</em> bar</a>]</p>\n
        // Debug: <p>[<a href=\"/url\" title=\"title\"><em>foo</em> bar</a>]</p>\n
        XCTAssertEqual(try compile("[[*foo* bar]]\n\n[*foo* bar]: /url \"title\"\n"),
                       Document(elements: [.paragraph([.text("["), .link(Link(title: "title", url: "/url"), text: [.emphasis([.text("foo")]), .text(" bar")]), .text("]")])]))
    }

    func testCase556() throws {
        // HTML: <p>[[bar <a href=\"/url\">foo</a></p>\n
        // Debug: <p>[[bar <a href=\"/url\">foo</a></p>\n
        XCTAssertEqual(try compile("[[bar [foo]\n\n[foo]: /url\n"),
                       Document(elements: [.paragraph([.text("[[bar "), .link(Link(title: "", url: "/url"), text: [.text("foo")])])]))
    }

    func testCase557() throws {
        // HTML: <p><a href=\"/url\" title=\"title\">Foo</a></p>\n
        // Debug: <p><a href=\"/url\" title=\"title\">Foo</a></p>\n
        XCTAssertEqual(try compile("[Foo]\n\n[foo]: /url \"title\"\n"),
                       Document(elements: [.paragraph([.link(Link(title: "title", url: "/url"), text: [.text("Foo")])])]))
    }

    func testCase558() throws {
        // HTML: <p><a href=\"/url\">foo</a> bar</p>\n
        // Debug: <p><a href=\"/url\">foo</a> bar</p>\n
        XCTAssertEqual(try compile("[foo] bar\n\n[foo]: /url\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "/url"), text: [.text("foo")]), .text(" bar")])]))
    }

    func testCase559() throws {
        // HTML: <p>[foo]</p>\n
        // Debug: <p>[foo]</p>\n
        XCTAssertEqual(try compile("\\[foo]\n\n[foo]: /url \"title\"\n"),
                       Document(elements: [.paragraph([.text("[foo]")])]))
    }

    func testCase560() throws {
        // HTML: <p>*<a href=\"/url\">foo*</a></p>\n
        // Debug: <p>*<a href=\"/url\">foo*</a></p>\n
        XCTAssertEqual(try compile("[foo*]: /url\n\n*[foo*]\n"),
                       Document(elements: [.paragraph([.text("*"), .link(Link(title: "", url: "/url"), text: [.text("foo*")])])]))
    }

    func testCase561() throws {
        // HTML: <p><a href=\"/url2\">foo</a></p>\n
        // Debug: <p><a href=\"/url2\">foo</a></p>\n
        XCTAssertEqual(try compile("[foo][bar]\n\n[foo]: /url1\n[bar]: /url2\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "/url2"), text: [.text("foo")])])]))
    }

    func testCase562() throws {
        // HTML: <p><a href=\"/url1\">foo</a></p>\n
        // Debug: <p><a href=\"/url1\">foo</a></p>\n
        XCTAssertEqual(try compile("[foo][]\n\n[foo]: /url1\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "/url1"), text: [.text("foo")])])]))
    }

    func testCase563() throws {
        // HTML: <p><a href=\"\">foo</a></p>\n
        // Debug: <p><a href=\"\">foo</a></p>\n
        XCTAssertEqual(try compile("[foo]()\n\n[foo]: /url1\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: ""), text: [.text("foo")])])]))
    }

    func testCase564() throws {
        // HTML: <p><a href=\"/url1\">foo</a>(not a link)</p>\n
        // Debug: <p><a href=\"/url1\">foo</a>(not a link)</p>\n
        XCTAssertEqual(try compile("[foo](not a link)\n\n[foo]: /url1\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "/url1"), text: [.text("foo")]), .text("(not a link)")])]))
    }

    func testCase565() throws {
        // HTML: <p>[foo]<a href=\"/url\">bar</a></p>\n
        // Debug: <p>[foo]<a href=\"/url\">bar</a></p>\n
        XCTAssertEqual(try compile("[foo][bar][baz]\n\n[baz]: /url\n"),
                       Document(elements: [.paragraph([.text("[foo]"), .link(Link(title: "", url: "/url"), text: [.text("bar")])])]))
    }

    func testCase566() throws {
        // HTML: <p><a href=\"/url2\">foo</a><a href=\"/url1\">baz</a></p>\n
        // Debug: <p><a href=\"/url2\">foo</a><a href=\"/url1\">baz</a></p>\n
        XCTAssertEqual(try compile("[foo][bar][baz]\n\n[baz]: /url1\n[bar]: /url2\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "/url2"), text: [.text("foo")]), .link(Link(title: "", url: "/url1"), text: [.text("baz")])])]))
    }

    func testCase567() throws {
        // HTML: <p>[foo]<a href=\"/url1\">bar</a></p>\n
        // Debug: <p>[foo]<a href=\"/url1\">bar</a></p>\n
        XCTAssertEqual(try compile("[foo][bar][baz]\n\n[baz]: /url1\n[foo]: /url2\n"),
                       Document(elements: [.paragraph([.text("[foo]"), .link(Link(title: "", url: "/url1"), text: [.text("bar")])])]))
    }

    
}
