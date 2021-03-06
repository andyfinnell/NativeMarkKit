import Foundation
import XCTest
@testable import NativeMarkKit

final class AtxheadingsTest: XCTestCase {
    func testCase32() throws {
        // HTML: <h1>foo</h1>\n<h2>foo</h2>\n<h3>foo</h3>\n<h4>foo</h4>\n<h5>foo</h5>\n<h6>foo</h6>\n
        // Debug: <h1>foo</h1>\n<h2>foo</h2>\n<h3>foo</h3>\n<h4>foo</h4>\n<h5>foo</h5>\n<h6>foo</h6>\n
        XCTAssertEqual(try compile("# foo\n## foo\n### foo\n#### foo\n##### foo\n###### foo\n"),
                       Document(elements: [.heading(level: 1, text: [.text("foo")]), .heading(level: 2, text: [.text("foo")]), .heading(level: 3, text: [.text("foo")]), .heading(level: 4, text: [.text("foo")]), .heading(level: 5, text: [.text("foo")]), .heading(level: 6, text: [.text("foo")])]))
    }

    func testCase33() throws {
        // HTML: <p>####### foo</p>\n
        // Debug: <p>####### foo</p>\n
        XCTAssertEqual(try compile("####### foo\n"),
                       Document(elements: [.paragraph([.text("####### foo")])]))
    }

    func testCase34() throws {
        // HTML: <p>#5 bolt</p>\n<p>#hashtag</p>\n
        // Debug: <p>#5 bolt</p>\n<p>#hashtag</p>\n
        XCTAssertEqual(try compile("#5 bolt\n\n#hashtag\n"),
                       Document(elements: [.paragraph([.text("#5 bolt")]), .paragraph([.text("#hashtag")])]))
    }

    func testCase35() throws {
        // HTML: <p>## foo</p>\n
        // Debug: <p>## foo</p>\n
        XCTAssertEqual(try compile("\\## foo\n"),
                       Document(elements: [.paragraph([.text("## foo")])]))
    }

    func testCase36() throws {
        // HTML: <h1>foo <em>bar</em> *baz*</h1>\n
        // Debug: <h1>foo <em>bar</em> *baz*</h1>\n
        XCTAssertEqual(try compile("# foo *bar* \\*baz\\*\n"),
                       Document(elements: [.heading(level: 1, text: [.text("foo "), .emphasis([.text("bar")]), .text(" *baz*")])]))
    }

    func testCase37() throws {
        // HTML: <h1>foo</h1>\n
        // Debug: <h1>foo</h1>\n
        XCTAssertEqual(try compile("#                  foo                     \n"),
                       Document(elements: [.heading(level: 1, text: [.text("foo")])]))
    }

    func testCase38() throws {
        // HTML: <h3>foo</h3>\n<h2>foo</h2>\n<h1>foo</h1>\n
        // Debug: <h3>foo</h3>\n<h2>foo</h2>\n<h1>foo</h1>\n
        XCTAssertEqual(try compile(" ### foo\n  ## foo\n   # foo\n"),
                       Document(elements: [.heading(level: 3, text: [.text("foo")]), .heading(level: 2, text: [.text("foo")]), .heading(level: 1, text: [.text("foo")])]))
    }

    func testCase39() throws {
        // HTML: <pre><code># foo\n</code></pre>\n
        // Debug: <pre><code># foo\n</code></pre>\n
        XCTAssertEqual(try compile("    # foo\n"),
                       Document(elements: [.codeBlock(infoString: "", content: "# foo\n")]))
    }

    func testCase40() throws {
        // HTML: <p>foo\n# bar</p>\n
        // Debug: <p>foo\n# bar</p>\n
        XCTAssertEqual(try compile("foo\n    # bar\n"),
                       Document(elements: [.paragraph([.text("foo"), .softbreak, .text("# bar")])]))
    }

    func testCase41() throws {
        // HTML: <h2>foo</h2>\n<h3>bar</h3>\n
        // Debug: <h2>foo</h2>\n<h3>bar</h3>\n
        XCTAssertEqual(try compile("## foo ##\n  ###   bar    ###\n"),
                       Document(elements: [.heading(level: 2, text: [.text("foo")]), .heading(level: 3, text: [.text("bar")])]))
    }

    func testCase42() throws {
        // HTML: <h1>foo</h1>\n<h5>foo</h5>\n
        // Debug: <h1>foo</h1>\n<h5>foo</h5>\n
        XCTAssertEqual(try compile("# foo ##################################\n##### foo ##\n"),
                       Document(elements: [.heading(level: 1, text: [.text("foo")]), .heading(level: 5, text: [.text("foo")])]))
    }

    func testCase43() throws {
        // HTML: <h3>foo</h3>\n
        // Debug: <h3>foo</h3>\n
        XCTAssertEqual(try compile("### foo ###     \n"),
                       Document(elements: [.heading(level: 3, text: [.text("foo")])]))
    }

    func testCase44() throws {
        // HTML: <h3>foo ### b</h3>\n
        // Debug: <h3>foo ### b</h3>\n
        XCTAssertEqual(try compile("### foo ### b\n"),
                       Document(elements: [.heading(level: 3, text: [.text("foo ### b")])]))
    }

    func testCase45() throws {
        // HTML: <h1>foo#</h1>\n
        // Debug: <h1>foo#</h1>\n
        XCTAssertEqual(try compile("# foo#\n"),
                       Document(elements: [.heading(level: 1, text: [.text("foo#")])]))
    }

    func testCase46() throws {
        // HTML: <h3>foo ###</h3>\n<h2>foo ###</h2>\n<h1>foo #</h1>\n
        // Debug: <h3>foo ###</h3>\n<h2>foo ###</h2>\n<h1>foo #</h1>\n
        XCTAssertEqual(try compile("### foo \\###\n## foo #\\##\n# foo \\#\n"),
                       Document(elements: [.heading(level: 3, text: [.text("foo ###")]), .heading(level: 2, text: [.text("foo ###")]), .heading(level: 1, text: [.text("foo #")])]))
    }

    func testCase47() throws {
        // HTML: <hr />\n<h2>foo</h2>\n<hr />\n
        // Debug: <hr />\n<h2>foo</h2>\n<hr />\n
        XCTAssertEqual(try compile("****\n## foo\n****\n"),
                       Document(elements: [.thematicBreak, .heading(level: 2, text: [.text("foo")]), .thematicBreak]))
    }

    func testCase48() throws {
        // HTML: <p>Foo bar</p>\n<h1>baz</h1>\n<p>Bar foo</p>\n
        // Debug: <p>Foo bar</p>\n<h1>baz</h1>\n<p>Bar foo</p>\n
        XCTAssertEqual(try compile("Foo bar\n# baz\nBar foo\n"),
                       Document(elements: [.paragraph([.text("Foo bar")]), .heading(level: 1, text: [.text("baz")]), .paragraph([.text("Bar foo")])]))
    }

    func testCase49() throws {
        // HTML: <h2></h2>\n<h1></h1>\n<h3></h3>\n
        // Debug: <h2></h2>\n<h1></h1>\n<h3></h3>\n
        XCTAssertEqual(try compile("## \n#\n### ###\n"),
                       Document(elements: [.heading(level: 2, text: []), .heading(level: 1, text: []), .heading(level: 3, text: [])]))
    }

    
}
