import Foundation
import XCTest
@testable import NativeMarkKit

final class StrikethroughTest: XCTestCase {
    func testCaseStrikethrough1() throws {
        XCTAssertEqual(try compile("~foo bar~\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "~foo bar~", range: (0,0)-(0,9)))
                        ],
                        range: (0, 0)-(0, 9)))
                       ]))
    }

    func testCaseStrikethrough350() throws {
        XCTAssertEqual(try compile("~~foo bar~~\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .strikethrough(InlineStrikethrough(text: [
                                .text(InlineString(text: "foo bar", range: (0,2)-(0,8)))
                            ],
                            range:(0, 0)-(0, 10)))
                        ],
                        range: (0, 0)-(0, 11)))
                       ]))
    }
    
    func testCaseStrikethrough351() throws {
        XCTAssertEqual(try compile("a ~~ foo bar~~\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "a ~~ foo bar~~", range: (0,0)-(0,13)))
                        ],
                        range: (0, 0)-(0, 14)))
                       ]))
    }
    
    func testCaseStrikethrough352() throws {
        XCTAssertEqual(try compile("a~~\"foo\"~~\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "a~~“foo”~~", range: (0, 0)-(0, 9)))
                        ],
                        range: (0, 0)-(0, 10)))
                       ]))
    }
    
    func testCaseStrikethrough353() throws {
        XCTAssertEqual(try compile("~~ a ~~\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "~~ a ~~", range: (0,0)-(0,6)))
                        ],
                        range: (0, 0)-(0, 7)))
                       ]))
    }
    
    func testCaseStrikethrough354() throws {
        XCTAssertEqual(try compile("foo~~bar~~\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo", range: (0,0)-(0,2))),
                            .strikethrough(InlineStrikethrough(text: [
                                .text(InlineString(text: "bar", range: (0,5)-(0,7)))
                            ],
                            range:(0, 3)-(0, 9)))
                        ],
                        range: (0, 0)-(0, 10)))
                       ]))
    }
    
    func testCaseStrikethrough355() throws {
        XCTAssertEqual(try compile("5~~6~~78\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "5", range: (0,0)-(0,0))),
                            .strikethrough(InlineStrikethrough(text: [
                                .text(InlineString(text: "6", range: (0,3)-(0,3)))
                            ],
                            range:(0, 1)-(0, 5))),
                            .text(InlineString(text: "78", range: (0,6)-(0,7)))
                        ],
                        range: (0, 0)-(0, 8)))
                       ]))
    }

}
