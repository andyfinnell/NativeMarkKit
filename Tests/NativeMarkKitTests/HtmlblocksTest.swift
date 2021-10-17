import Foundation
import XCTest
@testable import NativeMarkKit

final class HtmlblocksTest: XCTestCase {
    func testCase138() throws {
        // HTML: <p><del><em>foo</em></del></p>\n
        /* Markdown
         <del>*foo*</del>
         
         */
        XCTAssertEqual(try compile("<del>*foo*</del>\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "<del>", range: (0,0)-(0,4))),
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "foo", range: (0,6)-(0,8)))
                            ],
                            range:(0, 5)-(0, 9))),
                            .text(InlineString(text: "</del>", range: (0,10)-(0,15)))
                        ],
                        range: (0, 0)-(0, 16)))
                       ]))
    }
}
