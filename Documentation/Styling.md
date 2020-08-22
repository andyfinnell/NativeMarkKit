# Styling

NativeMarkKit provides style sheets as a mechanism to customize how NativeMark is rendered. NativeMarkKit provides a default style sheet which uses the system fonts, Dynamic Type, and Dark Mode where available. It's possible to modify the default style sheet in order to create a global appearance across the app. It's also possible to create a one-off style sheet for a subset of views that need a unique appearance.

The `StyleSheet` data structure maps _selectors_ to a set of _rules_. The selector tells the style sheet what to apply the associated rules too. Selectors are broken up into block selectors (e.g. paragraph, heading, list, block quote, etc) and inline selectors (e.g. emphasis, strong, link, and inline code). The difference between selectors is because certain rules only make sense to apply to block elements (e.g. indents, paragraph spacing, etc). The rules set rendering attributes. They can modify the text color, font, paragraph indent, background colors, etc. 

When rendering NativeMark, the rules will stack. For example, when rendering an emphasis in a paragraph, NativeMarkKit will first apply all the rules for the document selector, then the paragraph selector on top of that, then finally the emphasis selector rules. This allows you to set defaults at a document level, then let selectors for elements further down in the document tree override them.

## Setting up a global stylesheet

NativeMarkKit provides `StyleSheet.default` as the default style sheet. By default, all views will use this style sheet. That allows the app to modify the `.default` style sheet to enforce a global style across the app. Modifying the default style sheet does need to be done at app startup before any views that use it are created.

A common task for iOS apps is setting the brand font and color:

```Swift
let myFont = FontName.custom("FancypantsFont")
let myTintColor = UIColor() // whatever your app color is
StyleSheet.default.mutate(
    block: [
        .document: [
            .textStyle(.custom(name: myFont, size: scaled(to: .body)))
        ],
        .heading(level: 1): [
            .textStyle(.custom(name: myFont, size: scaled(to: .largeTitle)))
        ],
        .heading(level: 2): [
            .textStyle(.custom(name: myFont, size: scaled(to: .title1)))
        ],
        .heading(level: 3): [
            .textStyle(.custom(name: myFont, size: scaled(to: .title2)))
        ],
        .heading(level: 4): [
            .textStyle(.custom(name: myFont, size: scaled(to: .title3)))
        ]
    ],
    inline: [
        .link: [
            .textColor(myTintColor)
        ]
    ]
)
```

This sets the default body font and the first four levels of headings to use the app's custom font. The `scaled(to:)` value means NativeMarkKit will scale the font to match the Dynamic Type size for the correspond text style. Finally, this updates the link's color to use the app's tint color.

## Setting up a one-off style sheet

There may be times where an app needs to unique style for only a few views. In that case, you'll probably want to duplicate the default style sheet, and then modify the duplicate.

As an example, let's assume the app has a section of text that needs a custom background color (maybe because it's in a secondary section).

```Swift
let secondaryStyleSheet = StyleSheet.default.duplicate().mutate(
    block: [
        .document: [
            .backgroundColor(.lightGrayColor)
        ]
    ]
)

// later, in view code
let label = NativeMarkLabel(nativeMark: "My _NativeMark_ code", styleSheet: secondaryStyleSheet)
```

Here we duplicate the default style sheet. By starting with the default, we only have to specify the render attributes we want to be different. By duplicating it before mutating it, we ensure that we're not making a global change to all views. Finally, we need to manually specify the style sheet for any views that we want to use it.
