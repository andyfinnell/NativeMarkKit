import Foundation
import XCTest
@testable import NativeMarkKit

final class TextualcontentTest: XCTestCase {
    func testCase647() throws {
        // HTML: <p>hello $.;'there</p>\n
        // Debug: <p>hello $.;'there</p>\n
        XCTAssertEqual(try compile("hello $.;'there\n"),
                       Document(elements: [.paragraph([.text("hello $.;'there")])]))
    }

    func testCase648() throws {
        // HTML: <p>Foo χρῆν</p>\n
        // Debug: <p>Foo χρῆν</p>\n
        XCTAssertEqual(try compile("Foo χρῆν\n"),
                       Document(elements: [.paragraph([.text("Foo χρῆν")])]))
    }

    func testCase649() throws {
        // HTML: <p>Multiple     spaces</p>\n
        // Debug: <p>Multiple     spaces</p>\n
        XCTAssertEqual(try compile("Multiple     spaces\n"),
                       Document(elements: [.paragraph([.text("Multiple     spaces")])]))
    }

    
}
