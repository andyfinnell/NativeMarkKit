import Foundation
import XCTest
@testable import NativeMarkKit

final class AtxheadingsTest: XCTestCase {
    func testCase32() throws {
        // HTML: <h1>foo</h1>\n<h2>foo</h2>\n<h3>foo</h3>\n<h4>foo</h4>\n<h5>foo</h5>\n<h6>foo</h6>\n
        /* Markdown
         # foo
         ## foo
         ### foo
         #### foo
         ##### foo
         ###### foo
         
         */
        XCTAssertEqual(try compile("# foo\n## foo\n### foo\n#### foo\n##### foo\n###### foo\n"),
                       Document(elements: [
                        .heading(Heading(level: 1,
                                         text: [
                                            .text(InlineString(text: "foo", range: (0,2)-(0,4)))
                                         ],
                                         range: (0, 0)-(0, 5))),
                        .heading(Heading(level: 2,
                                         text: [
                                            .text(InlineString(text: "foo", range: (1,3)-(1,5)))
                                         ],
                                         range: (1, 0)-(1, 6))),
                        .heading(Heading(level: 3,
                                         text: [
                                            .text(InlineString(text: "foo", range: (2,4)-(2,6)))
                                         ],
                                         range: (2, 0)-(2, 7))),
                        .heading(Heading(level: 4,
                                         text: [
                                            .text(InlineString(text: "foo", range: (3,5)-(3,7)))
                                         ],
                                         range: (3, 0)-(3, 8))),
                        .heading(Heading(level: 5,
                                         text: [
                                            .text(InlineString(text: "foo", range: (4,6)-(4,8)))
                                         ],
                                         range: (4, 0)-(4, 9))),
                        .heading(Heading(level: 6,
                                         text: [
                                            .text(InlineString(text: "foo", range: (5,7)-(5,9)))
                                         ],
                                         range: (5, 0)-(5, 10)))
                       ]))
    }
    
