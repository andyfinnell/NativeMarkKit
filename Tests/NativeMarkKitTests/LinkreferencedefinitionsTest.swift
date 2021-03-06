import Foundation
import XCTest
@testable import NativeMarkKit

final class LinkreferencedefinitionsTest: XCTestCase {
    func testCase161() throws {
        // HTML: <p><a href=\"/url\" title=\"title\">foo</a></p>\n
        // Debug: <p><a href=\"/url\" title=\"title\">foo</a></p>\n
        XCTAssertEqual(try compile("[foo]: /url \"title\"\n\n[foo]\n"),
                       Document(elements: [.paragraph([.link(Link(title: "title", url: "/url"), text: [.text("foo")])])]))
    }

    func testCase162() throws {
        // HTML: <p><a href=\"/url\" title=\"the title\">foo</a></p>\n
        // Debug: <p><a href=\"/url\" title=\"the title\">foo</a></p>\n
        XCTAssertEqual(try compile("   [foo]: \n      /url  \n           'the title'  \n\n[foo]\n"),
                       Document(elements: [.paragraph([.link(Link(title: "the title", url: "/url"), text: [.text("foo")])])]))
    }

    func testCase163() throws {
        // HTML: <p><a href=\"my_(url)\" title=\"title (with parens)\">Foo*bar]</a></p>\n
        // Debug: <p><a href=\"my_(url)\" title=\"title (with parens)\">Foo*bar]</a></p>\n
        XCTAssertEqual(try compile("[Foo*bar\\]]:my_(url) 'title (with parens)'\n\n[Foo*bar\\]]\n"),
                       Document(elements: [.paragraph([.link(Link(title: "title (with parens)", url: "my_(url)"), text: [.text("Foo*bar]")])])]))
    }

    func testCase164() throws {
        // HTML: <p><a href=\"my%20url\" title=\"title\">Foo bar</a></p>\n
        // Debug: <p><a href=\"my%20url\" title=\"title\">Foo bar</a></p>\n
        XCTAssertEqual(try compile("[Foo bar]:\n<my url>\n'title'\n\n[Foo bar]\n"),
                       Document(elements: [.paragraph([.link(Link(title: "title", url: "my url"), text: [.text("Foo bar")])])]))
    }

    func testCase165() throws {
        // HTML: <p><a href=\"/url\" title=\"\ntitle\nline1\nline2\n\">foo</a></p>\n
        // Debug: <p><a href=\"/url\" title=\"\ntitle\nline1\nline2\n\">foo</a></p>\n
        XCTAssertEqual(try compile("[foo]: /url '\ntitle\nline1\nline2\n'\n\n[foo]\n"),
                       Document(elements: [.paragraph([.link(Link(title: "\ntitle\nline1\nline2\n", url: "/url"), text: [.text("foo")])])]))
    }

    func testCase166() throws {
        // HTML: <p>[foo]: /url 'title</p>\n<p>with blank line'</p>\n<p>[foo]</p>\n
        // Debug: <p>[foo]: /url 'title</p>\n<p>with blank line'</p>\n<p>[foo]</p>\n
        XCTAssertEqual(try compile("[foo]: /url 'title\n\nwith blank line'\n\n[foo]\n"),
                       Document(elements: [.paragraph([.text("[foo]: /url 'title")]), .paragraph([.text("with blank line'")]), .paragraph([.text("[foo]")])]))
    }

