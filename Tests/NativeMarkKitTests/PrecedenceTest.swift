import Foundation
import XCTest
@testable import NativeMarkKit

final class PrecedenceTest: XCTestCase {
    func testCase12() throws {
        // HTML: <ul>\n<li>`one</li>\n<li>two`</li>\n</ul>\n
        /* Markdown
         - `one
         - two`
         
         */
        XCTAssertEqual(try compile("- `one\n- two`\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "`one", range: (0,2)-(0,5)))
                                ],
                                range: (0, 2)-(0, 6)))
                            ], range: (0, 0)-(0,6)),
                            ListItem(elements: [
                                .paragraph(Paragraph(text: [
                                    .text(InlineString(text: "two`", range: (1,2)-(1,5)))
                                ],
                                range: (1, 2)-(1, 6)))
                            ], range: (1, 0)-(1,6))
                        ]))
                       ]))
    }
    
    
}
