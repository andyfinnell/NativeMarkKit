import Foundation
import XCTest
@testable import NativeMarkKit

final class ParagraphsTest: XCTestCase {
    func testCase189() throws {
        // HTML: <p>aaa</p>\n<p>bbb</p>\n
        // Debug: <p>aaa</p>\n<p>bbb</p>\n
        XCTAssertEqual(try compile("aaa\n\nbbb\n"),
                       Document(elements: [.paragraph([.text("aaa")]), .paragraph([.text("bbb")])]))
    }

    func testCase190() throws {
        // HTML: <p>aaa\nbbb</p>\n<p>ccc\nddd</p>\n
        // Debug: <p>aaa\nbbb</p>\n<p>ccc\nddd</p>\n
        XCTAssertEqual(try compile("aaa\nbbb\n\nccc\nddd\n"),
                       Document(elements: [.paragraph([.text("aaa"), .softbreak, .text("bbb")]), .paragraph([.text("ccc"), .softbreak, .text("ddd")])]))
    }

    func testCase191() throws {
        // HTML: <p>aaa</p>\n<p>bbb</p>\n
        // Debug: <p>aaa</p>\n<p>bbb</p>\n
        XCTAssertEqual(try compile("aaa\n\n\nbbb\n"),
                       Document(elements: [.paragraph([.text("aaa")]), .paragraph([.text("bbb")])]))
    }

    func testCase192() throws {
        // HTML: <p>aaa\nbbb</p>\n
        // Debug: <p>aaa\nbbb</p>\n
        XCTAssertEqual(try compile("  aaa\n bbb\n"),
                       Document(elements: [.paragraph([.text("aaa"), .softbreak, .text("bbb")])]))
    }

    func testCase193() throws {
        // HTML: <p>aaa\nbbb\nccc</p>\n
        // Debug: <p>aaa\nbbb\nccc</p>\n
        XCTAssertEqual(try compile("aaa\n             bbb\n                                       ccc\n"),
                       Document(elements: [.paragraph([.text("aaa"), .softbreak, .text("bbb"), .softbreak, .text("ccc")])]))
    }

    func testCase194() throws {
        // HTML: <p>aaa\nbbb</p>\n
        // Debug: <p>aaa\nbbb</p>\n
        XCTAssertEqual(try compile("   aaa\nbbb\n"),
                       Document(elements: [.paragraph([.text("aaa"), .softbreak, .text("bbb")])]))
    }

    func testCase195() throws {
        // HTML: <pre><code>aaa\n</code></pre>\n<p>bbb</p>\n
        // Debug: <pre><code>aaa\n</code></pre>\n<p>bbb</p>\n
        XCTAssertEqual(try compile("    aaa\nbbb\n"),
                       Document(elements: [.codeBlock(infoString: "", content: "aaa\n"), .paragraph([.text("bbb")])]))
    }

    func testCase196() throws {
        // HTML: <p>aaa<br />\nbbb</p>\n
        // Debug: <p>aaa<br />\nbbb</p>\n
        XCTAssertEqual(try compile("aaa     \nbbb     \n"),
                       Document(elements: [.paragraph([.text("aaa"), .linebreak, .text("bbb")])]))
    }

    
}