    func testCase167() throws {
        // HTML: <p><a href=\"/url\">foo</a></p>\n
        // Debug: <p><a href=\"/url\">foo</a></p>\n
        XCTAssertEqual(try compile("[foo]:\n/url\n\n[foo]\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "/url"), text: [.text("foo")])])]))
    }

    func testCase168() throws {
        // HTML: <p>[foo]:</p>\n<p>[foo]</p>\n
        // Debug: <p>[foo]:</p>\n<p>[foo]</p>\n
        XCTAssertEqual(try compile("[foo]:\n\n[foo]\n"),
                       Document(elements: [.paragraph([.text("[foo]:")]), .paragraph([.text("[foo]")])]))
    }

    func testCase169() throws {
        // HTML: <p><a href=\"\">foo</a></p>\n
        // Debug: <p><a href=\"\">foo</a></p>\n
        XCTAssertEqual(try compile("[foo]: <>\n\n[foo]\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: ""), text: [.text("foo")])])]))
    }

    func testCase170() throws {
        // HTML: <p>[foo]: <bar>(baz)</p>\n<p>[foo]</p>\n
        // Debug: <p>[foo]: <bar>(baz)</p>\n<p>[foo]</p>\n
        XCTAssertEqual(try compile("[foo]: <bar>(baz)\n\n[foo]\n"),
                       Document(elements: [.paragraph([.text("[foo]: <bar>(baz)")]), .paragraph([.text("[foo]")])]))
    }

    func testCase171() throws {
        // HTML: <p><a href=\"/url%5Cbar*baz\" title=\"foo&quot;bar\\baz\">foo</a></p>\n
        // Debug: <p><a href=\"/url%5Cbar*baz\" title=\"foo&quot;bar\\baz\">foo</a></p>\n
        XCTAssertEqual(try compile("[foo]: /url\\bar\\*baz \"foo\\\"bar\\baz\"\n\n[foo]\n"),
                       Document(elements: [.paragraph([.link(Link(title: "foo\"bar\\baz", url: "/url\\bar*baz"), text: [.text("foo")])])]))
    }

    func testCase172() throws {
        // HTML: <p><a href=\"url\">foo</a></p>\n
        // Debug: <p><a href=\"url\">foo</a></p>\n
        XCTAssertEqual(try compile("[foo]\n\n[foo]: url\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "url"), text: [.text("foo")])])]))
    }

    func testCase173() throws {
        // HTML: <p><a href=\"first\">foo</a></p>\n
        // Debug: <p><a href=\"first\">foo</a></p>\n
        XCTAssertEqual(try compile("[foo]\n\n[foo]: first\n[foo]: second\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "first"), text: [.text("foo")])])]))
    }

    func testCase174() throws {
        // HTML: <p><a href=\"/url\">Foo</a></p>\n
        // Debug: <p><a href=\"/url\">Foo</a></p>\n
        XCTAssertEqual(try compile("[FOO]: /url\n\n[Foo]\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "/url"), text: [.text("Foo")])])]))
    }

    func testCase175() throws {
        // HTML: <p><a href=\"/%CF%86%CE%BF%CF%85\">αγω</a></p>\n
        // Debug: <p><a href=\"/%CF%86%CE%BF%CF%85\">αγω</a></p>\n
        XCTAssertEqual(try compile("[ΑΓΩ]: /φου\n\n[αγω]\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "/φου"), text: [.text("αγω")])])]))
    }

    func testCase176() throws {
        // HTML: 
        // Debug: 
        XCTAssertEqual(try compile("[foo]: /url\n"),
                       Document(elements: []))
    }

    func testCase177() throws {
        // HTML: <p>bar</p>\n
        // Debug: <p>bar</p>\n
        XCTAssertEqual(try compile("[\nfoo\n]: /url\nbar\n"),
                       Document(elements: [.paragraph([.text("bar")])]))
    }

    func testCase178() throws {
        // HTML: <p>[foo]: /url &quot;title&quot; ok</p>\n
        // Debug: <p>[foo]: /url &quot;title&quot; ok</p>\n
        XCTAssertEqual(try compile("[foo]: /url \"title\" ok\n"),
                       Document(elements: [.paragraph([.text("[foo]: /url “title” ok")])]))
    }

    func testCase179() throws {
        // HTML: <p>&quot;title&quot; ok</p>\n
        // Debug: <p>&quot;title&quot; ok</p>\n
        XCTAssertEqual(try compile("[foo]: /url\n\"title\" ok\n"),
                       Document(elements: [.paragraph([.text("“title” ok")])]))
    }

    func testCase180() throws {
        // HTML: <pre><code>[foo]: /url &quot;title&quot;\n</code></pre>\n<p>[foo]</p>\n
        // Debug: <pre><code>[foo]: /url &quot;title&quot;\n</code></pre>\n<p>[foo]</p>\n
        XCTAssertEqual(try compile("    [foo]: /url \"title\"\n\n[foo]\n"),
                       Document(elements: [.codeBlock(infoString: "", content: "[foo]: /url \"title\"\n"), .paragraph([.text("[foo]")])]))
    }

    func testCase181() throws {
        // HTML: <pre><code>[foo]: /url\n</code></pre>\n<p>[foo]</p>\n
        // Debug: <pre><code>[foo]: /url\n</code></pre>\n<p>[foo]</p>\n
        XCTAssertEqual(try compile("```\n[foo]: /url\n```\n\n[foo]\n"),
                       Document(elements: [.codeBlock(infoString: "", content: "[foo]: /url\n"), .paragraph([.text("[foo]")])]))
    }

    func testCase182() throws {
        // HTML: <p>Foo\n[bar]: /baz</p>\n<p>[bar]</p>\n
        // Debug: <p>Foo\n[bar]: /baz</p>\n<p>[bar]</p>\n
        XCTAssertEqual(try compile("Foo\n[bar]: /baz\n\n[bar]\n"),
                       Document(elements: [.paragraph([.text("Foo"), .softbreak, .text("[bar]: /baz")]), .paragraph([.text("[bar]")])]))
    }

    func testCase183() throws {
        // HTML: <h1><a href=\"/url\">Foo</a></h1>\n<blockquote>\n<p>bar</p>\n</blockquote>\n
        // Debug: <h1><a href=\"/url\">Foo</a></h1>\n<blockquote>\n<p>bar</p>\n</blockquote>\n
        XCTAssertEqual(try compile("# [Foo]\n[foo]: /url\n> bar\n"),
                       Document(elements: [.heading(level: 1, text: [.link(Link(title: "", url: "/url"), text: [.text("Foo")])]), .blockQuote([.paragraph([.text("bar")])])]))
    }

    func testCase184() throws {
        // HTML: <h1>bar</h1>\n<p><a href=\"/url\">foo</a></p>\n
        // Debug: <h1>bar</h1>\n<p><a href=\"/url\">foo</a></p>\n
        XCTAssertEqual(try compile("[foo]: /url\nbar\n===\n[foo]\n"),
                       Document(elements: [.heading(level: 1, text: [.text("bar")]), .paragraph([.link(Link(title: "", url: "/url"), text: [.text("foo")])])]))
    }

    func testCase185() throws {
        // HTML: <p>===\n<a href=\"/url\">foo</a></p>\n
        // Debug: <p>===\n<a href=\"/url\">foo</a></p>\n
        XCTAssertEqual(try compile("[foo]: /url\n===\n[foo]\n"),
                       Document(elements: [.paragraph([.text("==="), .softbreak, .link(Link(title: "", url: "/url"), text: [.text("foo")])])]))
    }

    func testCase186() throws {
        // HTML: <p><a href=\"/foo-url\" title=\"foo\">foo</a>,\n<a href=\"/bar-url\" title=\"bar\">bar</a>,\n<a href=\"/baz-url\">baz</a></p>\n
        // Debug: <p><a href=\"/foo-url\" title=\"foo\">foo</a>,\n<a href=\"/bar-url\" title=\"bar\">bar</a>,\n<a href=\"/baz-url\">baz</a></p>\n
        XCTAssertEqual(try compile("[foo]: /foo-url \"foo\"\n[bar]: /bar-url\n  \"bar\"\n[baz]: /baz-url\n\n[foo],\n[bar],\n[baz]\n"),
                       Document(elements: [.paragraph([.link(Link(title: "foo", url: "/foo-url"), text: [.text("foo")]), .text(","), .softbreak, .link(Link(title: "bar", url: "/bar-url"), text: [.text("bar")]), .text(","), .softbreak, .link(Link(title: "", url: "/baz-url"), text: [.text("baz")])])]))
    }

    func testCase187() throws {
        // HTML: <p><a href=\"/url\">foo</a></p>\n<blockquote>\n</blockquote>\n
        // Debug: <p><a href=\"/url\">foo</a></p>\n<blockquote>\n</blockquote>\n
        XCTAssertEqual(try compile("[foo]\n\n> [foo]: /url\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "/url"), text: [.text("foo")])]), .blockQuote([])]))
    }

    func testCase188() throws {
        // HTML: 
        // Debug: 
        XCTAssertEqual(try compile("[foo]: /url\n"),
                       Document(elements: []))
    }

    
}
