import Foundation
import XCTest
@testable import NativeMarkKit

final class BackslashescapesTest: XCTestCase {
    func testCase298() throws {
        // HTML: <p>!&quot;#$%&amp;'()*+,-./:;&lt;=&gt;?@[\\]^_`{|}~</p>\n
        // Debug: <p>!&quot;#$%&amp;'()*+,-./:;&lt;=&gt;?@[\\]^_`{|}~</p>\n
        XCTAssertEqual(try compile("\\!\\\"\\#\\$\\%\\&\\'\\(\\)\\*\\+\\,\\-\\.\\/\\:\\;\\<\\=\\>\\?\\@\\[\\\\\\]\\^\\_\\`\\{\\|\\}\\~\n"),
                       Document(elements: [.paragraph([.text("!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~")])]))
    }

    func testCase299() throws {
        // HTML: <p>\\\t\\A\\a\\ \\3\\φ\\«</p>\n
        // Debug: <p>\\\t\\A\\a\\ \\3\\φ\\«</p>\n
        XCTAssertEqual(try compile("\\\t\\A\\a\\ \\3\\φ\\«\n"),
                       Document(elements: [.paragraph([.text("\\\t\\A\\a\\ \\3\\φ\\«")])]))
    }

    func testCase300() throws {
        // Input: \\*not emphasized*\n\\<br/> not a tag\n\\[not a link](/foo)\n\\`not code`\n1\\. not a list\n\\* not a list\n\\# not a heading\n\\[foo]: /url \"not a reference\"\n\\&ouml; not a character entity\n
        // HTML: <p>*not emphasized*\n&lt;br/&gt; not a tag\n[not a link](/foo)\n`not code`\n1. not a list\n* not a list\n# not a heading\n[foo]: /url &quot;not a reference&quot;\n&amp;ouml; not a character entity</p>\n
         XCTAssertEqual(try compile("\\*not emphasized*\n\\<br/> not a tag\n\\[not a link](/foo)\n\\`not code`\n1\\. not a list\n\\* not a list\n\\# not a heading\n\\[foo]: /url \"not a reference\"\n\\&ouml; not a character entity\n"),
                        Document(elements: [.paragraph([.text("*not emphasized*"), .softbreak, .text("<br/> not a tag"), .softbreak, .text("[not a link](/foo)"), .softbreak, .text("`not code`"), .softbreak, .text("1. not a list"), .softbreak, .text("* not a list"), .softbreak, .text("# not a heading"), .softbreak, .text("[foo]: /url “not a reference”"), .softbreak, .text("&ouml; not a character entity")])]))
    }

    func testCase301() throws {
        // HTML: <p>\\<em>emphasis</em></p>\n
        // Debug: <p>\\<em>emphasis</em></p>\n
        XCTAssertEqual(try compile("\\\\*emphasis*\n"),
                       Document(elements: [.paragraph([.text("\\"), .emphasis([.text("emphasis")])])]))
    }

    func testCase302() throws {
        // HTML: <p>foo<br />\nbar</p>\n
        // Debug: <p>foo<br />\nbar</p>\n
        XCTAssertEqual(try compile("foo\\\nbar\n"),
                       Document(elements: [.paragraph([.text("foo"), .linebreak, .text("bar")])]))
    }

    func testCase303() throws {
        // HTML: <p><code>\\[\\`</code></p>\n
        // Debug: <p><code>\\[\\`</code></p>\n
        XCTAssertEqual(try compile("`` \\[\\` ``\n"),
                       Document(elements: [.paragraph([.code("\\[\\`")])]))
    }

    func testCase304() throws {
        // HTML: <pre><code>\\[\\]\n</code></pre>\n
        // Debug: <pre><code>\\[\\]\n</code></pre>\n
        XCTAssertEqual(try compile("    \\[\\]\n"),
                       Document(elements: [.codeBlock(infoString: "", content: "\\[\\]\n")]))
    }

    func testCase305() throws {
        // HTML: <pre><code>\\[\\]\n</code></pre>\n
        // Debug: <pre><code>\\[\\]\n</code></pre>\n
        XCTAssertEqual(try compile("~~~\n\\[\\]\n~~~\n"),
                       Document(elements: [.codeBlock(infoString: "", content: "\\[\\]\n")]))
    }

    func testCase306() throws {
        // HTML: <p><a href=\"http://example.com?find=%5C*\">http://example.com?find=\\*</a></p>\n
        // Debug: <p><a href=\"http://example.com?find=%5C*\">http://example.com?find=\\*</a></p>\n
        XCTAssertEqual(try compile("<http://example.com?find=\\*>\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "http://example.com?find=\\*"), text: [.text("http://example.com?find=\\*")])])]))
    }

    func testCase307() throws {
        // Input: <a href=\"/bar\\/)\">\n
        // HTML: <a href=\"/bar\\/)\">\n
         XCTAssertEqual(try compile("<a href=\"/bar\\/)\">\n"),
                        Document(elements: [.paragraph([.text("<a href=”/bar/)\">")])]))
    }

    func testCase308() throws {
        // HTML: <p><a href=\"/bar*\" title=\"ti*tle\">foo</a></p>\n
        // Debug: <p><a href=\"/bar*\" title=\"ti*tle\">foo</a></p>\n
        XCTAssertEqual(try compile("[foo](/bar\\* \"ti\\*tle\")\n"),
                       Document(elements: [.paragraph([.link(Link(title: "ti*tle", url: "/bar*"), text: [.text("foo")])])]))
    }

    func testCase309() throws {
        // HTML: <p><a href=\"/bar*\" title=\"ti*tle\">foo</a></p>\n
        // Debug: <p><a href=\"/bar*\" title=\"ti*tle\">foo</a></p>\n
        XCTAssertEqual(try compile("[foo]\n\n[foo]: /bar\\* \"ti\\*tle\"\n"),
                       Document(elements: [.paragraph([.link(Link(title: "ti*tle", url: "/bar*"), text: [.text("foo")])])]))
    }

    func testCase310() throws {
        // HTML: <pre><code class=\"language-foo+bar\">foo\n</code></pre>\n
        // Debug: <pre><code class=\"language-foo+bar\">foo\n</code></pre>\n
        XCTAssertEqual(try compile("``` foo\\+bar\nfoo\n```\n"),
                       Document(elements: [.codeBlock(infoString: "foo+bar", content: "foo\n")]))
    }

    
}
