import Foundation
import XCTest
@testable import NativeMarkKit

final class SetextheadingsTest: XCTestCase {
    func testCase50() throws {
        // HTML: <h1>Foo <em>bar</em></h1>\n<h2>Foo <em>bar</em></h2>\n
        // Debug: <h1>Foo <em>bar</em></h1>\n<h2>Foo <em>bar</em></h2>\n
        XCTAssertEqual(try compile("Foo *bar*\n=========\n\nFoo *bar*\n---------\n"),
                       Document(elements: [.heading(level: 1, text: [.text("Foo "), .emphasis([.text("bar")])]), .heading(level: 2, text: [.text("Foo "), .emphasis([.text("bar")])])]))
    }

    func testCase51() throws {
        // HTML: <h1>Foo <em>bar\nbaz</em></h1>\n
        // Debug: <h1>Foo <em>bar\nbaz</em></h1>\n
        XCTAssertEqual(try compile("Foo *bar\nbaz*\n====\n"),
                       Document(elements: [.heading(level: 1, text: [.text("Foo "), .emphasis([.text("bar"), .softbreak, .text("baz")])])]))
    }

    func testCase52() throws {
        // HTML: <h1>Foo <em>bar\nbaz</em></h1>\n
        // Debug: <h1>Foo <em>bar\nbaz</em></h1>\n
        XCTAssertEqual(try compile("  Foo *bar\nbaz*\t\n====\n"),
                       Document(elements: [.heading(level: 1, text: [.text("Foo "), .emphasis([.text("bar"), .softbreak, .text("baz")])])]))
    }

    func testCase53() throws {
        // HTML: <h2>Foo</h2>\n<h1>Foo</h1>\n
        // Debug: <h2>Foo</h2>\n<h1>Foo</h1>\n
        XCTAssertEqual(try compile("Foo\n-------------------------\n\nFoo\n=\n"),
                       Document(elements: [.heading(level: 2, text: [.text("Foo")]), .heading(level: 1, text: [.text("Foo")])]))
    }

    func testCase54() throws {
        // HTML: <h2>Foo</h2>\n<h2>Foo</h2>\n<h1>Foo</h1>\n
        // Debug: <h2>Foo</h2>\n<h2>Foo</h2>\n<h1>Foo</h1>\n
        XCTAssertEqual(try compile("   Foo\n---\n\n  Foo\n-----\n\n  Foo\n  ===\n"),
                       Document(elements: [.heading(level: 2, text: [.text("Foo")]), .heading(level: 2, text: [.text("Foo")]), .heading(level: 1, text: [.text("Foo")])]))
    }

    func testCase55() throws {
        // HTML: <pre><code>Foo\n---\n\nFoo\n</code></pre>\n<hr />\n
        // Debug: <pre><code>Foo\n---\n\nFoo\n</code></pre>\n<hr />\n
        XCTAssertEqual(try compile("    Foo\n    ---\n\n    Foo\n---\n"),
                       Document(elements: [.codeBlock(infoString: "", content: "Foo\n---\n\nFoo\n"), .thematicBreak]))
    }

    func testCase56() throws {
        // HTML: <h2>Foo</h2>\n
        // Debug: <h2>Foo</h2>\n
        XCTAssertEqual(try compile("Foo\n   ----      \n"),
                       Document(elements: [.heading(level: 2, text: [.text("Foo")])]))
    }

    func testCase57() throws {
        // HTML: <p>Foo\n---</p>\n
        // Debug: <p>Foo\n---</p>\n
        XCTAssertEqual(try compile("Foo\n    ---\n"),
                       Document(elements: [.paragraph([.text("Foo"), .softbreak, .text("—")])]))
    }

    func testCase58() throws {
        // HTML: <p>Foo\n= =</p>\n<p>Foo</p>\n<hr />\n
        // Debug: <p>Foo\n= =</p>\n<p>Foo</p>\n<hr />\n
        XCTAssertEqual(try compile("Foo\n= =\n\nFoo\n--- -\n"),
                       Document(elements: [.paragraph([.text("Foo"), .softbreak, .text("= =")]), .paragraph([.text("Foo")]), .thematicBreak]))
    }

    func testCase59() throws {
        // HTML: <h2>Foo</h2>\n
        // Debug: <h2>Foo</h2>\n
        XCTAssertEqual(try compile("Foo  \n-----\n"),
                       Document(elements: [.heading(level: 2, text: [.text("Foo")])]))
    }

    func testCase60() throws {
        // HTML: <h2>Foo\\</h2>\n
        // Debug: <h2>Foo\\</h2>\n
        XCTAssertEqual(try compile("Foo\\\n----\n"),
                       Document(elements: [.heading(level: 2, text: [.text("Foo\\")])]))
    }

    func testCase61() throws {
        // Input: `Foo\n----\n`\n\n<a title=\"a lot\n---\nof dashes\"/>\n
        // HTML: <h2>`Foo</h2>\n<p>`</p>\n<h2>&lt;a title=&quot;a lot</h2>\n<p>of dashes&quot;/&gt;</p>\n
         XCTAssertEqual(try compile("`Foo\n----\n`\n\n<a title=\"a lot\n---\nof dashes\"/>\n"),
                        Document(elements: [.heading(level: 2, text: [.text("`Foo")]), .paragraph([.text("`")]), .heading(level: 2, text: [.text("<a title=”a lot")]), .paragraph([.text("of dashes”/>")])]))
    }

    func testCase62() throws {
        // HTML: <blockquote>\n<p>Foo</p>\n</blockquote>\n<hr />\n
        // Debug: <blockquote>\n<p>Foo</p>\n</blockquote>\n<hr />\n
        XCTAssertEqual(try compile("> Foo\n---\n"),
                       Document(elements: [.blockQuote([.paragraph([.text("Foo")])]), .thematicBreak]))
    }

