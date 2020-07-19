import Foundation
import XCTest
@testable import NativeMarkKit

final class HtmlblocksTest: XCTestCase {

    func testCase138() throws {
        // HTML: <p><del><em>foo</em></del></p>\n
        // Debug: <p><del><em>foo</em></del></p>\n
        XCTAssertEqual(try compile("<del>*foo*</del>\n"),
                       Document(elements: [.paragraph([.text("<del>"), .emphasis([.text("foo")]), .text("</del>")])]))
    }

    
}
