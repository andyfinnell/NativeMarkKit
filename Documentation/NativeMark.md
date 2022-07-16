# NativeMark

NativeMark is a flavor of [Markdown](https://daringfireball.net/projects/markdown/) 
designed to be rendered in native apps. It can do basic text styling, lists, images, 
block quotes, and code. Below are some examples, however they are not exhaustive. 
As a guideline, if CommonMark supports a Markdown syntax, NativeMark does, too. 
The one exception is raw HTML tags are not supported by NativeMark.

## Headers

```Markdown
# First level header
## Second level header
###### Sixth level header
```

## Paragraphs

```Markdown
Paragraphs are just 
pieces of text that are 
separated by blank
lines.

For example, this begins
a new paragraph.
```

## Blockquotes

```Markdown
> If you want to longform quote
> someone, this is all you need.
```

## Unordered lists

```Markdown
- List item one
- Second list item
     * Sublist
```

## Ordered lists

```Markdown
1. Blue
1. Green
1. Read
```

## Task lists

```Markdown
- [ ] One
- [x] Two
- [ ] Three
```

## Text styling

```Markdown
With NativeMark you can _emphasize_ or **bold** text. You can also 
create [links](https://losingfight.com/blog) or mark `inline code`.
NativeMark also supports Github Flavored Markdown's ~~strikethrough~~.
```

## Images

```Markdown
![Alt text - kitten](https://placekitten/g/200/300)
```

## Code blocks

    ```Swift
    struct MyStruct {
        let foo: Int
        let bar: String
    }
    ```
