# HtmlEntities

This is a simple script that converts HTML entity data in `entities.json` into
a native Swift dictionary that can be used by the framework. It normalizes the
entity to lowercase.

`entities.json` was fetched from [here](https://html.spec.whatwg.org/entities.json).

To generate, from the command line:

    swift main.swift

Then copy the resulting `HtmlEntities.swift` file into the NativeMarkKit sources.