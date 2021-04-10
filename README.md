#  Creating Custom XCGrapher plugins

Here's how you can use Swift to write a dylib plugin for [xcgrapher](https://github.com/maxchuquimia/xcgrapher).

## Setup

#### Create a Swift Package that exposes your plugin as a `.dynamic` library

```swift
let package = Package(
    name: "MyPlugin",
    products: [
        .library(name: "MyPlugin", type: .dynamic, targets: ["MyPlugin"]),
    ],
    dependencies: [
        .package(url: "https://github.com/maxchuquimia/XCGrapherPluginSupport.git", from: "0.0.6"),
    ],
    targets: [
        .target(
            name: "MyPlugin", 
            dependencies: [
                .product(name: "XCGrapherPluginSupport", package: "xcgrapher")
            ]
        ),
    ]
)
```
#### Subclass XCGrapherPlugin

```swift
import XCGrapherPluginSupport

class MyPlugin: XCGrapherPlugin {
    // ...
}
```
(Providing a superclass rather than a protocol was a strategic decision to make both dylib loading and future proofing better for everyone)

#### Create a function that XCGrapher can call to create an instance of your plugin
You must use the `@_cdecl` attribute to force the compiler to use the symbol name `makeXCGrapherPlugin`. The following snippet needs to be copied somewhere in your library with only `MyPlugin` changed to the name of your  `XCGrapherPlugin` subclass:
```swift
@_cdecl("makeXCGrapherPlugin")
public func makeXCGrapherPlugin() -> UnsafeMutableRawPointer {
    Unmanaged.passRetained(MyPlugin()).toOpaque()
}
```

## Creating your own graph heirachy

### Processing Source Code

`XCGrapherPlugin` has some overrideable `process(x:)` functions that can be used to build up information about your project's source code.
These processing functions allow you to return your own object/s so that you can represent your code in a way that is easiest to you.

#### process(file:)
```swift
public override func process(file: XCGrapherFile) throws -> [Any] {
    // ...
}
```
This function is called once for every source file in your project and once for every source file in your Swift Package dependencies (if `--spm` is passed to `xcgrapher`). The model `XCGrapherFile` contains convenient about the source file that you can then parse in your own way (see _[XCGrapherFile.swift](https://github.com/maxchuquimia/XCGrapherPluginSupport/tree/master/Sources/XCGrapherPluginSupport/XCGrapherFile.swift))_.

#### process(library:)
```swift
public override func process(library: XCGrapherImport) throws -> [Any] {
    // ...
}
```

This function is called once for every `import SomeLibrary` line in your projects (depending on the flags passed to `xcgrapher`). `SomeLibrary` is represented by the `XCGrapherImport` model. See _[XCGrapherImport.swift](https://github.com/maxchuquimia/XCGrapherPluginSupport/tree/master/Sources/XCGrapherPluginSupport/XCGrapherImport.swift))_ for available parameters.


### Drawing Arrows

The arrays returned by the processing functions listed above will be concatenated and returned to you for final consolidation in the `makeArrows(from:)` function:
```swift
open func makeArrows(from processResults: [Any]) throws -> [XCGrapherArrow] {
    // ...
}
```
In here you should loop through `processResults` as you see fit so as to return a list of `XCGrapherArrow` models that will be passed to GraphViz and drawn to `xcgrapher`'s `--output` png file. It's safe to return the same arrow twice  as `xcgrapher` will remove duplicates for you.

## Building and running

Build your plugin from the command line:
```bash
swift build -c release --disable-sandbox
```
This will create your dylib at the path `.build/release/libMyPlugin.dylib`

Now you can run `xcgrapher` with the `--plugin` option and tell it to use your newly built dylib to process each file!

```bash
xcgrapher --project .. --target .. --spm .. --plugin .build/release/libMyPlugin.dylib
```

## Live Examples
- The default behaviour of `xcgrapher` (drawing imports as arrows originating from the main target) is implemented in a plugin: [XCGrapherModuleImportPlugin](https://github.com/maxchuquimia/xcgrapher/tree/master/Sources/XCGrapherModuleImportPlugin)
