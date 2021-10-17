import Foundation
import XCTest
@testable import NativeMarkKit

final class InlinesTest: XCTestCase {
    func testCase297() throws {
        // HTML: <p><code>hi</code>lo`</p>\n
        /* Markdown
         `hi`lo`
         
         */
        XCTAssertEqual(try compile("`hi`lo`\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .code(InlineCode(code: InlineString(text: "hi", range: (0, 1)-(0, 2)),
                                             range: (0, 0)-(0, 3))),
                            .text(InlineString(text: "lo`", range: (0,4)-(0,6)))
                        ],
                        range: (0, 0)-(0, 7)))
                       ]))
    }
    
    
}
