import Foundation
import XCTest
@testable import NativeMarkKit

final class RawhtmlTest: XCTestCase {

    func testCase614() throws {
        // HTML: <p>&lt;33&gt; &lt;__&gt;</p>\n
        // Debug: <p>&lt;33&gt; &lt;__&gt;</p>\n
        XCTAssertEqual(try compile("<33> <__>\n"),
                       Document(elements: [.paragraph([.text("<33> <__>")])]))
    }

    func testCase618() throws {
        // HTML: <p>&lt;a href='bar'title=title&gt;</p>\n
        // Debug: <p>&lt;a href='bar'title=title&gt;</p>\n
        XCTAssertEqual(try compile("<a href='bar'title=title>\n"),
                       Document(elements: [.paragraph([.text("<a href='bar'title=title>")])]))
    }

    func testCase621() throws {
        // HTML: <p>foo <!-- this is a\ncomment - with hyphen --></p>\n
        // Debug: <p>foo <!-- this is a\ncomment - with hyphen --></p>\n
        XCTAssertEqual(try compile("foo <!-- this is a\ncomment - with hyphen -->\n"),
                       Document(elements: [.paragraph([.text("foo <!– this is a"), .softbreak, .text("comment - with hyphen –>")])]))
    }

    func testCase622() throws {
        // HTML: <p>foo &lt;!-- not a comment -- two hyphens --&gt;</p>\n
        // Debug: <p>foo &lt;!-- not a comment -- two hyphens --&gt;</p>\n
        XCTAssertEqual(try compile("foo <!-- not a comment -- two hyphens -->\n"),
                       Document(elements: [.paragraph([.text("foo <!– not a comment – two hyphens –>")])]))
    }

    func testCase623() throws {
        // HTML: <p>foo &lt;!--&gt; foo --&gt;</p>\n<p>foo &lt;!-- foo---&gt;</p>\n
        // Debug: <p>foo &lt;!--&gt; foo --&gt;</p>\n<p>foo &lt;!-- foo---&gt;</p>\n
        XCTAssertEqual(try compile("foo <!--> foo -->\n\nfoo <!-- foo--->\n"),
                       Document(elements: [.paragraph([.text("foo <!–> foo –>")]), .paragraph([.text("foo <!– foo—>")])]))
    }

    func testCase624() throws {
        // HTML: <p>foo <?php echo $a; ?></p>\n
        // Debug: <p>foo <?php echo $a; ?></p>\n
        XCTAssertEqual(try compile("foo <?php echo $a; ?>\n"),
                       Document(elements: [.paragraph([.text("foo <?php echo $a; ?>")])]))
    }

    func testCase625() throws {
        // HTML: <p>foo <!ELEMENT br EMPTY></p>\n
        // Debug: <p>foo <!ELEMENT br EMPTY></p>\n
        XCTAssertEqual(try compile("foo <!ELEMENT br EMPTY>\n"),
                       Document(elements: [.paragraph([.text("foo <!ELEMENT br EMPTY>")])]))
    }

    func testCase626() throws {
        // HTML: <p>foo <![CDATA[>&<]]></p>\n
        // Debug: <p>foo <![CDATA[>&<]]></p>\n
        XCTAssertEqual(try compile("foo <![CDATA[>&<]]>\n"),
                       Document(elements: [.paragraph([.text("foo <![CDATA[>&<]]>")])]))
    }

    
}
