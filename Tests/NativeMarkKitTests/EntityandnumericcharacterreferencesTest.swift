import Foundation
import XCTest
@testable import NativeMarkKit

final class EntityandnumericcharacterreferencesTest: XCTestCase {
    func testCase311() throws {
        // HTML: <p>  &amp; © Æ Ď\n¾ ℋ ⅆ\n∲ ≧̸</p>\n
        // Debug: <p>  &amp; © Æ Ď\n¾ ℋ ⅆ\n∲ ≧̸</p>\n
        XCTAssertEqual(try compile("&nbsp; &amp; &copy; &AElig; &Dcaron;\n&frac34; &HilbertSpace; &DifferentialD;\n&ClockwiseContourIntegral; &ngE;\n"),
                       Document(elements: [.paragraph([.text("  & © Æ Ď"), .softbreak, .text("¾ ℋ ⅆ"), .softbreak, .text("∲ ≧̸")])]))
    }

    func testCase312() throws {
        // HTML: <p># Ӓ Ϡ �</p>\n
        // Debug: <p># Ӓ Ϡ �</p>\n
        XCTAssertEqual(try compile("&#35; &#1234; &#992; &#0;\n"),
                       Document(elements: [.paragraph([.text("# Ӓ Ϡ ")])]))
    }

    func testCase313() throws {
        // HTML: <p>&quot; ആ ಫ</p>\n
        // Debug: <p>&quot; ആ ಫ</p>\n
        XCTAssertEqual(try compile("&#X22; &#XD06; &#xcab;\n"),
                       Document(elements: [.paragraph([.text("\" ആ ಫ")])]))
    }

    func testCase314() throws {
        // HTML: <p>&amp;nbsp &amp;x; &amp;#; &amp;#x;\n&amp;#987654321;\n&amp;#abcdef0;\n&amp;ThisIsNotDefined; &amp;hi?;</p>\n
        // Debug: <p>&amp;nbsp &amp;x; &amp;#; &amp;#x;\n&amp;#987654321;\n&amp;#abcdef0;\n&amp;ThisIsNotDefined; &amp;hi?;</p>\n
        XCTAssertEqual(try compile("&nbsp &x; &#; &#x;\n&#987654321;\n&#abcdef0;\n&ThisIsNotDefined; &hi?;\n"),
                       Document(elements: [.paragraph([.text("&nbsp &x; &#; &#x;"), .softbreak, .text("&#987654321;"), .softbreak, .text("&#abcdef0;"), .softbreak, .text("&ThisIsNotDefined; &hi?;")])]))
    }

    func testCase315() throws {
        // HTML: <p>&amp;copy</p>\n
        // Debug: <p>&amp;copy</p>\n
        XCTAssertEqual(try compile("&copy\n"),
                       Document(elements: [.paragraph([.text("&copy")])]))
    }

    func testCase316() throws {
        // HTML: <p>&amp;MadeUpEntity;</p>\n
        // Debug: <p>&amp;MadeUpEntity;</p>\n
        XCTAssertEqual(try compile("&MadeUpEntity;\n"),
                       Document(elements: [.paragraph([.text("&MadeUpEntity;")])]))
    }

    func testCase317() throws {
        // Input: <a href=\"&ouml;&ouml;.html\">\n
        // HTML: <a href=\"&ouml;&ouml;.html\">\n
         XCTAssertEqual(try compile("<a href=\"&ouml;&ouml;.html\">\n"),
                        Document(elements: [.paragraph([.text("<a href=”öö.html\">")])]))
    }

    func testCase318() throws {
        // HTML: <p><a href=\"/f%C3%B6%C3%B6\" title=\"föö\">foo</a></p>\n
        // Debug: <p><a href=\"/f%C3%B6%C3%B6\" title=\"föö\">foo</a></p>\n
        XCTAssertEqual(try compile("[foo](/f&ouml;&ouml; \"f&ouml;&ouml;\")\n"),
                       Document(elements: [.paragraph([.link(Link(title: "föö", url: "/föö"), text: [.text("foo")])])]))
    }

    func testCase319() throws {
        // HTML: <p><a href=\"/f%C3%B6%C3%B6\" title=\"föö\">foo</a></p>\n
        // Debug: <p><a href=\"/f%C3%B6%C3%B6\" title=\"föö\">foo</a></p>\n
        XCTAssertEqual(try compile("[foo]\n\n[foo]: /f&ouml;&ouml; \"f&ouml;&ouml;\"\n"),
                       Document(elements: [.paragraph([.link(Link(title: "föö", url: "/föö"), text: [.text("foo")])])]))
    }

    func testCase320() throws {
        // HTML: <pre><code class=\"language-föö\">foo\n</code></pre>\n
        // Debug: <pre><code class=\"language-föö\">foo\n</code></pre>\n
        XCTAssertEqual(try compile("``` f&ouml;&ouml;\nfoo\n```\n"),
                       Document(elements: [.codeBlock(infoString: "föö", content: "foo\n")]))
    }

    func testCase321() throws {
        // HTML: <p><code>f&amp;ouml;&amp;ouml;</code></p>\n
        // Debug: <p><code>f&amp;ouml;&amp;ouml;</code></p>\n
        XCTAssertEqual(try compile("`f&ouml;&ouml;`\n"),
                       Document(elements: [.paragraph([.code("f&ouml;&ouml;")])]))
    }

    func testCase322() throws {
        // HTML: <pre><code>f&amp;ouml;f&amp;ouml;\n</code></pre>\n
        // Debug: <pre><code>f&amp;ouml;f&amp;ouml;\n</code></pre>\n
        XCTAssertEqual(try compile("    f&ouml;f&ouml;\n"),
                       Document(elements: [.codeBlock(infoString: "", content: "f&ouml;f&ouml;\n")]))
    }

    func testCase323() throws {
        // HTML: <p>*foo*\n<em>foo</em></p>\n
        // Debug: <p>*foo*\n<em>foo</em></p>\n
        XCTAssertEqual(try compile("&#42;foo&#42;\n*foo*\n"),
                       Document(elements: [.paragraph([.text("*foo*"), .softbreak, .emphasis([.text("foo")])])]))
    }

    func testCase324() throws {
        // HTML: <p>* foo</p>\n<ul>\n<li>foo</li>\n</ul>\n
        // Debug: <p>* foo</p>\n<ul>\n<li>{foo caused p to open}foo{debug: implicitly closing p}</li>\n</ul>\n
        XCTAssertEqual(try compile("&#42; foo\n\n* foo\n"),
                       Document(elements: [.paragraph([.text("* foo")]), .list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("foo")])])])]))
    }

    func testCase325() throws {
        // HTML: <p>foo\n\nbar</p>\n
        // Debug: <p>foo\n\nbar</p>\n
        XCTAssertEqual(try compile("foo&#10;&#10;bar\n"),
                       Document(elements: [.paragraph([.text("foo\n\nbar")])]))
    }

    func testCase326() throws {
        // HTML: <p>\tfoo</p>\n
        // Debug: <p>\tfoo</p>\n
        XCTAssertEqual(try compile("&#9;foo\n"),
                       Document(elements: [.paragraph([.text("\tfoo")])]))
    }

    func testCase327() throws {
        // HTML: <p>[a](url &quot;tit&quot;)</p>\n
        // Debug: <p>[a](url &quot;tit&quot;)</p>\n
        XCTAssertEqual(try compile("[a](url &quot;tit&quot;)\n"),
                       Document(elements: [.paragraph([.text("[a](url \"tit\")")])]))
    }

    
}
