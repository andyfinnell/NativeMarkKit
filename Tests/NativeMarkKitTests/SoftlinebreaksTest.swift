import Foundation
import XCTest
@testable import NativeMarkKit

final class SoftlinebreaksTest: XCTestCase {
    func testCase645() throws {
        // HTML: <p>foo\nbaz</p>\n
        // Debug: <p>foo\nbaz</p>\n
        XCTAssertEqual(try compile("foo\nbaz\n"),
                       Document(elements: [.paragraph([.text("foo"), .softbreak, .text("baz")])]))
    }

    func testCase646() throws {
        // HTML: <p>foo\nbaz</p>\n
        // Debug: <p>foo\nbaz</p>\n
        XCTAssertEqual(try compile("foo \n baz\n"),
                       Document(elements: [.paragraph([.text("foo"), .softbreak, .text("baz")])]))
    }

    
}
