import Foundation
import XCTest
@testable import NativeMarkKit

final class BlockquotesTest: XCTestCase {
    func testCase198() throws {
        // HTML: <blockquote>\n<h1>Foo</h1>\n<p>bar\nbaz</p>\n</blockquote>\n
        // Debug: <blockquote>\n<h1>Foo</h1>\n<p>bar\nbaz</p>\n</blockquote>\n
        XCTAssertEqual(try compile("> # Foo\n> bar\n> baz\n"),
                       Document(elements: [.blockQuote([.heading(level: 1, text: [.text("Foo")]), .paragraph([.text("bar"), .softbreak, .text("baz")])])]))
    }

    func testCase199() throws {
        // HTML: <blockquote>\n<h1>Foo</h1>\n<p>bar\nbaz</p>\n</blockquote>\n
        // Debug: <blockquote>\n<h1>Foo</h1>\n<p>bar\nbaz</p>\n</blockquote>\n
        XCTAssertEqual(try compile("># Foo\n>bar\n> baz\n"),
                       Document(elements: [.blockQuote([.heading(level: 1, text: [.text("Foo")]), .paragraph([.text("bar"), .softbreak, .text("baz")])])]))
    }

    func testCase200() throws {
        // HTML: <blockquote>\n<h1>Foo</h1>\n<p>bar\nbaz</p>\n</blockquote>\n
        // Debug: <blockquote>\n<h1>Foo</h1>\n<p>bar\nbaz</p>\n</blockquote>\n
        XCTAssertEqual(try compile("   > # Foo\n   > bar\n > baz\n"),
                       Document(elements: [.blockQuote([.heading(level: 1, text: [.text("Foo")]), .paragraph([.text("bar"), .softbreak, .text("baz")])])]))
    }

    func testCase201() throws {
        // HTML: <pre><code>&gt; # Foo\n&gt; bar\n&gt; baz\n</code></pre>\n
        // Debug: <pre><code>&gt; # Foo\n&gt; bar\n&gt; baz\n</code></pre>\n
        XCTAssertEqual(try compile("    > # Foo\n    > bar\n    > baz\n"),
                       Document(elements: [.codeBlock(infoString: "", content: "> # Foo\n> bar\n> baz\n")]))
    }

    func testCase202() throws {
        // HTML: <blockquote>\n<h1>Foo</h1>\n<p>bar\nbaz</p>\n</blockquote>\n
        // Debug: <blockquote>\n<h1>Foo</h1>\n<p>bar\nbaz</p>\n</blockquote>\n
        XCTAssertEqual(try compile("> # Foo\n> bar\nbaz\n"),
                       Document(elements: [.blockQuote([.heading(level: 1, text: [.text("Foo")]), .paragraph([.text("bar"), .softbreak, .text("baz")])])]))
    }

    func testCase203() throws {
        // HTML: <blockquote>\n<p>bar\nbaz\nfoo</p>\n</blockquote>\n
        // Debug: <blockquote>\n<p>bar\nbaz\nfoo</p>\n</blockquote>\n
        XCTAssertEqual(try compile("> bar\nbaz\n> foo\n"),
                       Document(elements: [.blockQuote([.paragraph([.text("bar"), .softbreak, .text("baz"), .softbreak, .text("foo")])])]))
    }

    func testCase204() throws {
        // HTML: <blockquote>\n<p>foo</p>\n</blockquote>\n<hr />\n
        // Debug: <blockquote>\n<p>foo</p>\n</blockquote>\n<hr />\n
        XCTAssertEqual(try compile("> foo\n---\n"),
                       Document(elements: [.blockQuote([.paragraph([.text("foo")])]), .thematicBreak]))
    }

