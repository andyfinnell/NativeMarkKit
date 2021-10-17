import Foundation
import XCTest
@testable import NativeMarkKit

final class HardlinebreaksTest: XCTestCase {
    func testCase630() throws {
        // HTML: <p>foo<br />\nbaz</p>\n
        /* Markdown
         foo
         baz
         
         */
        XCTAssertEqual(try compile("foo  \nbaz\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo", range: (0,0)-(0,2))),
                            .linebreak(InlineLinebreak(range: (0, 3)-(0, 5))),
                            .text(InlineString(text: "baz", range: (1,0)-(1,2)))
                        ],
                        range: (0, 0)-(1, 3)))
                       ]))
    }
    
    func testCase631() throws {
        // HTML: <p>foo<br />\nbaz</p>\n
        /* Markdown
         foo\
         baz
         
         */
        XCTAssertEqual(try compile("foo\\\nbaz\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo", range: (0,0)-(0,2))),
                            .linebreak(InlineLinebreak(range: (0, 3)-(0, 4))),
                            .text(InlineString(text: "baz", range: (1,0)-(1,2)))
                        ],
                        range: (0, 0)-(1, 3)))
                       ]))
    }
    
    func testCase632() throws {
        // HTML: <p>foo<br />\nbaz</p>\n
        /* Markdown
         foo
         baz
         
         */
        XCTAssertEqual(try compile("foo       \nbaz\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo", range: (0,0)-(0,2))),
                            .linebreak(InlineLinebreak(range: (0, 3)-(0, 10))),
                            .text(InlineString(text: "baz", range: (1,0)-(1,2)))
                        ],
                        range: (0, 0)-(1, 3)))
                       ]))
    }
    
    func testCase633() throws {
        // HTML: <p>foo<br />\nbar</p>\n
        /* Markdown
         foo
         bar
         
         */
        XCTAssertEqual(try compile("foo  \n     bar\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo", range: (0,0)-(0,2))),
                            .linebreak(InlineLinebreak(range: (0, 3)-(1, 4))),
                            .text(InlineString(text: "bar", range: (1,5)-(1,7)))
                        ],
                        range: (0, 0)-(1, 8)))
                       ]))
    }
    
    func testCase634() throws {
        // HTML: <p>foo<br />\nbar</p>\n
        /* Markdown
         foo\
         bar
         
         */
        XCTAssertEqual(try compile("foo\\\n     bar\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo", range: (0,0)-(0,2))),
                            .linebreak(InlineLinebreak(range: (0, 3)-(1, 4))),
                            .text(InlineString(text: "bar", range: (1,5)-(1,7)))
                        ],
                        range: (0, 0)-(1, 8)))
                       ]))
    }
    
    func testCase635() throws {
        // HTML: <p><em>foo<br />\nbar</em></p>\n
        /* Markdown
         *foo
         bar*
         
         */
        XCTAssertEqual(try compile("*foo  \nbar*\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "foo", range: (0,1)-(0,3))),
                                .linebreak(InlineLinebreak(range: (0, 4)-(0, 6))),
                                .text(InlineString(text: "bar", range: (1,0)-(1,2)))
                            ],
                            range:(0, 0)-(1, 3)))
                        ],
                        range: (0, 0)-(1, 4)))
                       ]))
    }
    
    func testCase636() throws {
        // HTML: <p><em>foo<br />\nbar</em></p>\n
        /* Markdown
         *foo\
         bar*
         
         */
        XCTAssertEqual(try compile("*foo\\\nbar*\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "foo", range: (0,1)-(0,3))),
                                .linebreak(InlineLinebreak(range: (0, 4)-(0, 5))),
                                .text(InlineString(text: "bar", range: (1,0)-(1,2)))
                            ],
                            range:(0, 0)-(1, 3)))
                        ],
                        range: (0, 0)-(1, 4)))
                       ]))
    }
    
    func testCase637() throws {
        // HTML: <p><code>code  span</code></p>\n
        /* Markdown
         `code
         span`
         
         */
        XCTAssertEqual(try compile("`code \nspan`\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .code(InlineCode(code: InlineString(text: "code  span", range: (0, 1)-(1, 3)),
                                             range: (0, 0)-(1, 4)))
                        ],
                        range: (0, 0)-(1, 5)))
                       ]))
    }
    
    func testCase638() throws {
        // HTML: <p><code>code\\ span</code></p>\n
        /* Markdown
         `code\
         span`
         
         */
        XCTAssertEqual(try compile("`code\\\nspan`\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .code(InlineCode(code: InlineString(text: "code\\ span", range: (0, 1)-(1, 3)),
                                             range: (0, 0)-(1, 4)))
                        ],
                        range: (0, 0)-(1, 5)))
                       ]))
    }
    
    func testCase639() throws {
        // Input: <a href=\"foo  \nbar\">\n
        // HTML: <p><a href=\"foo  \nbar\"></p>\n
        XCTAssertEqual(try compile("<a href=\"foo  \nbar\">\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "<a href=\u{201D}foo", range: (0, 0)-(0, 11))),
                            .linebreak(InlineLinebreak(range: (0, 12)-(0, 14))),
                            .text(InlineString(text: "bar\">", range: (1, 0)-(1, 4)))
                                    ],
                        range: (0, 0)-(1, 5)))
                       ]))

    }
    
    func testCase640() throws {
        // Input: <a href=\"foo\\\nbar\">\n
        // HTML: <p><a href=\"foo\\\nbar\"></p>\n
        XCTAssertEqual(try compile("<a href=\"foo\\\nbar\">\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "<a href=\u{201D}foo", range: (0, 0)-(0, 11))),
                            .linebreak(InlineLinebreak(range: (0, 12)-(0, 13))),
                            .text(InlineString(text: "bar\">", range: (1, 0)-(1, 4)))
                        ],
                        range: (0, 0)-(1, 5)))
                       ]))
    }
    
    func testCase641() throws {
        // HTML: <p>foo\\</p>\n
        /* Markdown
         foo\
         
         */
        XCTAssertEqual(try compile("foo\\\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo\\", range: (0,0)-(0,3)))
                        ],
                        range: (0, 0)-(0, 4)))
                       ]))
    }
    
    func testCase642() throws {
        // HTML: <p>foo</p>\n
        /* Markdown
         foo
         
         */
        XCTAssertEqual(try compile("foo  \n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo", range: (0,0)-(0,2)))
                        ],
                        range: (0, 0)-(0, 5)))
                       ]))
    }
    
    func testCase643() throws {
        // HTML: <h3>foo\\</h3>\n
        /* Markdown
         ### foo\
         
         */
        XCTAssertEqual(try compile("### foo\\\n"),
                       Document(elements: [
                        .heading(Heading(level: 3,
                                         text: [
                                            .text(InlineString(text: "foo\\", range: (0,4)-(0,7)))
                                         ],
                                         range: (0, 0)-(0, 8)))
                       ]))
    }
    
    func testCase644() throws {
        // HTML: <h3>foo</h3>\n
        /* Markdown
         ### foo
         
         */
        XCTAssertEqual(try compile("### foo  \n"),
                       Document(elements: [
                        .heading(Heading(level: 3,
                                         text: [
                                            .text(InlineString(text: "foo", range: (0,4)-(0,6)))
                                         ],
                                         range: (0, 0)-(0, 9)))
                       ]))
    }
    
    
}
