import Foundation
import XCTest
@testable import NativeMarkKit

final class IndentedcodeblocksTest: XCTestCase {
    func testCase77() throws {
        // HTML: <pre><code>a simple\n  indented code block\n</code></pre>\n
        // Debug: <pre><code>a simple\n  indented code block\n</code></pre>\n
        XCTAssertEqual(try compile("    a simple\n      indented code block\n"),
                       Document(elements: [.codeBlock(infoString: "", content: "a simple\n  indented code block\n")]))
    }

    func testCase78() throws {
        // HTML: <ul>\n<li>\n<p>foo</p>\n<p>bar</p>\n</li>\n</ul>\n
        // Debug: <ul>\n<li>\n<p>foo</p>\n<p>bar</p>\n</li>\n</ul>\n
        XCTAssertEqual(try compile("  - foo\n\n    bar\n"),
                       Document(elements: [.list(ListInfo(isTight: false, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("foo")]), .paragraph([.text("bar")])])])]))
    }

    func testCase79() throws {
        // HTML: <ol>\n<li>\n<p>foo</p>\n<ul>\n<li>bar</li>\n</ul>\n</li>\n</ol>\n
        // Debug: <ol>\n<li>\n<p>foo</p>\n<ul>\n<li>{bar caused p to open}bar{debug: implicitly closing p}</li>\n</ul>\n</li>\n</ol>\n
        XCTAssertEqual(try compile("1.  foo\n\n    - bar\n"),
                       Document(elements: [.list(ListInfo(isTight: false, kind: .ordered(start: 1)), items: [ListItem(elements: [.paragraph([.text("foo")]), .list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("bar")])])])])])]))
    }

    func testCase80() throws {
        // Input:     <a/>\n    *hi*\n\n    - one\n
        // HTML: <pre><code>&lt;a/&gt;\n*hi*\n\n- one\n</code></pre>\n
         XCTAssertEqual(try compile("    <a/>\n    *hi*\n\n    - one\n"),
                        Document(elements: [.codeBlock(infoString: "", content: "<a/>\n*hi*\n\n- one\n")]))
    }

    func testCase81() throws {
        // HTML: <pre><code>chunk1\n\nchunk2\n\n\n\nchunk3\n</code></pre>\n
        // Debug: <pre><code>chunk1\n\nchunk2\n\n\n\nchunk3\n</code></pre>\n
        XCTAssertEqual(try compile("    chunk1\n\n    chunk2\n  \n \n \n    chunk3\n"),
                       Document(elements: [.codeBlock(infoString: "", content: "chunk1\n\nchunk2\n\n\n\nchunk3\n")]))
    }

    func testCase82() throws {
        // HTML: <pre><code>chunk1\n  \n  chunk2\n</code></pre>\n
        // Debug: <pre><code>chunk1\n  \n  chunk2\n</code></pre>\n
        XCTAssertEqual(try compile("    chunk1\n      \n      chunk2\n"),
                       Document(elements: [.codeBlock(infoString: "", content: "chunk1\n  \n  chunk2\n")]))
    }

    func testCase83() throws {
        // HTML: <p>Foo\nbar</p>\n
        // Debug: <p>Foo\nbar</p>\n
        XCTAssertEqual(try compile("Foo\n    bar\n\n"),
                       Document(elements: [.paragraph([.text("Foo"), .softbreak, .text("bar")])]))
    }

    func testCase84() throws {
        // HTML: <pre><code>foo\n</code></pre>\n<p>bar</p>\n
        // Debug: <pre><code>foo\n</code></pre>\n<p>bar</p>\n
        XCTAssertEqual(try compile("    foo\nbar\n"),
                       Document(elements: [.codeBlock(infoString: "", content: "foo\n"), .paragraph([.text("bar")])]))
    }

    func testCase85() throws {
        // HTML: <h1>Heading</h1>\n<pre><code>foo\n</code></pre>\n<h2>Heading</h2>\n<pre><code>foo\n</code></pre>\n<hr />\n
        // Debug: <h1>Heading</h1>\n<pre><code>foo\n</code></pre>\n<h2>Heading</h2>\n<pre><code>foo\n</code></pre>\n<hr />\n
        XCTAssertEqual(try compile("# Heading\n    foo\nHeading\n------\n    foo\n----\n"),
                       Document(elements: [.heading(level: 1, text: [.text("Heading")]), .codeBlock(infoString: "", content: "foo\n"), .heading(level: 2, text: [.text("Heading")]), .codeBlock(infoString: "", content: "foo\n"), .thematicBreak]))
    }

    func testCase86() throws {
        // HTML: <pre><code>    foo\nbar\n</code></pre>\n
        // Debug: <pre><code>    foo\nbar\n</code></pre>\n
        XCTAssertEqual(try compile("        foo\n    bar\n"),
                       Document(elements: [.codeBlock(infoString: "", content: "    foo\nbar\n")]))
    }

    func testCase87() throws {
        // HTML: <pre><code>foo\n</code></pre>\n
        // Debug: <pre><code>foo\n</code></pre>\n
        XCTAssertEqual(try compile("\n    \n    foo\n    \n\n"),
                       Document(elements: [.codeBlock(infoString: "", content: "foo\n")]))
    }

    func testCase88() throws {
        // HTML: <pre><code>foo  \n</code></pre>\n
        // Debug: <pre><code>foo  \n</code></pre>\n
        XCTAssertEqual(try compile("    foo  \n"),
                       Document(elements: [.codeBlock(infoString: "", content: "foo  \n")]))
    }

    
}
