import Foundation
import XCTest
@testable import NativeMarkKit

final class HardlinebreaksTest: XCTestCase {
    func testCase630() throws {
        // HTML: <p>foo<br />\nbaz</p>\n
        // Debug: <p>foo<br />\nbaz</p>\n
        XCTAssertEqual(try compile("foo  \nbaz\n"),
                       Document(elements: [.paragraph([.text("foo"), .linebreak, .text("baz")])]))
    }

    func testCase631() throws {
        // HTML: <p>foo<br />\nbaz</p>\n
        // Debug: <p>foo<br />\nbaz</p>\n
        XCTAssertEqual(try compile("foo\\\nbaz\n"),
                       Document(elements: [.paragraph([.text("foo"), .linebreak, .text("baz")])]))
    }

    func testCase632() throws {
        // HTML: <p>foo<br />\nbaz</p>\n
        // Debug: <p>foo<br />\nbaz</p>\n
        XCTAssertEqual(try compile("foo       \nbaz\n"),
                       Document(elements: [.paragraph([.text("foo"), .linebreak, .text("baz")])]))
    }

    func testCase633() throws {
        // HTML: <p>foo<br />\nbar</p>\n
        // Debug: <p>foo<br />\nbar</p>\n
        XCTAssertEqual(try compile("foo  \n     bar\n"),
                       Document(elements: [.paragraph([.text("foo"), .linebreak, .text("bar")])]))
    }

    func testCase634() throws {
        // HTML: <p>foo<br />\nbar</p>\n
        // Debug: <p>foo<br />\nbar</p>\n
        XCTAssertEqual(try compile("foo\\\n     bar\n"),
                       Document(elements: [.paragraph([.text("foo"), .linebreak, .text("bar")])]))
    }

    func testCase635() throws {
        // HTML: <p><em>foo<br />\nbar</em></p>\n
        // Debug: <p><em>foo<br />\nbar</em></p>\n
        XCTAssertEqual(try compile("*foo  \nbar*\n"),
                       Document(elements: [.paragraph([.emphasis([.text("foo"), .linebreak, .text("bar")])])]))
    }

    func testCase636() throws {
        // HTML: <p><em>foo<br />\nbar</em></p>\n
        // Debug: <p><em>foo<br />\nbar</em></p>\n
        XCTAssertEqual(try compile("*foo\\\nbar*\n"),
                       Document(elements: [.paragraph([.emphasis([.text("foo"), .linebreak, .text("bar")])])]))
    }

    func testCase637() throws {
        // HTML: <p><code>code  span</code></p>\n
        // Debug: <p><code>code  span</code></p>\n
        XCTAssertEqual(try compile("`code \nspan`\n"),
                       Document(elements: [.paragraph([.code("code  span")])]))
    }

    func testCase638() throws {
        // HTML: <p><code>code\\ span</code></p>\n
        // Debug: <p><code>code\\ span</code></p>\n
        XCTAssertEqual(try compile("`code\\\nspan`\n"),
                       Document(elements: [.paragraph([.code("code\\ span")])]))
    }

    func testCase639() throws {
        // Input: <a href=\"foo  \nbar\">\n
        // HTML: <p><a href=\"foo  \nbar\"></p>\n
         XCTAssertEqual(try compile("<a href=\"foo  \nbar\">\n"),
                        Document(elements: [.paragraph([.text("<a href=\u{201D}foo"), .linebreak, .text("bar\">")])]))
    }

    func testCase640() throws {
        // Input: <a href=\"foo\\\nbar\">\n
        // HTML: <p><a href=\"foo\\\nbar\"></p>\n
        XCTAssertEqual(try compile("<a href=\"foo\\\nbar\">\n"),
                       Document(elements: [.paragraph([.text("<a href=\u{201D}foo"), .linebreak, .text("bar\">")])]))
    }

    func testCase641() throws {
        // HTML: <p>foo\\</p>\n
        // Debug: <p>foo\\</p>\n
        XCTAssertEqual(try compile("foo\\\n"),
                       Document(elements: [.paragraph([.text("foo\\")])]))
    }

    func testCase642() throws {
        // HTML: <p>foo</p>\n
        // Debug: <p>foo</p>\n
        XCTAssertEqual(try compile("foo  \n"),
                       Document(elements: [.paragraph([.text("foo")])]))
    }

    func testCase643() throws {
        // HTML: <h3>foo\\</h3>\n
        // Debug: <h3>foo\\</h3>\n
        XCTAssertEqual(try compile("### foo\\\n"),
                       Document(elements: [.heading(level: 3, text: [.text("foo\\")])]))
    }

    func testCase644() throws {
        // HTML: <h3>foo</h3>\n
        // Debug: <h3>foo</h3>\n
        XCTAssertEqual(try compile("### foo  \n"),
                       Document(elements: [.heading(level: 3, text: [.text("foo")])]))
    }

    
}
