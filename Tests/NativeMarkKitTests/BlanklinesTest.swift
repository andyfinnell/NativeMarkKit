import Foundation
import XCTest
@testable import NativeMarkKit

final class BlanklinesTest: XCTestCase {
    func testCase197() throws {
        // HTML: <p>aaa</p>\n<h1>aaa</h1>\n
        // Debug: <p>aaa</p>\n<h1>aaa</h1>\n
        XCTAssertEqual(try compile("  \n\naaa\n  \n\n# aaa\n\n  \n"),
                       Document(elements: [.paragraph([.text("aaa")]), .heading(level: 1, text: [.text("aaa")])]))
    }

    
}