    func testCase33() throws {
        // HTML: <p>####### foo</p>\n
        /* Markdown
         ####### foo
         
         */
        XCTAssertEqual(try compile("####### foo\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "####### foo", range: (0,0)-(0,10)))
                        ],
                        range: (0, 0)-(0, 11)))
                       ]))
    }
    
    func testCase34() throws {
        // HTML: <p>#5 bolt</p>\n<p>#hashtag</p>\n
        /* Markdown
         #5 bolt
         
         #hashtag
         
         */
        XCTAssertEqual(try compile("#5 bolt\n\n#hashtag\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "#5 bolt", range: (0,0)-(0,6)))
                        ],
                        range: (0, 0)-(0, 7))),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "#hashtag", range: (2,0)-(2,7)))
                        ],
                        range: (2, 0)-(2, 8)))
                       ]))
    }
    
    func testCase35() throws {
        // HTML: <p>## foo</p>\n
        /* Markdown
         \## foo
         
         */
        XCTAssertEqual(try compile("\\## foo\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "## foo", range: (0,0)-(0,6)))
                        ],
                        range: (0, 0)-(0, 7)))
                       ]))
    }
    
    func testCase36() throws {
        // HTML: <h1>foo <em>bar</em> *baz*</h1>\n
        /* Markdown
         # foo *bar* \*baz\*
         
         */
        XCTAssertEqual(try compile("# foo *bar* \\*baz\\*\n"),
                       Document(elements: [
                        .heading(Heading(level: 1,
                                         text: [
                                            .text(InlineString(text: "foo ", range: (0,2)-(0,5))),
                                            .emphasis(InlineEmphasis(text: [
                                                .text(InlineString(text: "bar", range: (0,7)-(0,9)))
                                            ],
                                            range:(0, 6)-(0, 10))),
                                            .text(InlineString(text: " *baz*", range: (0, 11)-(0, 18)))
                                         ],
                                         range: (0, 0)-(0, 19)))
                       ]))
    }
    
    func testCase37() throws {
        // HTML: <h1>foo</h1>\n
        /* Markdown
         #                  foo
         
         */
        XCTAssertEqual(try compile("#                  foo                     \n"),
                       Document(elements: [
                        .heading(Heading(level: 1,
                                         text: [
                                            .text(InlineString(text: "foo", range: (0,19)-(0,21)))
                                         ],
                                         range: (0, 0)-(0, 43)))
                       ]))
    }
    
    func testCase38() throws {
        // HTML: <h3>foo</h3>\n<h2>foo</h2>\n<h1>foo</h1>\n
        /* Markdown
         ### foo
         ## foo
         # foo
         
         */
        XCTAssertEqual(try compile(" ### foo\n  ## foo\n   # foo\n"),
                       Document(elements: [
                        .heading(Heading(level: 3,
                                         text: [
                                            .text(InlineString(text: "foo", range: (0,5)-(0,7)))
                                         ],
                                         range: (0, 0)-(0, 8))),
                        .heading(Heading(level: 2,
                                         text: [
                                            .text(InlineString(text: "foo", range: (1,5)-(1,7)))
                                         ],
                                         range: (1, 0)-(1, 8))),
                        .heading(Heading(level: 1,
                                         text: [
                                            .text(InlineString(text: "foo", range: (2,5)-(2,7)))
                                         ],
                                         range: (2, 0)-(2, 8)))
                       ]))
    }
    
    func testCase39() throws {
        // HTML: <pre><code># foo\n</code></pre>\n
        /* Markdown
         # foo
         
         */
        XCTAssertEqual(try compile("    # foo\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "", content: "# foo\n", range: (0, 4)-(1, 0)))
                       ]))
    }
    
    func testCase40() throws {
        // HTML: <p>foo\n# bar</p>\n
        /* Markdown
         foo
         # bar
         
         */
        XCTAssertEqual(try compile("foo\n    # bar\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo", range: (0,0)-(0,2))),
                            .softbreak(InlineSoftbreak(range: (0, 3)-(1, 3))),
                            .text(InlineString(text: "# bar", range: (1,4)-(1,8)))
                        ],
                        range: (0, 0)-(1, 9)))
                       ]))
    }
    
    func testCase41() throws {
        // HTML: <h2>foo</h2>\n<h3>bar</h3>\n
        /* Markdown
         ## foo ##
         ###   bar    ###
         
         */
        XCTAssertEqual(try compile("## foo ##\n  ###   bar    ###\n"),
                       Document(elements: [
                        .heading(Heading(level: 2,
                                         text: [
                                            .text(InlineString(text: "foo", range: (0,3)-(0,5)))
                                         ],
                                         range: (0, 0)-(0, 9))),
                        .heading(Heading(level: 3,
                                         text: [
                                            .text(InlineString(text: "bar", range: (1,8)-(1,10)))
                                         ],
                                         range: (1, 0)-(1, 18)))
                       ]))
    }
    
    func testCase42() throws {
        // HTML: <h1>foo</h1>\n<h5>foo</h5>\n
        /* Markdown
         # foo ##################################
         ##### foo ##
         
         */
        XCTAssertEqual(try compile("# foo ##################################\n##### foo ##\n"),
                       Document(elements: [
                        .heading(Heading(level: 1,
                                         text: [
                                            .text(InlineString(text: "foo", range: (0,2)-(0,4)))
                                         ],
                                         range: (0, 0)-(0, 40))),
                        .heading(Heading(level: 5,
                                         text: [
                                            .text(InlineString(text: "foo", range: (1,6)-(1,8)))
                                         ],
                                         range: (1, 0)-(1, 12)))
                       ]))
    }
    
    func testCase43() throws {
        // HTML: <h3>foo</h3>\n
        /* Markdown
         ### foo ###
         
         */
        XCTAssertEqual(try compile("### foo ###     \n"),
                       Document(elements: [
                        .heading(Heading(level: 3,
                                         text: [
                                            .text(InlineString(text: "foo", range: (0,4)-(0,6)))
                                         ],
                                         range: (0, 0)-(0, 16)))
                       ]))
    }
    
    func testCase44() throws {
        // HTML: <h3>foo ### b</h3>\n
        /* Markdown
         ### foo ### b
         
         */
        XCTAssertEqual(try compile("### foo ### b\n"),
                       Document(elements: [
                        .heading(Heading(level: 3,
                                         text: [
                                            .text(InlineString(text: "foo ### b", range: (0,4)-(0,12)))
                                         ],
                                         range: (0, 0)-(0, 13)))
                       ]))
    }
    
    func testCase45() throws {
        // HTML: <h1>foo#</h1>\n
        /* Markdown
         # foo#
         
         */
        XCTAssertEqual(try compile("# foo#\n"),
                       Document(elements: [
                        .heading(Heading(level: 1,
                                         text: [
                                            .text(InlineString(text: "foo#", range: (0,2)-(0,5)))
                                         ],
                                         range: (0, 0)-(0, 6)))
                       ]))
    }
    
    func testCase46() throws {
        // HTML: <h3>foo ###</h3>\n<h2>foo ###</h2>\n<h1>foo #</h1>\n
        /* Markdown
         ### foo \###
         ## foo #\##
         # foo \#
         
         */
        XCTAssertEqual(try compile("### foo \\###\n## foo #\\##\n# foo \\#\n"),
                       Document(elements: [
                        .heading(Heading(level: 3,
                                         text: [
                                            .text(InlineString(text: "foo ###", range: (0, 4)-(0, 11)))
                                         ],
                                         range: (0, 0)-(0, 12))),
                        .heading(Heading(level: 2,
                                         text: [
                                            .text(InlineString(text: "foo ###", range: (1, 3)-(1, 10)))
                                         ],
                                         range: (1, 0)-(1, 11))),
                        .heading(Heading(level: 1,
                                         text: [
                                            .text(InlineString(text: "foo #", range: (2,2)-(2,7)))
                                         ],
                                         range: (2, 0)-(2, 8)))
                       ]))
    }
    
    func testCase47() throws {
        // HTML: <hr />\n<h2>foo</h2>\n<hr />\n
        /* Markdown
         ****
         ## foo
         ****
         
         */
        XCTAssertEqual(try compile("****\n## foo\n****\n"),
                       Document(elements: [
                        .thematicBreak(ThematicBreak(range: (0, 0)-(0, 4))),
                        .heading(Heading(level: 2,
                                         text: [
                                            .text(InlineString(text: "foo", range: (1,3)-(1,5)))
                                         ],
                                         range: (1, 0)-(1, 6))),
                        .thematicBreak(ThematicBreak(range: (2, 0)-(2, 4)))
                       ]))
    }
    
    func testCase48() throws {
        // HTML: <p>Foo bar</p>\n<h1>baz</h1>\n<p>Bar foo</p>\n
        /* Markdown
         Foo bar
         # baz
         Bar foo
         
         */
        XCTAssertEqual(try compile("Foo bar\n# baz\nBar foo\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "Foo bar", range: (0,0)-(0,6)))
                        ],
                        range: (0, 0)-(0, 7))),
                        .heading(Heading(level: 1,
                                         text: [
                                            .text(InlineString(text: "baz", range: (1,2)-(1,4)))
                                         ],
                                         range: (1, 0)-(1, 5))),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "Bar foo", range: (2,0)-(2,6)))
                        ],
                        range: (2, 0)-(2, 7)))
                       ]))
    }
    
    func testCase49() throws {
        // HTML: <h2></h2>\n<h1></h1>\n<h3></h3>\n
        /* Markdown
         ##
         #
         ### ###
         
         */
        XCTAssertEqual(try compile("## \n#\n### ###\n"),
                       Document(elements: [
                        .heading(Heading(level: 2,
                                         text: [
                                            
                                         ],
                                         range: (0, 0)-(0, 3))),
                        .heading(Heading(level: 1,
                                         text: [
                                            
                                         ],
                                         range: (1, 0)-(1, 1))),
                        .heading(Heading(level: 3,
                                         text: [
                                            
                                         ],
                                         range: (2, 0)-(2, 7)))
                       ]))
    }
    
    
}
