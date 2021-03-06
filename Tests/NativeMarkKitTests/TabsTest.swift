import Foundation
import XCTest
@testable import NativeMarkKit

final class TabsTest: XCTestCase {
    func testCase1() throws {
        // HTML: <pre><code>foo\tbaz\t\tbim\n</code></pre>\n
        // Debug: <pre><code>foo\tbaz\t\tbim\n</code></pre>\n
        XCTAssertEqual(try compile("\tfoo\tbaz\t\tbim\n"),
                       Document(elements: [.codeBlock(infoString: "", content: "foo\tbaz\t\tbim\n")]))
    }

    func testCase2() throws {
        // HTML: <pre><code>foo\tbaz\t\tbim\n</code></pre>\n
        // Debug: <pre><code>foo\tbaz\t\tbim\n</code></pre>\n
        XCTAssertEqual(try compile("  \tfoo\tbaz\t\tbim\n"),
                       Document(elements: [.codeBlock(infoString: "", content: "foo\tbaz\t\tbim\n")]))
    }

    func testCase3() throws {
        // HTML: <pre><code>a\ta\nὐ\ta\n</code></pre>\n
        // Debug: <pre><code>a\ta\nὐ\ta\n</code></pre>\n
        XCTAssertEqual(try compile("    a\ta\n    ὐ\ta\n"),
                       Document(elements: [.codeBlock(infoString: "", content: "a\ta\nὐ\ta\n")]))
    }

    func testCase4() throws {
        // HTML: <ul>\n<li>\n<p>foo</p>\n<p>bar</p>\n</li>\n</ul>\n
        // Debug: <ul>\n<li>\n<p>foo</p>\n<p>bar</p>\n</li>\n</ul>\n
        XCTAssertEqual(try compile("  - foo\n\n\tbar\n"),
                       Document(elements: [.list(ListInfo(isTight: false, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("foo")]), .paragraph([.text("bar")])])])]))
    }

    func testCase5() throws {
        // HTML: <ul>\n<li>\n<p>foo</p>\n<pre><code>  bar\n</code></pre>\n</li>\n</ul>\n
        // Debug: <ul>\n<li>\n<p>foo</p>\n<pre><code>  bar\n</code></pre>\n</li>\n</ul>\n
        XCTAssertEqual(try compile("- foo\n\n\t\tbar\n"),
                       Document(elements: [.list(ListInfo(isTight: false, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("foo")]), .codeBlock(infoString: "", content: "  bar\n")])])]))
    }

    func testCase6() throws {
        // HTML: <blockquote>\n<pre><code>  foo\n</code></pre>\n</blockquote>\n
        // Debug: <blockquote>\n<pre><code>  foo\n</code></pre>\n</blockquote>\n
        XCTAssertEqual(try compile(">\t\tfoo\n"),
                       Document(elements: [.blockQuote([.codeBlock(infoString: "", content: "  foo\n")])]))
    }

    func testCase7() throws {
        // HTML: <ul>\n<li>\n<pre><code>  foo\n</code></pre>\n</li>\n</ul>\n
        // Debug: <ul>\n<li>\n<pre><code>  foo\n</code></pre>\n</li>\n</ul>\n
        XCTAssertEqual(try compile("-\t\tfoo\n"),
                       Document(elements: [.list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.codeBlock(infoString: "", content: "  foo\n")])])]))
    }

    func testCase8() throws {
        // HTML: <pre><code>foo\nbar\n</code></pre>\n
        // Debug: <pre><code>foo\nbar\n</code></pre>\n
        XCTAssertEqual(try compile("    foo\n\tbar\n"),
                       Document(elements: [.codeBlock(infoString: "", content: "foo\nbar\n")]))
    }

    func testCase9() throws {
        // HTML: <ul>\n<li>foo\n<ul>\n<li>bar\n<ul>\n<li>baz</li>\n</ul>\n</li>\n</ul>\n</li>\n</ul>\n
        // Debug: <ul>\n<li>{foo caused p to open}foo\n<ul>\n<li>{bar caused p to open}bar\n<ul>\n<li>{baz caused p to open}baz{debug: implicitly closing p}</li>\n</ul>\n</li>\n</ul>\n</li>\n</ul>\n
        XCTAssertEqual(try compile(" - foo\n   - bar\n\t - baz\n"),
                       Document(elements: [.list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("foo")]), .list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("bar")]), .list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("baz")])])])])])])])]))
    }

    func testCase10() throws {
        // HTML: <h1>Foo</h1>\n
        // Debug: <h1>Foo</h1>\n
        XCTAssertEqual(try compile("#\tFoo\n"),
                       Document(elements: [.heading(level: 1, text: [.text("Foo")])]))
    }

    func testCase11() throws {
        // HTML: <hr />\n
        // Debug: <hr />\n
        XCTAssertEqual(try compile("*\t*\t*\t\n"),
                       Document(elements: [.thematicBreak]))
    }

    
}
