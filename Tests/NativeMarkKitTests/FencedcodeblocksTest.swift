import Foundation
import XCTest
@testable import NativeMarkKit

final class FencedcodeblocksTest: XCTestCase {
    func testCase89() throws {
        // HTML: <pre><code>&lt;\n &gt;\n</code></pre>\n
        // Debug: <pre><code>&lt;\n &gt;\n</code></pre>\n
        XCTAssertEqual(try compile("```\n<\n >\n```\n"),
                       Document(elements: [.codeBlock(infoString: "", content: "<\n >\n")]))
    }

    func testCase90() throws {
        // HTML: <pre><code>&lt;\n &gt;\n</code></pre>\n
        // Debug: <pre><code>&lt;\n &gt;\n</code></pre>\n
        XCTAssertEqual(try compile("~~~\n<\n >\n~~~\n"),
                       Document(elements: [.codeBlock(infoString: "", content: "<\n >\n")]))
    }

    func testCase91() throws {
        // HTML: <p><code>foo</code></p>\n
        // Debug: <p><code>foo</code></p>\n
        XCTAssertEqual(try compile("``\nfoo\n``\n"),
                       Document(elements: [.paragraph([.code("foo")])]))
    }

    func testCase92() throws {
        // HTML: <pre><code>aaa\n~~~\n</code></pre>\n
        // Debug: <pre><code>aaa\n~~~\n</code></pre>\n
        XCTAssertEqual(try compile("```\naaa\n~~~\n```\n"),
                       Document(elements: [.codeBlock(infoString: "", content: "aaa\n~~~\n")]))
    }

    func testCase93() throws {
        // HTML: <pre><code>aaa\n```\n</code></pre>\n
        // Debug: <pre><code>aaa\n```\n</code></pre>\n
        XCTAssertEqual(try compile("~~~\naaa\n```\n~~~\n"),
                       Document(elements: [.codeBlock(infoString: "", content: "aaa\n```\n")]))
    }

    func testCase94() throws {
        // HTML: <pre><code>aaa\n```\n</code></pre>\n
        // Debug: <pre><code>aaa\n```\n</code></pre>\n
        XCTAssertEqual(try compile("````\naaa\n```\n``````\n"),
                       Document(elements: [.codeBlock(infoString: "", content: "aaa\n```\n")]))
    }

    func testCase95() throws {
        // HTML: <pre><code>aaa\n~~~\n</code></pre>\n
        // Debug: <pre><code>aaa\n~~~\n</code></pre>\n
        XCTAssertEqual(try compile("~~~~\naaa\n~~~\n~~~~\n"),
                       Document(elements: [.codeBlock(infoString: "", content: "aaa\n~~~\n")]))
    }

    func testCase96() throws {
        // HTML: <pre><code></code></pre>\n
        // Debug: <pre><code></code></pre>\n
        XCTAssertEqual(try compile("```\n"),
                       Document(elements: [.codeBlock(infoString: "", content: "")]))
    }

    func testCase97() throws {
        // HTML: <pre><code>\n```\naaa\n</code></pre>\n
        // Debug: <pre><code>\n```\naaa\n</code></pre>\n
        XCTAssertEqual(try compile("`````\n\n```\naaa\n"),
                       Document(elements: [.codeBlock(infoString: "", content: "\n```\naaa\n")]))
    }

    func testCase98() throws {
        // HTML: <blockquote>\n<pre><code>aaa\n</code></pre>\n</blockquote>\n<p>bbb</p>\n
        // Debug: <blockquote>\n<pre><code>aaa\n</code></pre>\n</blockquote>\n<p>bbb</p>\n
        XCTAssertEqual(try compile("> ```\n> aaa\n\nbbb\n"),
                       Document(elements: [.blockQuote([.codeBlock(infoString: "", content: "aaa\n")]), .paragraph([.text("bbb")])]))
    }

    func testCase99() throws {
        // HTML: <pre><code>\n  \n</code></pre>\n
        // Debug: <pre><code>\n  \n</code></pre>\n
        XCTAssertEqual(try compile("```\n\n  \n```\n"),
                       Document(elements: [.codeBlock(infoString: "", content: "\n  \n")]))
    }

    func testCase100() throws {
        // HTML: <pre><code></code></pre>\n
        // Debug: <pre><code></code></pre>\n
        XCTAssertEqual(try compile("```\n```\n"),
                       Document(elements: [.codeBlock(infoString: "", content: "")]))
    }

    func testCase101() throws {
        // HTML: <pre><code>aaa\naaa\n</code></pre>\n
        // Debug: <pre><code>aaa\naaa\n</code></pre>\n
        XCTAssertEqual(try compile(" ```\n aaa\naaa\n```\n"),
                       Document(elements: [.codeBlock(infoString: "", content: "aaa\naaa\n")]))
    }

    func testCase102() throws {
        // HTML: <pre><code>aaa\naaa\naaa\n</code></pre>\n
        // Debug: <pre><code>aaa\naaa\naaa\n</code></pre>\n
        XCTAssertEqual(try compile("  ```\naaa\n  aaa\naaa\n  ```\n"),
                       Document(elements: [.codeBlock(infoString: "", content: "aaa\naaa\naaa\n")]))
    }

    func testCase103() throws {
        // HTML: <pre><code>aaa\n aaa\naaa\n</code></pre>\n
        // Debug: <pre><code>aaa\n aaa\naaa\n</code></pre>\n
        XCTAssertEqual(try compile("   ```\n   aaa\n    aaa\n  aaa\n   ```\n"),
                       Document(elements: [.codeBlock(infoString: "", content: "aaa\n aaa\naaa\n")]))
    }

