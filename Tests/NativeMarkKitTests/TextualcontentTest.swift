import Foundation
import XCTest
@testable import NativeMarkKit

final class TextualcontentTest: XCTestCase {
    func testCase647() throws {
        // HTML: <p>hello $.;'there</p>\n
        /* Markdown
         hello $.;'there
         
         */
        XCTAssertEqual(try compile("hello $.;'there\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "hello $.;'there", range: (0,0)-(0,14)))
                        ],
                        range: (0, 0)-(0, 15)))
                       ]))
    }
    
    func testCase648() throws {
        // HTML: <p>Foo χρῆν</p>\n
        /* Markdown
         Foo χρῆν
         
         */
        XCTAssertEqual(try compile("Foo χρῆν\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "Foo χρῆν", range: (0,0)-(0,7)))
                        ],
                        range: (0, 0)-(0, 8)))
                       ]))
    }
    
    func testCase649() throws {
        // HTML: <p>Multiple     spaces</p>\n
        /* Markdown
         Multiple     spaces
         
         */
        XCTAssertEqual(try compile("Multiple     spaces\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "Multiple     spaces", range: (0,0)-(0,18)))
                        ],
                        range: (0, 0)-(0, 19)))
                       ]))
    }
    
    
}
