import Foundation
import XCTest
@testable import NativeMarkKit

final class BlanklinesTest: XCTestCase {
    func testCase197() throws {
        // HTML: <p>aaa</p>\n<h1>aaa</h1>\n
        /* Markdown
         
         
         aaa
         
         
         # aaa
         
         
         
         */
        XCTAssertEqual(try compile("  \n\naaa\n  \n\n# aaa\n\n  \n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "aaa", range: (2,0)-(2,2)))
                        ],
                        range: (2, 0)-(2, 3))),
                        .heading(Heading(level: 1,
                                         text: [
                                            .text(InlineString(text: "aaa", range: (5,2)-(5,4)))
                                         ],
                                         range: (5, 0)-(5, 5)))
                       ]))
    }
    
    
}