    func testCase205() throws {
        // HTML: <blockquote>\n<ul>\n<li>foo</li>\n</ul>\n</blockquote>\n<ul>\n<li>bar</li>\n</ul>\n
        // Debug: <blockquote>\n<ul>\n<li>{foo caused p to open}foo{debug: implicitly closing p}</li>\n</ul>\n</blockquote>\n<ul>\n<li>{bar caused p to open}bar{debug: implicitly closing p}</li>\n</ul>\n
        XCTAssertEqual(try compile("> - foo\n- bar\n"),
                       Document(elements: [.blockQuote([.list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("foo")])])])]), .list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("bar")])])])]))
    }

    func testCase206() throws {
        // HTML: <blockquote>\n<pre><code>foo\n</code></pre>\n</blockquote>\n<pre><code>bar\n</code></pre>\n
        // Debug: <blockquote>\n<pre><code>foo\n</code></pre>\n</blockquote>\n<pre><code>bar\n</code></pre>\n
        XCTAssertEqual(try compile(">     foo\n    bar\n"),
                       Document(elements: [.blockQuote([.codeBlock(infoString: "", content: "foo\n")]), .codeBlock(infoString: "", content: "bar\n")]))
    }

    func testCase207() throws {
        // HTML: <blockquote>\n<pre><code></code></pre>\n</blockquote>\n<p>foo</p>\n<pre><code></code></pre>\n
        // Debug: <blockquote>\n<pre><code></code></pre>\n</blockquote>\n<p>foo</p>\n<pre><code></code></pre>\n
        XCTAssertEqual(try compile("> ```\nfoo\n```\n"),
                       Document(elements: [.blockQuote([.codeBlock(infoString: "", content: "")]), .paragraph([.text("foo")]), .codeBlock(infoString: "", content: "")]))
    }

    func testCase208() throws {
        // HTML: <blockquote>\n<p>foo\n- bar</p>\n</blockquote>\n
        // Debug: <blockquote>\n<p>foo\n- bar</p>\n</blockquote>\n
        XCTAssertEqual(try compile("> foo\n    - bar\n"),
                       Document(elements: [.blockQuote([.paragraph([.text("foo"), .softbreak, .text("- bar")])])]))
    }

    func testCase209() throws {
        // HTML: <blockquote>\n</blockquote>\n
        // Debug: <blockquote>\n</blockquote>\n
        XCTAssertEqual(try compile(">\n"),
                       Document(elements: [.blockQuote([])]))
    }

    func testCase210() throws {
        // HTML: <blockquote>\n</blockquote>\n
        // Debug: <blockquote>\n</blockquote>\n
        XCTAssertEqual(try compile(">\n>  \n> \n"),
                       Document(elements: [.blockQuote([])]))
    }

    func testCase211() throws {
        // HTML: <blockquote>\n<p>foo</p>\n</blockquote>\n
        // Debug: <blockquote>\n<p>foo</p>\n</blockquote>\n
        XCTAssertEqual(try compile(">\n> foo\n>  \n"),
                       Document(elements: [.blockQuote([.paragraph([.text("foo")])])]))
    }

    func testCase212() throws {
        // HTML: <blockquote>\n<p>foo</p>\n</blockquote>\n<blockquote>\n<p>bar</p>\n</blockquote>\n
        // Debug: <blockquote>\n<p>foo</p>\n</blockquote>\n<blockquote>\n<p>bar</p>\n</blockquote>\n
        XCTAssertEqual(try compile("> foo\n\n> bar\n"),
                       Document(elements: [.blockQuote([.paragraph([.text("foo")])]), .blockQuote([.paragraph([.text("bar")])])]))
    }

    func testCase213() throws {
        // HTML: <blockquote>\n<p>foo\nbar</p>\n</blockquote>\n
        // Debug: <blockquote>\n<p>foo\nbar</p>\n</blockquote>\n
        XCTAssertEqual(try compile("> foo\n> bar\n"),
                       Document(elements: [.blockQuote([.paragraph([.text("foo"), .softbreak, .text("bar")])])]))
    }

    func testCase214() throws {
        // HTML: <blockquote>\n<p>foo</p>\n<p>bar</p>\n</blockquote>\n
        // Debug: <blockquote>\n<p>foo</p>\n<p>bar</p>\n</blockquote>\n
        XCTAssertEqual(try compile("> foo\n>\n> bar\n"),
                       Document(elements: [.blockQuote([.paragraph([.text("foo")]), .paragraph([.text("bar")])])]))
    }

    func testCase215() throws {
        // HTML: <p>foo</p>\n<blockquote>\n<p>bar</p>\n</blockquote>\n
        // Debug: <p>foo</p>\n<blockquote>\n<p>bar</p>\n</blockquote>\n
        XCTAssertEqual(try compile("foo\n> bar\n"),
                       Document(elements: [.paragraph([.text("foo")]), .blockQuote([.paragraph([.text("bar")])])]))
    }

    func testCase216() throws {
        // HTML: <blockquote>\n<p>aaa</p>\n</blockquote>\n<hr />\n<blockquote>\n<p>bbb</p>\n</blockquote>\n
        // Debug: <blockquote>\n<p>aaa</p>\n</blockquote>\n<hr />\n<blockquote>\n<p>bbb</p>\n</blockquote>\n
        XCTAssertEqual(try compile("> aaa\n***\n> bbb\n"),
                       Document(elements: [.blockQuote([.paragraph([.text("aaa")])]), .thematicBreak, .blockQuote([.paragraph([.text("bbb")])])]))
    }

    func testCase217() throws {
        // HTML: <blockquote>\n<p>bar\nbaz</p>\n</blockquote>\n
        // Debug: <blockquote>\n<p>bar\nbaz</p>\n</blockquote>\n
        XCTAssertEqual(try compile("> bar\nbaz\n"),
                       Document(elements: [.blockQuote([.paragraph([.text("bar"), .softbreak, .text("baz")])])]))
    }

    func testCase218() throws {
        // HTML: <blockquote>\n<p>bar</p>\n</blockquote>\n<p>baz</p>\n
        // Debug: <blockquote>\n<p>bar</p>\n</blockquote>\n<p>baz</p>\n
        XCTAssertEqual(try compile("> bar\n\nbaz\n"),
                       Document(elements: [.blockQuote([.paragraph([.text("bar")])]), .paragraph([.text("baz")])]))
    }

    func testCase219() throws {
        // HTML: <blockquote>\n<p>bar</p>\n</blockquote>\n<p>baz</p>\n
        // Debug: <blockquote>\n<p>bar</p>\n</blockquote>\n<p>baz</p>\n
        XCTAssertEqual(try compile("> bar\n>\nbaz\n"),
                       Document(elements: [.blockQuote([.paragraph([.text("bar")])]), .paragraph([.text("baz")])]))
    }

    func testCase220() throws {
        // HTML: <blockquote>\n<blockquote>\n<blockquote>\n<p>foo\nbar</p>\n</blockquote>\n</blockquote>\n</blockquote>\n
        // Debug: <blockquote>\n<blockquote>\n<blockquote>\n<p>foo\nbar</p>\n</blockquote>\n</blockquote>\n</blockquote>\n
        XCTAssertEqual(try compile("> > > foo\nbar\n"),
                       Document(elements: [.blockQuote([.blockQuote([.blockQuote([.paragraph([.text("foo"), .softbreak, .text("bar")])])])])]))
    }

    func testCase221() throws {
        // HTML: <blockquote>\n<blockquote>\n<blockquote>\n<p>foo\nbar\nbaz</p>\n</blockquote>\n</blockquote>\n</blockquote>\n
        // Debug: <blockquote>\n<blockquote>\n<blockquote>\n<p>foo\nbar\nbaz</p>\n</blockquote>\n</blockquote>\n</blockquote>\n
        XCTAssertEqual(try compile(">>> foo\n> bar\n>>baz\n"),
                       Document(elements: [.blockQuote([.blockQuote([.blockQuote([.paragraph([.text("foo"), .softbreak, .text("bar"), .softbreak, .text("baz")])])])])]))
    }

    func testCase222() throws {
        // HTML: <blockquote>\n<pre><code>code\n</code></pre>\n</blockquote>\n<blockquote>\n<p>not code</p>\n</blockquote>\n
        // Debug: <blockquote>\n<pre><code>code\n</code></pre>\n</blockquote>\n<blockquote>\n<p>not code</p>\n</blockquote>\n
        XCTAssertEqual(try compile(">     code\n\n>    not code\n"),
                       Document(elements: [.blockQuote([.codeBlock(infoString: "", content: "code\n")]), .blockQuote([.paragraph([.text("not code")])])]))
    }

    
}