    func testCase104() throws {
        // HTML: <pre><code>```\naaa\n```\n</code></pre>\n
        // Debug: <pre><code>```\naaa\n```\n</code></pre>\n
        XCTAssertEqual(try compile("    ```\n    aaa\n    ```\n"),
                       Document(elements: [.codeBlock(infoString: "", content: "```\naaa\n```\n")]))
    }

    func testCase105() throws {
        // HTML: <pre><code>aaa\n</code></pre>\n
        // Debug: <pre><code>aaa\n</code></pre>\n
        XCTAssertEqual(try compile("```\naaa\n  ```\n"),
                       Document(elements: [.codeBlock(infoString: "", content: "aaa\n")]))
    }

    func testCase106() throws {
        // HTML: <pre><code>aaa\n</code></pre>\n
        // Debug: <pre><code>aaa\n</code></pre>\n
        XCTAssertEqual(try compile("   ```\naaa\n  ```\n"),
                       Document(elements: [.codeBlock(infoString: "", content: "aaa\n")]))
    }

    func testCase107() throws {
        // HTML: <pre><code>aaa\n    ```\n</code></pre>\n
        // Debug: <pre><code>aaa\n    ```\n</code></pre>\n
        XCTAssertEqual(try compile("```\naaa\n    ```\n"),
                       Document(elements: [.codeBlock(infoString: "", content: "aaa\n    ```\n")]))
    }

    func testCase108() throws {
        // HTML: <p><code> </code>\naaa</p>\n
        // Debug: <p><code> </code>\naaa</p>\n
        XCTAssertEqual(try compile("``` ```\naaa\n"),
                       Document(elements: [.paragraph([.code(" "), .softbreak, .text("aaa")])]))
    }

    func testCase109() throws {
        // HTML: <pre><code>aaa\n~~~ ~~\n</code></pre>\n
        // Debug: <pre><code>aaa\n~~~ ~~\n</code></pre>\n
        XCTAssertEqual(try compile("~~~~~~\naaa\n~~~ ~~\n"),
                       Document(elements: [.codeBlock(infoString: "", content: "aaa\n~~~ ~~\n")]))
    }

    func testCase110() throws {
        // HTML: <p>foo</p>\n<pre><code>bar\n</code></pre>\n<p>baz</p>\n
        // Debug: <p>foo</p>\n<pre><code>bar\n</code></pre>\n<p>baz</p>\n
        XCTAssertEqual(try compile("foo\n```\nbar\n```\nbaz\n"),
                       Document(elements: [.paragraph([.text("foo")]), .codeBlock(infoString: "", content: "bar\n"), .paragraph([.text("baz")])]))
    }

    func testCase111() throws {
        // HTML: <h2>foo</h2>\n<pre><code>bar\n</code></pre>\n<h1>baz</h1>\n
        // Debug: <h2>foo</h2>\n<pre><code>bar\n</code></pre>\n<h1>baz</h1>\n
        XCTAssertEqual(try compile("foo\n---\n~~~\nbar\n~~~\n# baz\n"),
                       Document(elements: [.heading(level: 2, text: [.text("foo")]), .codeBlock(infoString: "", content: "bar\n"), .heading(level: 1, text: [.text("baz")])]))
    }

    func testCase112() throws {
        // HTML: <pre><code class=\"language-ruby\">def foo(x)\n  return 3\nend\n</code></pre>\n
        // Debug: <pre><code class=\"language-ruby\">def foo(x)\n  return 3\nend\n</code></pre>\n
        XCTAssertEqual(try compile("```ruby\ndef foo(x)\n  return 3\nend\n```\n"),
                       Document(elements: [.codeBlock(infoString: "ruby", content: "def foo(x)\n  return 3\nend\n")]))
    }

    func testCase113() throws {
        // HTML: <pre><code class=\"language-ruby\">def foo(x)\n  return 3\nend\n</code></pre>\n
        // Debug: <pre><code class=\"language-ruby\">def foo(x)\n  return 3\nend\n</code></pre>\n
        XCTAssertEqual(try compile("~~~~    ruby startline=3 $%@#$\ndef foo(x)\n  return 3\nend\n~~~~~~~\n"),
                       Document(elements: [.codeBlock(infoString: "ruby", content: "def foo(x)\n  return 3\nend\n")]))
    }

    func testCase114() throws {
        // HTML: <pre><code class=\"language-;\"></code></pre>\n
        // Debug: <pre><code class=\"language-;\"></code></pre>\n
        XCTAssertEqual(try compile("````;\n````\n"),
                       Document(elements: [.codeBlock(infoString: ";", content: "")]))
    }

    func testCase115() throws {
        // HTML: <p><code>aa</code>\nfoo</p>\n
        // Debug: <p><code>aa</code>\nfoo</p>\n
        XCTAssertEqual(try compile("``` aa ```\nfoo\n"),
                       Document(elements: [.paragraph([.code("aa"), .softbreak, .text("foo")])]))
    }

    func testCase116() throws {
        // HTML: <pre><code class=\"language-aa\">foo\n</code></pre>\n
        // Debug: <pre><code class=\"language-aa\">foo\n</code></pre>\n
        XCTAssertEqual(try compile("~~~ aa ``` ~~~\nfoo\n~~~\n"),
                       Document(elements: [.codeBlock(infoString: "aa", content: "foo\n")]))
    }

    func testCase117() throws {
        // HTML: <pre><code>``` aaa\n</code></pre>\n
        // Debug: <pre><code>``` aaa\n</code></pre>\n
        XCTAssertEqual(try compile("```\n``` aaa\n```\n"),
                       Document(elements: [.codeBlock(infoString: "", content: "``` aaa\n")]))
    }

    
}
