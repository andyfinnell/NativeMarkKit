import Foundation
import XCTest
@testable import NativeMarkKit

final class AutolinksTest: XCTestCase {
    func testCase590() throws {
        // HTML: <p><a href=\"http://foo.bar.baz\">http://foo.bar.baz</a></p>\n
        /* Markdown
         <http://foo.bar.baz>
         
         */
        XCTAssertEqual(try compile("<http://foo.bar.baz>\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "http://foo.bar.baz", range: (0, 1)-(0, 18))),
                                             text: [
                                                .text(InlineString(text: "http://foo.bar.baz", range: (0,1)-(0,18)))
                                             ],
                                             range: (0, 0)-(0, 19)))
                        ],
                        range: (0, 0)-(0, 20)))
                       ]))
    }
    
    func testCase591() throws {
        // HTML: <p><a href=\"http://foo.bar.baz/test?q=hello&amp;id=22&amp;boolean\">http://foo.bar.baz/test?q=hello&amp;id=22&amp;boolean</a></p>\n
        /* Markdown
         <http://foo.bar.baz/test?q=hello&id=22&boolean>
         
         */
        XCTAssertEqual(try compile("<http://foo.bar.baz/test?q=hello&id=22&boolean>\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "http://foo.bar.baz/test?q=hello&id=22&boolean", range: (0, 1)-(0, 45))),
                                             text: [
                                                .text(InlineString(text: "http://foo.bar.baz/test?q=hello&id=22&boolean", range: (0,1)-(0,45)))
                                             ],
                                             range: (0, 0)-(0, 46)))
                        ],
                        range: (0, 0)-(0, 47)))
                       ]))
    }
    
    func testCase592() throws {
        // HTML: <p><a href=\"irc://foo.bar:2233/baz\">irc://foo.bar:2233/baz</a></p>\n
        /* Markdown
         <irc://foo.bar:2233/baz>
         
         */
        XCTAssertEqual(try compile("<irc://foo.bar:2233/baz>\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "irc://foo.bar:2233/baz", range: (0, 1)-(0, 22))),
                                             text: [
                                                .text(InlineString(text: "irc://foo.bar:2233/baz", range: (0,1)-(0,22)))
                                             ],
                                             range: (0, 0)-(0, 23)))
                        ],
                        range: (0, 0)-(0, 24)))
                       ]))
    }
    
    func testCase593() throws {
        // HTML: <p><a href=\"MAILTO:FOO@BAR.BAZ\">MAILTO:FOO@BAR.BAZ</a></p>\n
        /* Markdown
         <MAILTO:FOO@BAR.BAZ>
         
         */
        XCTAssertEqual(try compile("<MAILTO:FOO@BAR.BAZ>\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "MAILTO:FOO@BAR.BAZ", range: (0, 1)-(0, 18))),
                                             text: [
                                                .text(InlineString(text: "MAILTO:FOO@BAR.BAZ", range: (0,1)-(0,18)))
                                             ],
                                             range: (0, 0)-(0, 19)))
                        ],
                        range: (0, 0)-(0, 20)))
                       ]))
    }
    
    func testCase594() throws {
        // HTML: <p><a href=\"a+b+c:d\">a+b+c:d</a></p>\n
        /* Markdown
         <a+b+c:d>
         
         */
        XCTAssertEqual(try compile("<a+b+c:d>\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "a+b+c:d", range: (0, 1)-(0, 7))),
                                             text: [
                                                .text(InlineString(text: "a+b+c:d", range: (0,1)-(0,7)))
                                             ],
                                             range: (0, 0)-(0, 8)))
                        ],
                        range: (0, 0)-(0, 9)))
                       ]))
    }
    
    func testCase595() throws {
        // HTML: <p><a href=\"made-up-scheme://foo,bar\">made-up-scheme://foo,bar</a></p>\n
        /* Markdown
         <made-up-scheme://foo,bar>
         
         */
        XCTAssertEqual(try compile("<made-up-scheme://foo,bar>\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "made-up-scheme://foo,bar", range: (0, 1)-(0, 24))),
                                             text: [
                                                .text(InlineString(text: "made-up-scheme://foo,bar", range: (0,1)-(0,24)))
                                             ],
                                             range: (0, 0)-(0, 25)))
                        ],
                        range: (0, 0)-(0, 26)))
                       ]))
    }
    
    func testCase596() throws {
        // HTML: <p><a href=\"http://../\">http://../</a></p>\n
        /* Markdown
         <http://../>
         
         */
        XCTAssertEqual(try compile("<http://../>\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "http://../", range: (0, 1)-(0, 10))),
                                             text: [
                                                .text(InlineString(text: "http://../", range: (0,1)-(0,10)))
                                             ],
                                             range: (0, 0)-(0, 11)))
                        ],
                        range: (0, 0)-(0, 12)))
                       ]))
    }
    
    func testCase597() throws {
        // HTML: <p><a href=\"localhost:5001/foo\">localhost:5001/foo</a></p>\n
        /* Markdown
         <localhost:5001/foo>
         
         */
        XCTAssertEqual(try compile("<localhost:5001/foo>\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "localhost:5001/foo", range: (0, 1)-(0, 18))),
                                             text: [
                                                .text(InlineString(text: "localhost:5001/foo", range: (0,1)-(0,18)))
                                             ],
                                             range: (0, 0)-(0, 19)))
                        ],
                        range: (0, 0)-(0, 20)))
                       ]))
    }
    
    func testCase598() throws {
        // HTML: <p>&lt;http://foo.bar/baz bim&gt;</p>\n
        /* Markdown
         <http://foo.bar/baz bim>
         
         */
        XCTAssertEqual(try compile("<http://foo.bar/baz bim>\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "<http://foo.bar/baz bim>", range: (0,0)-(0,23)))
                        ],
                        range: (0, 0)-(0, 24)))
                       ]))
    }
    
    func testCase599() throws {
        // HTML: <p><a href=\"http://example.com/%5C%5B%5C\">http://example.com/\\[\\</a></p>\n
        /* Markdown
         <http://example.com/\[\>
         
         */
        XCTAssertEqual(try compile("<http://example.com/\\[\\>\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "http://example.com/\\[\\", range: (0, 1)-(0, 22))),
                                             text: [
                                                .text(InlineString(text: "http://example.com/\\[\\", range: (0,1)-(0,22)))
                                             ],
                                             range: (0, 0)-(0, 23)))
                        ],
                        range: (0, 0)-(0, 24)))
                       ]))
    }
    
    func testCase600() throws {
        // HTML: <p><a href=\"mailto:foo@bar.example.com\">foo@bar.example.com</a></p>\n
        /* Markdown
         <foo@bar.example.com>
         
         */
        XCTAssertEqual(try compile("<foo@bar.example.com>\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "mailto:foo@bar.example.com", range: (0, 1)-(0, 19))),
                                             text: [
                                                .text(InlineString(text: "foo@bar.example.com", range: (0,1)-(0,19)))
                                             ],
                                             range: (0, 0)-(0, 20)))
                        ],
                        range: (0, 0)-(0, 21)))
                       ]))
    }
    
    func testCase601() throws {
        // HTML: <p><a href=\"mailto:foo+special@Bar.baz-bar0.com\">foo+special@Bar.baz-bar0.com</a></p>\n
        /* Markdown
         <foo+special@Bar.baz-bar0.com>
         
         */
        XCTAssertEqual(try compile("<foo+special@Bar.baz-bar0.com>\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "mailto:foo+special@Bar.baz-bar0.com", range: (0, 1)-(0, 28))),
                                             text: [
                                                .text(InlineString(text: "foo+special@Bar.baz-bar0.com", range: (0,1)-(0,28)))
                                             ],
                                             range: (0, 0)-(0, 29)))
                        ],
                        range: (0, 0)-(0, 30)))
                       ]))
    }
    
    func testCase602() throws {
        // HTML: <p>&lt;foo+@bar.example.com&gt;</p>\n
        /* Markdown
         <foo\+@bar.example.com>
         
         */
        XCTAssertEqual(try compile("<foo\\+@bar.example.com>\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "<foo+@bar.example.com>", range: (0, 0)-(0, 22)))
                        ],
                        range: (0, 0)-(0, 23)))
                       ]))
    }
    
    func testCase603() throws {
        // HTML: <p>&lt;&gt;</p>\n
        /* Markdown
         <>
         
         */
        XCTAssertEqual(try compile("<>\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "<>", range: (0,0)-(0,1)))
                        ],
                        range: (0, 0)-(0, 2)))
                       ]))
    }
    
    func testCase604() throws {
        // HTML: <p>&lt; http://foo.bar &gt;</p>\n
        /* Markdown
         < http://foo.bar >
         
         */
        XCTAssertEqual(try compile("< http://foo.bar >\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "< http://foo.bar >", range: (0,0)-(0,17)))
                        ],
                        range: (0, 0)-(0, 18)))
                       ]))
    }
    
    func testCase605() throws {
        // HTML: <p>&lt;m:abc&gt;</p>\n
        /* Markdown
         <m:abc>
         
         */
        XCTAssertEqual(try compile("<m:abc>\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "<m:abc>", range: (0,0)-(0,6)))
                        ],
                        range: (0, 0)-(0, 7)))
                       ]))
    }
    
    func testCase606() throws {
        // HTML: <p>&lt;foo.bar.baz&gt;</p>\n
        /* Markdown
         <foo.bar.baz>
         
         */
        XCTAssertEqual(try compile("<foo.bar.baz>\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "<foo.bar.baz>", range: (0,0)-(0,12)))
                        ],
                        range: (0, 0)-(0, 13)))
                       ]))
    }
    
    func testCase607() throws {
        // HTML: <p>http://example.com</p>\n
        /* Markdown
         http://example.com
         
         */
        XCTAssertEqual(try compile("http://example.com\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "http://example.com", range: (0,0)-(0,17)))
                        ],
                        range: (0, 0)-(0, 18)))
                       ]))
    }
    
    func testCase608() throws {
        // HTML: <p>foo@bar.example.com</p>\n
        /* Markdown
         foo@bar.example.com
         
         */
        XCTAssertEqual(try compile("foo@bar.example.com\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo@bar.example.com", range: (0,0)-(0,18)))
                        ],
                        range: (0, 0)-(0, 19)))
                       ]))
    }
    
    
}
