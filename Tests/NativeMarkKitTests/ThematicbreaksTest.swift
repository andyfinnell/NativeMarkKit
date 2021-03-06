import Foundation
import XCTest
@testable import NativeMarkKit

final class ThematicbreaksTest: XCTestCase {
    func testCase13() throws {
        // HTML: <hr />\n<hr />\n<hr />\n
        // Debug: <hr />\n<hr />\n<hr />\n
        XCTAssertEqual(try compile("***\n---\n___\n"),
                       Document(elements: [.thematicBreak, .thematicBreak, .thematicBreak]))
    }

    func testCase14() throws {
        // HTML: <p>+++</p>\n
        // Debug: <p>+++</p>\n
        XCTAssertEqual(try compile("+++\n"),
                       Document(elements: [.paragraph([.text("+++")])]))
    }

    func testCase15() throws {
        // HTML: <p>===</p>\n
        // Debug: <p>===</p>\n
        XCTAssertEqual(try compile("===\n"),
                       Document(elements: [.paragraph([.text("===")])]))
    }

    func testCase16() throws {
        // HTML: <p>--\n**\n__</p>\n
        // Debug: <p>--\n**\n__</p>\n
        XCTAssertEqual(try compile("--\n**\n__\n"),
                       Document(elements: [.paragraph([.text("–"), .softbreak, .text("**"), .softbreak, .text("__")])]))
    }

    func testCase17() throws {
        // HTML: <hr />\n<hr />\n<hr />\n
        // Debug: <hr />\n<hr />\n<hr />\n
        XCTAssertEqual(try compile(" ***\n  ***\n   ***\n"),
                       Document(elements: [.thematicBreak, .thematicBreak, .thematicBreak]))
    }

    func testCase18() throws {
        // HTML: <pre><code>***\n</code></pre>\n
        // Debug: <pre><code>***\n</code></pre>\n
        XCTAssertEqual(try compile("    ***\n"),
                       Document(elements: [.codeBlock(infoString: "", content: "***\n")]))
    }

    func testCase19() throws {
        // HTML: <p>Foo\n***</p>\n
        // Debug: <p>Foo\n***</p>\n
        XCTAssertEqual(try compile("Foo\n    ***\n"),
                       Document(elements: [.paragraph([.text("Foo"), .softbreak, .text("***")])]))
    }

    func testCase20() throws {
        // HTML: <hr />\n
        // Debug: <hr />\n
        XCTAssertEqual(try compile("_____________________________________\n"),
                       Document(elements: [.thematicBreak]))
    }

    func testCase21() throws {
        // HTML: <hr />\n
        // Debug: <hr />\n
        XCTAssertEqual(try compile(" - - -\n"),
                       Document(elements: [.thematicBreak]))
    }

    func testCase22() throws {
        // HTML: <hr />\n
        // Debug: <hr />\n
        XCTAssertEqual(try compile(" **  * ** * ** * **\n"),
                       Document(elements: [.thematicBreak]))
    }

    func testCase23() throws {
        // HTML: <hr />\n
        // Debug: <hr />\n
        XCTAssertEqual(try compile("-     -      -      -\n"),
                       Document(elements: [.thematicBreak]))
    }

    func testCase24() throws {
        // HTML: <hr />\n
        // Debug: <hr />\n
        XCTAssertEqual(try compile("- - - -    \n"),
                       Document(elements: [.thematicBreak]))
    }

    func testCase25() throws {
        // HTML: <p>_ _ _ _ a</p>\n<p>a------</p>\n<p>---a---</p>\n
        // Debug: <p>_ _ _ _ a</p>\n<p>a------</p>\n<p>---a---</p>\n
        XCTAssertEqual(try compile("_ _ _ _ a\n\na------\n\n---a---\n"),
                       Document(elements: [.paragraph([.text("_ _ _ _ a")]), .paragraph([.text("a——")]), .paragraph([.text("—a—")])]))
    }

    func testCase26() throws {
        // HTML: <p><em>-</em></p>\n
        // Debug: <p><em>-</em></p>\n
        XCTAssertEqual(try compile(" *-*\n"),
                       Document(elements: [.paragraph([.emphasis([.text("-")])])]))
    }

    func testCase27() throws {
        // HTML: <ul>\n<li>foo</li>\n</ul>\n<hr />\n<ul>\n<li>bar</li>\n</ul>\n
        // Debug: <ul>\n<li>{foo caused p to open}foo{debug: implicitly closing p}</li>\n</ul>\n<hr />\n<ul>\n<li>{bar caused p to open}bar{debug: implicitly closing p}</li>\n</ul>\n
        XCTAssertEqual(try compile("- foo\n***\n- bar\n"),
                       Document(elements: [.list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("foo")])])]), .thematicBreak, .list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("bar")])])])]))
    }

    func testCase28() throws {
        // HTML: <p>Foo</p>\n<hr />\n<p>bar</p>\n
        // Debug: <p>Foo</p>\n<hr />\n<p>bar</p>\n
        XCTAssertEqual(try compile("Foo\n***\nbar\n"),
                       Document(elements: [.paragraph([.text("Foo")]), .thematicBreak, .paragraph([.text("bar")])]))
    }

    func testCase29() throws {
        // HTML: <h2>Foo</h2>\n<p>bar</p>\n
        // Debug: <h2>Foo</h2>\n<p>bar</p>\n
        XCTAssertEqual(try compile("Foo\n---\nbar\n"),
                       Document(elements: [.heading(level: 2, text: [.text("Foo")]), .paragraph([.text("bar")])]))
    }

    func testCase30() throws {
        // HTML: <ul>\n<li>Foo</li>\n</ul>\n<hr />\n<ul>\n<li>Bar</li>\n</ul>\n
        // Debug: <ul>\n<li>{Foo caused p to open}Foo{debug: implicitly closing p}</li>\n</ul>\n<hr />\n<ul>\n<li>{Bar caused p to open}Bar{debug: implicitly closing p}</li>\n</ul>\n
        XCTAssertEqual(try compile("* Foo\n* * *\n* Bar\n"),
                       Document(elements: [.list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("Foo")])])]), .thematicBreak, .list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("Bar")])])])]))
    }

    func testCase31() throws {
        // HTML: <ul>\n<li>Foo</li>\n<li>\n<hr />\n</li>\n</ul>\n
        // Debug: <ul>\n<li>{Foo caused p to open}Foo{debug: implicitly closing p}</li>\n<li>\n<hr />\n</li>\n</ul>\n
        XCTAssertEqual(try compile("- Foo\n- * * *\n"),
                       Document(elements: [.list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("Foo")])]), ListItem(elements: [.thematicBreak])])]))
    }

    
}
