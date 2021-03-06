import Foundation
import XCTest
@testable import NativeMarkKit

final class AutolinksTest: XCTestCase {
    func testCase590() throws {
        // HTML: <p><a href=\"http://foo.bar.baz\">http://foo.bar.baz</a></p>\n
        // Debug: <p><a href=\"http://foo.bar.baz\">http://foo.bar.baz</a></p>\n
        XCTAssertEqual(try compile("<http://foo.bar.baz>\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "http://foo.bar.baz"), text: [.text("http://foo.bar.baz")])])]))
    }

    func testCase591() throws {
        // HTML: <p><a href=\"http://foo.bar.baz/test?q=hello&amp;id=22&amp;boolean\">http://foo.bar.baz/test?q=hello&amp;id=22&amp;boolean</a></p>\n
        // Debug: <p><a href=\"http://foo.bar.baz/test?q=hello&amp;id=22&amp;boolean\">http://foo.bar.baz/test?q=hello&amp;id=22&amp;boolean</a></p>\n
        XCTAssertEqual(try compile("<http://foo.bar.baz/test?q=hello&id=22&boolean>\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "http://foo.bar.baz/test?q=hello&id=22&boolean"), text: [.text("http://foo.bar.baz/test?q=hello&id=22&boolean")])])]))
    }

    func testCase592() throws {
        // HTML: <p><a href=\"irc://foo.bar:2233/baz\">irc://foo.bar:2233/baz</a></p>\n
        // Debug: <p><a href=\"irc://foo.bar:2233/baz\">irc://foo.bar:2233/baz</a></p>\n
        XCTAssertEqual(try compile("<irc://foo.bar:2233/baz>\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "irc://foo.bar:2233/baz"), text: [.text("irc://foo.bar:2233/baz")])])]))
    }

    func testCase593() throws {
        // HTML: <p><a href=\"MAILTO:FOO@BAR.BAZ\">MAILTO:FOO@BAR.BAZ</a></p>\n
        // Debug: <p><a href=\"MAILTO:FOO@BAR.BAZ\">MAILTO:FOO@BAR.BAZ</a></p>\n
        XCTAssertEqual(try compile("<MAILTO:FOO@BAR.BAZ>\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "MAILTO:FOO@BAR.BAZ"), text: [.text("MAILTO:FOO@BAR.BAZ")])])]))
    }

    func testCase594() throws {
        // HTML: <p><a href=\"a+b+c:d\">a+b+c:d</a></p>\n
        // Debug: <p><a href=\"a+b+c:d\">a+b+c:d</a></p>\n
        XCTAssertEqual(try compile("<a+b+c:d>\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "a+b+c:d"), text: [.text("a+b+c:d")])])]))
    }

    func testCase595() throws {
        // HTML: <p><a href=\"made-up-scheme://foo,bar\">made-up-scheme://foo,bar</a></p>\n
        // Debug: <p><a href=\"made-up-scheme://foo,bar\">made-up-scheme://foo,bar</a></p>\n
        XCTAssertEqual(try compile("<made-up-scheme://foo,bar>\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "made-up-scheme://foo,bar"), text: [.text("made-up-scheme://foo,bar")])])]))
    }

    func testCase596() throws {
        // HTML: <p><a href=\"http://../\">http://../</a></p>\n
        // Debug: <p><a href=\"http://../\">http://../</a></p>\n
        XCTAssertEqual(try compile("<http://../>\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "http://../"), text: [.text("http://../")])])]))
    }

    func testCase597() throws {
        // HTML: <p><a href=\"localhost:5001/foo\">localhost:5001/foo</a></p>\n
        // Debug: <p><a href=\"localhost:5001/foo\">localhost:5001/foo</a></p>\n
        XCTAssertEqual(try compile("<localhost:5001/foo>\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "localhost:5001/foo"), text: [.text("localhost:5001/foo")])])]))
    }

    func testCase598() throws {
        // HTML: <p>&lt;http://foo.bar/baz bim&gt;</p>\n
        // Debug: <p>&lt;http://foo.bar/baz bim&gt;</p>\n
        XCTAssertEqual(try compile("<http://foo.bar/baz bim>\n"),
                       Document(elements: [.paragraph([.text("<http://foo.bar/baz bim>")])]))
    }

    func testCase599() throws {
        // HTML: <p><a href=\"http://example.com/%5C%5B%5C\">http://example.com/\\[\\</a></p>\n
        // Debug: <p><a href=\"http://example.com/%5C%5B%5C\">http://example.com/\\[\\</a></p>\n
        XCTAssertEqual(try compile("<http://example.com/\\[\\>\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "http://example.com/\\[\\"), text: [.text("http://example.com/\\[\\")])])]))
    }

    func testCase600() throws {
        // HTML: <p><a href=\"mailto:foo@bar.example.com\">foo@bar.example.com</a></p>\n
        // Debug: <p><a href=\"mailto:foo@bar.example.com\">foo@bar.example.com</a></p>\n
        XCTAssertEqual(try compile("<foo@bar.example.com>\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "mailto:foo@bar.example.com"), text: [.text("foo@bar.example.com")])])]))
    }

    func testCase601() throws {
        // HTML: <p><a href=\"mailto:foo+special@Bar.baz-bar0.com\">foo+special@Bar.baz-bar0.com</a></p>\n
        // Debug: <p><a href=\"mailto:foo+special@Bar.baz-bar0.com\">foo+special@Bar.baz-bar0.com</a></p>\n
        XCTAssertEqual(try compile("<foo+special@Bar.baz-bar0.com>\n"),
                       Document(elements: [.paragraph([.link(Link(title: "", url: "mailto:foo+special@Bar.baz-bar0.com"), text: [.text("foo+special@Bar.baz-bar0.com")])])]))
    }

    func testCase602() throws {
        // HTML: <p>&lt;foo+@bar.example.com&gt;</p>\n
        // Debug: <p>&lt;foo+@bar.example.com&gt;</p>\n
        XCTAssertEqual(try compile("<foo\\+@bar.example.com>\n"),
                       Document(elements: [.paragraph([.text("<foo+@bar.example.com>")])]))
    }

    func testCase603() throws {
        // HTML: <p>&lt;&gt;</p>\n
        // Debug: <p>&lt;&gt;</p>\n
        XCTAssertEqual(try compile("<>\n"),
                       Document(elements: [.paragraph([.text("<>")])]))
    }

    func testCase604() throws {
        // HTML: <p>&lt; http://foo.bar &gt;</p>\n
        // Debug: <p>&lt; http://foo.bar &gt;</p>\n
        XCTAssertEqual(try compile("< http://foo.bar >\n"),
                       Document(elements: [.paragraph([.text("< http://foo.bar >")])]))
    }

    func testCase605() throws {
        // HTML: <p>&lt;m:abc&gt;</p>\n
        // Debug: <p>&lt;m:abc&gt;</p>\n
        XCTAssertEqual(try compile("<m:abc>\n"),
                       Document(elements: [.paragraph([.text("<m:abc>")])]))
    }

    func testCase606() throws {
        // HTML: <p>&lt;foo.bar.baz&gt;</p>\n
        // Debug: <p>&lt;foo.bar.baz&gt;</p>\n
        XCTAssertEqual(try compile("<foo.bar.baz>\n"),
                       Document(elements: [.paragraph([.text("<foo.bar.baz>")])]))
    }

    func testCase607() throws {
        // HTML: <p>http://example.com</p>\n
        // Debug: <p>http://example.com</p>\n
        XCTAssertEqual(try compile("http://example.com\n"),
                       Document(elements: [.paragraph([.text("http://example.com")])]))
    }

    func testCase608() throws {
        // HTML: <p>foo@bar.example.com</p>\n
        // Debug: <p>foo@bar.example.com</p>\n
        XCTAssertEqual(try compile("foo@bar.example.com\n"),
                       Document(elements: [.paragraph([.text("foo@bar.example.com")])]))
    }

    
}
