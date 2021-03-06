import Foundation
import XCTest
@testable import NativeMarkKit

final class CodespansTest: XCTestCase {
    func testCase328() throws {
        // HTML: <p><code>foo</code></p>\n
        // Debug: <p><code>foo</code></p>\n
        XCTAssertEqual(try compile("`foo`\n"),
                       Document(elements: [.paragraph([.code("foo")])]))
    }

    func testCase329() throws {
        // HTML: <p><code>foo ` bar</code></p>\n
        // Debug: <p><code>foo ` bar</code></p>\n
        XCTAssertEqual(try compile("`` foo ` bar ``\n"),
                       Document(elements: [.paragraph([.code("foo ` bar")])]))
    }

    func testCase330() throws {
        // HTML: <p><code>``</code></p>\n
        // Debug: <p><code>``</code></p>\n
        XCTAssertEqual(try compile("` `` `\n"),
                       Document(elements: [.paragraph([.code("``")])]))
    }

    func testCase331() throws {
        // HTML: <p><code> `` </code></p>\n
        // Debug: <p><code> `` </code></p>\n
        XCTAssertEqual(try compile("`  ``  `\n"),
                       Document(elements: [.paragraph([.code(" `` ")])]))
    }

    func testCase332() throws {
        // HTML: <p><code> a</code></p>\n
        // Debug: <p><code> a</code></p>\n
        XCTAssertEqual(try compile("` a`\n"),
                       Document(elements: [.paragraph([.code(" a")])]))
    }

    func testCase333() throws {
        // HTML: <p><code> b </code></p>\n
        // Debug: <p><code> b </code></p>\n
        XCTAssertEqual(try compile("` b `\n"),
                       Document(elements: [.paragraph([.code(" b ")])]))
    }

    func testCase334() throws {
        // HTML: <p><code> </code>\n<code>  </code></p>\n
        // Debug: <p><code> </code>\n<code>  </code></p>\n
        XCTAssertEqual(try compile("` `\n`  `\n"),
                       Document(elements: [.paragraph([.code(" "), .softbreak, .code("  ")])]))
    }

    func testCase335() throws {
        // HTML: <p><code>foo bar   baz</code></p>\n
        // Debug: <p><code>foo bar   baz</code></p>\n
        XCTAssertEqual(try compile("``\nfoo\nbar  \nbaz\n``\n"),
                       Document(elements: [.paragraph([.code("foo bar   baz")])]))
    }

    func testCase336() throws {
        // HTML: <p><code>foo </code></p>\n
        // Debug: <p><code>foo </code></p>\n
        XCTAssertEqual(try compile("``\nfoo \n``\n"),
                       Document(elements: [.paragraph([.code("foo ")])]))
    }

    func testCase337() throws {
        // HTML: <p><code>foo   bar  baz</code></p>\n
        // Debug: <p><code>foo   bar  baz</code></p>\n
        XCTAssertEqual(try compile("`foo   bar \nbaz`\n"),
                       Document(elements: [.paragraph([.code("foo   bar  baz")])]))
    }

    func testCase338() throws {
        // HTML: <p><code>foo\\</code>bar`</p>\n
        // Debug: <p><code>foo\\</code>bar`</p>\n
        XCTAssertEqual(try compile("`foo\\`bar`\n"),
                       Document(elements: [.paragraph([.code("foo\\"), .text("bar`")])]))
    }

    func testCase339() throws {
        // HTML: <p><code>foo`bar</code></p>\n
        // Debug: <p><code>foo`bar</code></p>\n
        XCTAssertEqual(try compile("``foo`bar``\n"),
                       Document(elements: [.paragraph([.code("foo`bar")])]))
    }

    func testCase340() throws {
        // HTML: <p><code>foo `` bar</code></p>\n
        // Debug: <p><code>foo `` bar</code></p>\n
        XCTAssertEqual(try compile("` foo `` bar `\n"),
                       Document(elements: [.paragraph([.code("foo `` bar")])]))
    }

    func testCase341() throws {
        // HTML: <p>*foo<code>*</code></p>\n
        // Debug: <p>*foo<code>*</code></p>\n
        XCTAssertEqual(try compile("*foo`*`\n"),
                       Document(elements: [.paragraph([.text("*foo"), .code("*")])]))
    }

    func testCase342() throws {
        // HTML: <p>[not a <code>link](/foo</code>)</p>\n
        // Debug: <p>[not a <code>link](/foo</code>)</p>\n
        XCTAssertEqual(try compile("[not a `link](/foo`)\n"),
                       Document(elements: [.paragraph([.text("[not a "), .code("link](/foo"), .text(")")])]))
    }

    func testCase343() throws {
        // Input: `<a href=\"`\">`\n
        // HTML: <p><code>&lt;a href=&quot;</code>&quot;&gt;`</p>\n
         XCTAssertEqual(try compile("`<a href=\"`\">`\n"),
                        Document(elements: [.paragraph([.code("<a href=\""), .text("”>`")])]))
    }

    func testCase344() throws {
        // Input: <a href=\"`\">`\n
        // HTML: <p><a href=\"`\">`</p>\n
         XCTAssertEqual(try compile("<a href=\"`\">`\n"),
                        Document(elements: [.paragraph([.text("<a href=”"), .code("\">")])]))
    }

    func testCase345() throws {
        // HTML: <p><code>&lt;http://foo.bar.</code>baz&gt;`</p>\n
        // Debug: <p><code>&lt;http://foo.bar.</code>baz&gt;`</p>\n
        XCTAssertEqual(try compile("`<http://foo.bar.`baz>`\n"),
                       Document(elements: [.paragraph([.code("<http://foo.bar."), .text("baz>`")])]))
    }

    func testCase346() throws {
        // HTML: <p><a href=\"http://foo.bar.%60baz\">http://foo.bar.`baz</a>`</p>\n
        // Debug: <p><a href=\"http://foo.bar.%60baz\">http://foo.bar.`baz</a>`</p>\n
        XCTAssertEqual(try compile("<http://foo.bar.`baz>`\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "http://foo.bar.`baz"), text: [.text("http://foo.bar.`baz")]), .text("`")])]))
    }

    func testCase347() throws {
        // HTML: <p>```foo``</p>\n
        // Debug: <p>```foo``</p>\n
        XCTAssertEqual(try compile("```foo``\n"),
                       Document(elements: [.paragraph([.text("```foo``")])]))
    }

    func testCase348() throws {
        // HTML: <p>`foo</p>\n
        // Debug: <p>`foo</p>\n
        XCTAssertEqual(try compile("`foo\n"),
                       Document(elements: [.paragraph([.text("`foo")])]))
    }

    func testCase349() throws {
        // HTML: <p>`foo<code>bar</code></p>\n
        // Debug: <p>`foo<code>bar</code></p>\n
        XCTAssertEqual(try compile("`foo``bar``\n"),
                       Document(elements: [.paragraph([.text("`foo"), .code("bar")])]))
    }

    
}
