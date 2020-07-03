// This file autogenerated by NativeMarkSpecImport
    
import Foundation
import XCTest
@testable import NativeMarkKit

final class PrecedenceTest: XCTestCase {
    func testCase12() throws {
        // HTML: <ul>\n<li>`one</li>\n<li>two`</li>\n</ul>\n
        // Debug: <ul>\n<li>`one</li>\n<li>two`</li>\n</ul>\n
        XCTAssertEqual(try compile("- `one\n- two`\n"),
                       Document(elements: [.list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: []), ListItem(elements: [])])]))
    }

    
}