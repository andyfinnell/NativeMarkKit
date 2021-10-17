import Foundation
import XCTest
@testable import NativeMarkKit

final class FencedcodeblocksTest: XCTestCase {
    func testCase89() throws {
        // HTML: <pre><code>&lt;\n &gt;\n</code></pre>\n
        /* Markdown
         ```
         <
         >
         ```
         
         */
        XCTAssertEqual(try compile("```\n<\n >\n```\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "", content: "<\n >\n", range: (0, 0)-(3, 3)))
                       ]))
    }
    
    func testCase90() throws {
        // HTML: <pre><code>&lt;\n &gt;\n</code></pre>\n
        /* Markdown
         ~~~
         <
         >
         ~~~
         
         */
        XCTAssertEqual(try compile("~~~\n<\n >\n~~~\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "", content: "<\n >\n", range: (0, 0)-(3, 3)))
                       ]))
    }
    
    func testCase91() throws {
        // HTML: <p><code>foo</code></p>\n
        /* Markdown
         ``
         foo
         ``
         
         */
        XCTAssertEqual(try compile("``\nfoo\n``\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .code(InlineCode(code: InlineString(text: "foo", range: (1, 0)-(1, 2)),
                                             range: (0, 0)-(2,1)))
                        ],
                        range: (0, 0)-(2, 2)))
                       ]))
    }
    
    func testCase92() throws {
        // HTML: <pre><code>aaa\n~~~\n</code></pre>\n
        /* Markdown
         ```
         aaa
         ~~~
         ```
         
         */
        XCTAssertEqual(try compile("```\naaa\n~~~\n```\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "",
                                             content: "aaa\n~~~\n",
                                             range: (0, 0)-(3, 3)))
                       ]))
    }
    
    func testCase93() throws {
        // HTML: <pre><code>aaa\n```\n</code></pre>\n
        /* Markdown
         ~~~
         aaa
         ```
         ~~~
         
         */
        XCTAssertEqual(try compile("~~~\naaa\n```\n~~~\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "",
                                             content: "aaa\n```\n",
                                             range: (0, 0)-(3, 3)))
                       ]))
    }
    
    func testCase94() throws {
        // HTML: <pre><code>aaa\n```\n</code></pre>\n
        /* Markdown
         ````
         aaa
         ```
         ``````
         
         */
        XCTAssertEqual(try compile("````\naaa\n```\n``````\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "",
                                             content: "aaa\n```\n",
                                             range: (0, 0)-(3, 6)))
                       ]))
    }
    
    func testCase95() throws {
        // HTML: <pre><code>aaa\n~~~\n</code></pre>\n
        /* Markdown
         ~~~~
         aaa
         ~~~
         ~~~~
         
         */
        XCTAssertEqual(try compile("~~~~\naaa\n~~~\n~~~~\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "",
                                             content: "aaa\n~~~\n",
                                             range: (0, 0)-(3, 4)))
                       ]))
    }
    
    func testCase96() throws {
        // HTML: <pre><code></code></pre>\n
        /* Markdown
         ```
         
         */
        XCTAssertEqual(try compile("```\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "",
                                             content: "",
                                             range: (0, 0)-(1, 0)))
                       ]))
    }
    
    func testCase97() throws {
        // HTML: <pre><code>\n```\naaa\n</code></pre>\n
        /* Markdown
         `````
         
         ```
         aaa
         
         */
        XCTAssertEqual(try compile("`````\n\n```\naaa\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "",
                                             content: "\n```\naaa\n",
                                             range: (0, 0)-(4, 0)))
                       ]))
    }
    
    func testCase98() throws {
        // HTML: <blockquote>\n<pre><code>aaa\n</code></pre>\n</blockquote>\n<p>bbb</p>\n
        /* Markdown
         > ```
         > aaa
         
         bbb
         
         */
        XCTAssertEqual(try compile("> ```\n> aaa\n\nbbb\n"),
                       Document(elements: [
                        .blockQuote(BlockQuote(blocks: [
                            .codeBlock(CodeBlock(infoString: "",
                                                 content: "aaa\n",
                                                 range: (0, 2)-(1, 5)))
                        ],
                        range: (0, 0)-(1, 5))),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "bbb", range: (3,0)-(3,2)))
                        ],
                        range: (3, 0)-(3, 3)))
                       ]))
    }
    
    func testCase99() throws {
        // HTML: <pre><code>\n  \n</code></pre>\n
        /* Markdown
         ```
         
         
         ```
         
         */
        XCTAssertEqual(try compile("```\n\n  \n```\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "",
                                             content: "\n  \n",
                                             range: (0, 0)-(3, 3)))
                       ]))
    }
    
    func testCase100() throws {
        // HTML: <pre><code></code></pre>\n
        /* Markdown
         ```
         ```
         
         */
        XCTAssertEqual(try compile("```\n```\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "",
                                             content: "",
                                             range: (0, 0)-(1, 3)))
                       ]))
    }
    
    func testCase101() throws {
        // HTML: <pre><code>aaa\naaa\n</code></pre>\n
        /* Markdown
         ```
         aaa
         aaa
         ```
         
         */
        XCTAssertEqual(try compile(" ```\n aaa\naaa\n```\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "",
                                             content: "aaa\naaa\n",
                                             range: (0, 1)-(3, 3)))
                       ]))
    }
    
    func testCase102() throws {
        // HTML: <pre><code>aaa\naaa\naaa\n</code></pre>\n
        /* Markdown
         ```
         aaa
         aaa
         aaa
         ```
         
         */
        XCTAssertEqual(try compile("  ```\naaa\n  aaa\naaa\n  ```\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "",
                                             content: "aaa\naaa\naaa\n",
                                             range: (0, 2)-(4, 5)))
                       ]))
    }
    
    func testCase103() throws {
        // HTML: <pre><code>aaa\n aaa\naaa\n</code></pre>\n
        /* Markdown
         ```
         aaa
         aaa
         aaa
         ```
         
         */
        XCTAssertEqual(try compile("   ```\n   aaa\n    aaa\n  aaa\n   ```\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "",
                                             content: "aaa\n aaa\naaa\n",
                                             range: (0, 3)-(4, 6)))
                       ]))
    }
    
    func testCase104() throws {
        // HTML: <pre><code>```\naaa\n```\n</code></pre>\n
        /* Markdown
         ```
         aaa
         ```
         
         */
        XCTAssertEqual(try compile("    ```\n    aaa\n    ```\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "",
                                             content: "```\naaa\n```\n",
                                             range: (0, 4)-(3, 0)))
                       ]))
    }
    
    func testCase105() throws {
        // HTML: <pre><code>aaa\n</code></pre>\n
        /* Markdown
         ```
         aaa
         ```
         
         */
        XCTAssertEqual(try compile("```\naaa\n  ```\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "",
                                             content: "aaa\n",
                                             range: (0, 0)-(2, 5)))
                       ]))
    }
    
    func testCase106() throws {
        // HTML: <pre><code>aaa\n</code></pre>\n
        /* Markdown
         ```
         aaa
         ```
         
         */
        XCTAssertEqual(try compile("   ```\naaa\n  ```\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "",
                                             content: "aaa\n",
                                             range: (0, 3)-(2, 5)))
                       ]))
    }
    
    func testCase107() throws {
        // HTML: <pre><code>aaa\n    ```\n</code></pre>\n
        /* Markdown
         ```
         aaa
         ```
         
         */
        XCTAssertEqual(try compile("```\naaa\n    ```\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "",
                                             content: "aaa\n    ```\n",
                                             range: (0, 0)-(3, 0)))
                       ]))
    }
    
    func testCase108() throws {
        // HTML: <p><code> </code>\naaa</p>\n
        /* Markdown
         ``` ```
         aaa
         
         */
        XCTAssertEqual(try compile("``` ```\naaa\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .code(InlineCode(code: InlineString(text: " ", range: (0, 3)-(0, 3)),
                                             range: (0, 0)-(0, 6))),
                            .softbreak(InlineSoftbreak(range: (0, 7)-(0, 7))),
                            .text(InlineString(text: "aaa", range: (1,0)-(1,2)))
                        ],
                        range: (0, 0)-(1, 3)))
                       ]))
    }
    
    func testCase109() throws {
        // HTML: <pre><code>aaa\n~~~ ~~\n</code></pre>\n
        /* Markdown
         ~~~~~~
         aaa
         ~~~ ~~
         
         */
        XCTAssertEqual(try compile("~~~~~~\naaa\n~~~ ~~\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "",
                                             content: "aaa\n~~~ ~~\n",
                                             range: (0, 0)-(3, 0)))
                       ]))
    }
    
    func testCase110() throws {
        // HTML: <p>foo</p>\n<pre><code>bar\n</code></pre>\n<p>baz</p>\n
        /* Markdown
         foo
         ```
         bar
         ```
         baz
         
         */
        XCTAssertEqual(try compile("foo\n```\nbar\n```\nbaz\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo", range: (0,0)-(0,2)))
                        ],
                        range: (0, 0)-(0, 3))),
                        .codeBlock(CodeBlock(infoString: "",
                                             content: "bar\n",
                                             range: (1, 0)-(3, 3))),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "baz", range: (4,0)-(4,2)))
                        ],
                        range: (4, 0)-(4, 3)))
                       ]))
    }
    
    func testCase111() throws {
        // HTML: <h2>foo</h2>\n<pre><code>bar\n</code></pre>\n<h1>baz</h1>\n
        /* Markdown
         foo
         ---
         ~~~
         bar
         ~~~
         # baz
         
         */
        XCTAssertEqual(try compile("foo\n---\n~~~\nbar\n~~~\n# baz\n"),
                       Document(elements: [
                        .heading(Heading(level: 2,
                                         text: [
                                            .text(InlineString(text: "foo", range: (0,0)-(0,2)))
                                         ],
                                         range: (0, 0)-(1, 3))),
                        .codeBlock(CodeBlock(infoString: "",
                                             content: "bar\n",
                                             range: (2, 0)-(4, 3))),
                        .heading(Heading(level: 1,
                                         text: [
                                            .text(InlineString(text: "baz", range: (5,2)-(5,4)))
                                         ],
                                         range: (5, 0)-(5, 5)))
                       ]))
    }
    
    func testCase112() throws {
        // HTML: <pre><code class=\"language-ruby\">def foo(x)\n  return 3\nend\n</code></pre>\n
        /* Markdown
         ```ruby
         def foo(x)
         return 3
         end
         ```
         
         */
        XCTAssertEqual(try compile("```ruby\ndef foo(x)\n  return 3\nend\n```\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "ruby",
                                             content: "def foo(x)\n  return 3\nend\n",
                                             range: (0, 0)-(4, 3)))
                       ]))
    }
    
    func testCase113() throws {
        // HTML: <pre><code class=\"language-ruby\">def foo(x)\n  return 3\nend\n</code></pre>\n
        /* Markdown
         ~~~~    ruby startline=3 $%@#$
         def foo(x)
         return 3
         end
         ~~~~~~~
         
         */
        XCTAssertEqual(try compile("~~~~    ruby startline=3 $%@#$\ndef foo(x)\n  return 3\nend\n~~~~~~~\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "ruby",
                                             content: "def foo(x)\n  return 3\nend\n",
                                             range: (0, 0)-(4, 7)))
                       ]))
    }
    
    func testCase114() throws {
        // HTML: <pre><code class=\"language-;\"></code></pre>\n
        /* Markdown
         ````;
         ````
         
         */
        XCTAssertEqual(try compile("````;\n````\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: ";",
                                             content: "",
                                             range: (0, 0)-(1, 4)))
                       ]))
    }
    
    func testCase115() throws {
        // HTML: <p><code>aa</code>\nfoo</p>\n
        /* Markdown
         ``` aa ```
         foo
         
         */
        XCTAssertEqual(try compile("``` aa ```\nfoo\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .code(InlineCode(code: InlineString(text: "aa", range: (0, 4)-(0, 5)),
                                             range: (0, 0)-(0, 9))),
                            .softbreak(InlineSoftbreak(range: (0, 10)-(0, 10))),
                            .text(InlineString(text: "foo", range: (1,0)-(1,2)))
                        ],
                        range: (0, 0)-(1, 3)))
                       ]))
    }
    
    func testCase116() throws {
        // HTML: <pre><code class=\"language-aa\">foo\n</code></pre>\n
        /* Markdown
         ~~~ aa ``` ~~~
         foo
         ~~~
         
         */
        XCTAssertEqual(try compile("~~~ aa ``` ~~~\nfoo\n~~~\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "aa",
                                             content: "foo\n",
                                             range: (0, 0)-(2, 3)))
                       ]))
    }
    
    func testCase117() throws {
        // HTML: <pre><code>``` aaa\n</code></pre>\n
        /* Markdown
         ```
         ``` aaa
         ```
         
         */
        XCTAssertEqual(try compile("```\n``` aaa\n```\n"),
                       Document(elements: [
                        .codeBlock(CodeBlock(infoString: "",
                                             content: "``` aaa\n",
                                             range: (0, 0)-(2, 3)))
                       ]))
    }
    
    
}
