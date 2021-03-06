import Foundation
import XCTest
@testable import NativeMarkKit

final class InlinesTest: XCTestCase {
    func testCase297() throws {
        // HTML: <p><code>hi</code>lo`</p>\n
        // Debug: <p><code>hi</code>lo`</p>\n
        XCTAssertEqual(try compile("`hi`lo`\n"),
                       Document(elements: [.paragraph([.code("hi"), .text("lo`")])]))
    }

    
}
