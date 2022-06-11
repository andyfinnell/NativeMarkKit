import Foundation
import XCTest
@testable import NativeMarkKit

final class ParagraphsTest: XCTestCase {
    func testCase189() throws {
        // HTML: <p>aaa</p>\n<p>bbb</p>\n
        /* Markdown
         aaa
         
         bbb
         
         */
        XCTAssertEqual(try compile("aaa\n\nbbb\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "aaa", range: (0,0)-(0,2)))
                        ],
                        range: (0, 0)-(0, 3))),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "bbb", range: (2,0)-(2,2)))
                        ],
                        range: (2, 0)-(2, 3)))
                       ]))
    }
    
    func testCase190() throws {
        // HTML: <p>aaa\nbbb</p>\n<p>ccc\nddd</p>\n
        /* Markdown
         aaa
         bbb
         
         ccc
         ddd
         
         */
        XCTAssertEqual(try compile("aaa\nbbb\n\nccc\nddd\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "aaa", range: (0,0)-(0,2))),
                            .softbreak(InlineSoftbreak(range: (0, 3)-(0, 3))),
                            .text(InlineString(text: "bbb", range: (1,0)-(1,2)))
                        ],
                        range: (0, 0)-(1, 3))),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "ccc", range: (3,0)-(3,2))),
                            .softbreak(InlineSoftbreak(range: (3, 3)-(3, 3))),
                            .text(InlineString(text: "ddd", range: (4,0)-(4,2)))
                        ],
                        range: (3, 0)-(4, 3)))
                       ]))
    }
    
    func testCase191() throws {
        // HTML: <p>aaa</p>\n<p>bbb</p>\n
        /* Markdown
         aaa
         
         
         bbb
         
         */
        XCTAssertEqual(try compile("aaa\n\n\nbbb\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "aaa", range: (0,0)-(0,2)))
                        ],
                        range: (0, 0)-(0, 3))),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "bbb", range: (3,0)-(3,2)))
                        ],
                        range: (3, 0)-(3, 3)))
                       ]))
    }
    
    func testCase192() throws {
        // HTML: <p>aaa\nbbb</p>\n
        /* Markdown
         aaa
         bbb
         
         */
        XCTAssertEqual(try compile("  aaa\n bbb\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "aaa", range: (0,2)-(0,4))),
                            .softbreak(InlineSoftbreak(range: (0, 5)-(1, 0))),
                            .text(InlineString(text: "bbb", range: (1,1)-(1,3)))
                        ],
                        range: (0, 2)-(1, 4)))
                       ]))
    }
    
    func testCase193() throws {
        // HTML: <p>aaa\nbbb\nccc</p>\n
        /* Markdown
         aaa
         bbb
         ccc
         
         */
        XCTAssertEqual(try compile("aaa\n             bbb\n                                       ccc\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "aaa", range: (0,0)-(0,2))),
                            .softbreak(InlineSoftbreak(range: (0, 3)-(1, 12))),
                            .text(InlineString(text: "bbb", range: (1,13)-(1,15))),
                            .softbreak(InlineSoftbreak(range: (1, 16)-(2, 38))),
                            .text(InlineString(text: "ccc", range: (2,39)-(2,41)))
                        ],
                        range: (0, 0)-(2, 42)))
                       ]))
    }
    
    func testCase194() throws {
        // HTML: <p>aaa\nbbb</p>\n
        /* Markdown
         aaa
         bbb
         
         */
        XCTAssertEqual(try compile("   aaa\nbbb\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "aaa", range: (0,3)-(0,5))),
                            .softbreak(InlineSoftbreak(range: (0, 6)-(0, 6))),
                            .text(InlineString(text: "bbb", range: (1,0)-(1,2)))
                        ],
                        range: (0, 3)-(1, 3)))
                       ]))
    }
    
    func testCase195() throws {
        // HTML: <pre><code>aaa\n</code></pre>\n<p>bbb</p>\n
        /* Markdown
         aaa
         bbb
         
         */
        XCTAssertEqual(try compile("    aaa\nbbb\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "", content: "aaa\n", range: (0, 4)-(0, 7))),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "bbb", range: (1,0)-(1,2)))
                        ],
                        range: (1, 0)-(1, 3)))
                       ]))
    }
    
    func testCase196() throws {
        // HTML: <p>aaa<br />\nbbb</p>\n
        /* Markdown
         aaa
         bbb
         
         */
        XCTAssertEqual(try compile("aaa     \nbbb     \n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "aaa", range: (0,0)-(0,2))),
                            .linebreak(InlineLinebreak(range: (0, 3)-(0, 8))),
                            .text(InlineString(text: "bbb", range: (1,0)-(1,2)))
                        ],
                        range: (0, 0)-(1, 8)))
                       ]))
    }
    
    
}
