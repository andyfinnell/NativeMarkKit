import Foundation
import XCTest
@testable import NativeMarkKit

final class SoftlinebreaksTest: XCTestCase {
    func testCase645() throws {
        // HTML: <p>foo\nbaz</p>\n
        /* Markdown
         foo
         baz
         
         */
        XCTAssertEqual(try compile("foo\nbaz\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo", range: (0,0)-(0,2))),
                            .softbreak(InlineSoftbreak(range: (0, 3)-(0, 3))),
                            .text(InlineString(text: "baz", range: (1,0)-(1,2)))
                        ],
                        range: (0, 0)-(1, 3)))
                       ]))
    }
    
    func testCase646() throws {
        // HTML: <p>foo\nbaz</p>\n
        /* Markdown
         foo 
         baz
         
         */
        XCTAssertEqual(try compile("foo \n baz\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo", range: (0,0)-(0,2))),
                            .softbreak(InlineSoftbreak(range: (0, 3)-(1, 0))),
                            .text(InlineString(text: "baz", range: (1,1)-(1,3)))
                        ],
                        range: (0, 0)-(1, 4)))
                       ]))
    }
    
    
}