    func testCase63() throws {
        // HTML: <blockquote>\n<p>foo\nbar\n===</p>\n</blockquote>\n
        // Debug: <blockquote>\n<p>foo\nbar\n===</p>\n</blockquote>\n
        XCTAssertEqual(try compile("> foo\nbar\n===\n"),
                       Document(elements: [.blockQuote([.paragraph([.text("foo"), .softbreak, .text("bar"), .softbreak, .text("===")])])]))
    }

    func testCase64() throws {
        // HTML: <ul>\n<li>Foo</li>\n</ul>\n<hr />\n
        // Debug: <ul>\n<li>{Foo caused p to open}Foo{debug: implicitly closing p}</li>\n</ul>\n<hr />\n
        XCTAssertEqual(try compile("- Foo\n---\n"),
                       Document(elements: [.list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("Foo")])])]), .thematicBreak]))
    }

    func testCase65() throws {
        // HTML: <h2>Foo\nBar</h2>\n
        // Debug: <h2>Foo\nBar</h2>\n
        XCTAssertEqual(try compile("Foo\nBar\n---\n"),
                       Document(elements: [.heading(level: 2, text: [.text("Foo"), .softbreak, .text("Bar")])]))
    }

    func testCase66() throws {
        // HTML: <hr />\n<h2>Foo</h2>\n<h2>Bar</h2>\n<p>Baz</p>\n
        // Debug: <hr />\n<h2>Foo</h2>\n<h2>Bar</h2>\n<p>Baz</p>\n
        XCTAssertEqual(try compile("---\nFoo\n---\nBar\n---\nBaz\n"),
                       Document(elements: [.thematicBreak, .heading(level: 2, text: [.text("Foo")]), .heading(level: 2, text: [.text("Bar")]), .paragraph([.text("Baz")])]))
    }

    func testCase67() throws {
        // HTML: <p>====</p>\n
        // Debug: <p>====</p>\n
        XCTAssertEqual(try compile("\n====\n"),
                       Document(elements: [.paragraph([.text("====")])]))
    }

    func testCase68() throws {
        // HTML: <hr />\n<hr />\n
        // Debug: <hr />\n<hr />\n
        XCTAssertEqual(try compile("---\n---\n"),
                       Document(elements: [.thematicBreak, .thematicBreak]))
    }

    func testCase69() throws {
        // HTML: <ul>\n<li>foo</li>\n</ul>\n<hr />\n
        // Debug: <ul>\n<li>{foo caused p to open}foo{debug: implicitly closing p}</li>\n</ul>\n<hr />\n
        XCTAssertEqual(try compile("- foo\n-----\n"),
                       Document(elements: [.list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("foo")])])]), .thematicBreak]))
    }

    func testCase70() throws {
        // HTML: <pre><code>foo\n</code></pre>\n<hr />\n
        // Debug: <pre><code>foo\n</code></pre>\n<hr />\n
        XCTAssertEqual(try compile("    foo\n---\n"),
                       Document(elements: [.codeBlock(infoString: "", content: "foo\n"), .thematicBreak]))
    }

    func testCase71() throws {
        // HTML: <blockquote>\n<p>foo</p>\n</blockquote>\n<hr />\n
        // Debug: <blockquote>\n<p>foo</p>\n</blockquote>\n<hr />\n
        XCTAssertEqual(try compile("> foo\n-----\n"),
                       Document(elements: [.blockQuote([.paragraph([.text("foo")])]), .thematicBreak]))
    }

    func testCase72() throws {
        // HTML: <h2>&gt; foo</h2>\n
        // Debug: <h2>&gt; foo</h2>\n
        XCTAssertEqual(try compile("\\> foo\n------\n"),
                       Document(elements: [.heading(level: 2, text: [.text("> foo")])]))
    }

    func testCase73() throws {
        // HTML: <p>Foo</p>\n<h2>bar</h2>\n<p>baz</p>\n
        // Debug: <p>Foo</p>\n<h2>bar</h2>\n<p>baz</p>\n
        XCTAssertEqual(try compile("Foo\n\nbar\n---\nbaz\n"),
                       Document(elements: [.paragraph([.text("Foo")]), .heading(level: 2, text: [.text("bar")]), .paragraph([.text("baz")])]))
    }

    func testCase74() throws {
        // HTML: <p>Foo\nbar</p>\n<hr />\n<p>baz</p>\n
        // Debug: <p>Foo\nbar</p>\n<hr />\n<p>baz</p>\n
        XCTAssertEqual(try compile("Foo\nbar\n\n---\n\nbaz\n"),
                       Document(elements: [.paragraph([.text("Foo"), .softbreak, .text("bar")]), .thematicBreak, .paragraph([.text("baz")])]))
    }

    func testCase75() throws {
        // HTML: <p>Foo\nbar</p>\n<hr />\n<p>baz</p>\n
        // Debug: <p>Foo\nbar</p>\n<hr />\n<p>baz</p>\n
        XCTAssertEqual(try compile("Foo\nbar\n* * *\nbaz\n"),
                       Document(elements: [.paragraph([.text("Foo"), .softbreak, .text("bar")]), .thematicBreak, .paragraph([.text("baz")])]))
    }

    func testCase76() throws {
        // HTML: <p>Foo\nbar\n---\nbaz</p>\n
        // Debug: <p>Foo\nbar\n---\nbaz</p>\n
        XCTAssertEqual(try compile("Foo\nbar\n\\---\nbaz\n"),
                       Document(elements: [.paragraph([.text("Foo"), .softbreak, .text("bar"), .softbreak, .text("-–"), .softbreak, .text("baz")])]))
    }

    
}
